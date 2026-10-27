
/// oFirstSpawnSparks — Step


// ====================================================
// PAUSE
// ====================================================

if (variable_global_exists("game_phase"))
{
    if (
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu" ||
        global.game_phase == "codec"
    )
    {
        exit;
    }
}


// ====================================================
// FIND PLAYER
// ====================================================

if (!instance_exists(player_ref))
{
    player_ref = instance_find(oPlayer, 0);
}

if (!instance_exists(player_ref))
{
    exit;
}


// ====================================================
// WAIT FOR FIRST SPAWN
// ====================================================

if (!sequence_detected)
{
    var fs = instance_find(oFirstSpawn, 0);

    if (instance_exists(fs))
    {
        if (
            variable_instance_exists(fs, "started") &&
            fs.started
        )
        {
            sequence_detected = true;
        }
    }

    // Do not play when loading a save or entering
    // the room without the first-spawn cinematic.
    if (
        !sequence_detected &&
        !instance_exists(oFirstSpawn)
    )
    {
        instance_destroy();
    }

    exit;
}


// ====================================================
// INITIAL DELAY
// ====================================================

if (!effect_started)
{
    delay_timer++;

    if (delay_timer >= start_delay)
    {
        effect_started = true;
        effect_timer = 0;
    }

    exit;
}


// ====================================================
// EFFECT DURATION
// ====================================================

effect_timer++;

if (effect_timer >= effect_duration)
{
    instance_destroy();
    exit;
}


// ====================================================
// UPDATE EXISTING SPARKS
// ====================================================

var updated_sparks = [];

for (var i = 0; i < array_length(sparks); i++)
{
    var s = sparks[i];

    s.life--;

    if (s.life > 0)
    {
        s.x += s.vx;
        s.y += s.vy;

        array_push(updated_sparks, s);
    }
}

sparks = updated_sparks;


// ====================================================
// CREATE NEW SPARKS
// ====================================================

if (
    random(1) < spark_chance &&
    array_length(sparks) < max_sparks
)
{
    // Occasionally generate two sparks together.
    var count = choose(1, 1, 1, 2);

    for (var n = 0; n < count; n++)
    {
        if (array_length(sparks) >= max_sparks)
            break;

        // Relative to JumpBot's sprite.
        var ox = irandom_range(
            -spark_radius_x,
            spark_radius_x
        );

        var oy = irandom_range(
            -spark_radius_y,
            spark_radius_y
        );

        // Bias sparks towards the outer edges.
        if (abs(ox) < 7)
        {
            ox =
                choose(-1, 1) *
                irandom_range(7, spark_radius_x);
        }

        var a = irandom_range(0, 359);

        // FIX: spark_speed instead of built-in speed.
        var spark_speed =
            random_range(0.15, 0.65);

        var s = {
            x: ox,
            y: oy,

            vx: lengthdir_x(spark_speed, a),
            vy: lengthdir_y(spark_speed, a),

            angle: a,

            length: irandom_range(
                spark_length_min,
                spark_length_max
            ),

            life: irandom_range(
                spark_life_min,
                spark_life_max
            ),

            max_life: 0,

            colour: choose(
                spark_yellow,
                spark_yellow,
                spark_bright,
                spark_orange
            )
        };

        s.max_life = s.life;

        array_push(sparks, s);
    }
}
