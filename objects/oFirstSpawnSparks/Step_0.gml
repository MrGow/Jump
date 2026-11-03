
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
// UPDATE EXISTING PARTICLES
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

        s.vx *= spark_drag;
        s.vy += spark_gravity;

        array_push(updated_sparks, s);
    }
}

sparks = updated_sparks;

// ====================================================
// CREATE NEW BURST
// ====================================================

if (
    random(1) < spark_chance &&
    array_length(sparks) < max_sparks
)
{
    var px = player_ref.x;
    var py = player_ref.y
           + player_draw_y_offset
           + spark_y_adjust;

    // Select one damaged point on JumpBot.
    // All particles in this burst share the point.

    var side = choose(-1, 1);

    var origin_x = px + side * irandom_range(7, 11);
    var origin_y = py + irandom_range(-8, 7);

    // Occasionally emit from the top.
    if (random(1) < 0.2)
    {
        origin_x = px + irandom_range(-6, 6);
        origin_y = py - 12;
        side = choose(-1, 1);
    }

    var count = irandom_range(burst_min, burst_max);

    for (var n = 0; n < count; n++)
    {
        if (array_length(sparks) >= max_sparks)
            break;

        // Mostly outward and upward.
        var a;

        if (side == 1)
        {
            a = random_range(5, 75);
        }
        else
        {
            a = random_range(105, 175);
        }

        var spark_speed = random_range(
            spark_speed_min,
            spark_speed_max
        );

        var spark_life = irandom_range(
            spark_life_min,
            spark_life_max
        );

        var s = {
            x: origin_x + random_range(-1, 1),
            y: origin_y + random_range(-1, 1),

            vx: lengthdir_x(spark_speed, a),
            vy: lengthdir_y(spark_speed, a),

            life: spark_life,
            max_life: spark_life,

            colour: choose(
                spark_yellow,
                spark_yellow,
                spark_bright,
                spark_bright,
                spark_orange
            ),

            // Most sparks are single pixels.
            size: choose(1, 1, 1, 1, 2)
        };

        array_push(sparks, s);
    }
}
