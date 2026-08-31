/// oAdminLayerCannonProjectile — Step


// ====================================================
// HOT-RELOAD SOUND SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_bounce"))
{
    snd_bounce =
    [
        asset_get_index(
            "BouncingBallGunBounce1"
        ),

        asset_get_index(
            "BouncingBallGunBounce2"
        ),

        asset_get_index(
            "BouncingBallGunBounce3"
        )
    ];
}


if (!variable_instance_exists(id, "bounce_sound_gain"))
{
    bounce_sound_gain =
        1.0;
}


if (!variable_instance_exists(id, "bounce_sound_cooldown_frames"))
{
    bounce_sound_cooldown_frames =
        2;
}


if (!variable_instance_exists(id, "bounce_sound_cooldown"))
{
    bounce_sound_cooldown =
        0;
}


if (!variable_instance_exists(id, "play_bounce_sound"))
{
    play_bounce_sound = function()
    {
        if (bounce_sound_cooldown > 0)
        {
            return;
        }


        var valid_sounds = [];


        for (
            var i = 0;
            i < array_length(snd_bounce);
            i++
        )
        {
            if (snd_bounce[i] != -1)
            {
                array_push(
                    valid_sounds,
                    snd_bounce[i]
                );
            }
        }


        if (array_length(valid_sounds) <= 0)
        {
            return;
        }


        var snd =
            valid_sounds[
                irandom(
                    array_length(valid_sounds) - 1
                )
            ];


        var voice =
            audio_play_sound(
                snd,
                100,
                false
            );


        if (voice != noone)
        {
            audio_sound_gain(
                voice,
                bounce_sound_gain,
                0
            );
        }


        bounce_sound_cooldown =
            bounce_sound_cooldown_frames;
    };
}


// ====================================================
// WAIT UNTIL CANNON INITIALISES US
// ====================================================

if (
    !variable_instance_exists(
        id,
        "projectile_ready"
    )
    ||
    !projectile_ready
)
{
    exit;
}


// ====================================================
// PAUSE / DEATH FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed =
        0;


    exit;
}


// ====================================================
// BOUNCE SOUND COOLDOWN
// ====================================================

if (bounce_sound_cooldown > 0)
{
    bounce_sound_cooldown--;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    instance_destroy();

    exit;
}


// ====================================================
// LIFETIME
// ====================================================

life_timer--;


if (life_timer <= 0)
{
    instance_destroy();

    exit;
}


// ====================================================
// SUB-STEP MOVEMENT
// ====================================================

var max_component =
    max(
        abs(hsp),
        abs(vsp)
    );


var move_steps =
    max(
        1,
        ceil(
            max_component
        )
    );


var step_x =
    hsp /
    move_steps;


var step_y =
    vsp /
    move_steps;


// ====================================================
// MOVE / BOUNCE
// ====================================================

for (
    var move_i = 0;
    move_i < move_steps;
    move_i++
)
{
    // =================================================
    // X AXIS
    // =================================================

    if (abs(step_x) > 0.0001)
    {
        if (
            hits_solid(
                x + step_x,
                y
            )
        )
        {
            hsp =
                -hsp *
                bounce_retention;


            step_x =
                hsp /
                move_steps;


            // -----------------------------------------
            // WALL BOUNCE SOUND
            // -----------------------------------------

            play_bounce_sound();
        }
        else
        {
            var old_x =
                x;


            var old_y =
                y;


            x +=
                step_x;


            update_trail(
                old_x,
                old_y,
                x,
                y
            );
        }
    }


    // =================================================
    // Y AXIS
    // ====================================================

    if (abs(step_y) > 0.0001)
    {
        if (
            hits_solid(
                x,
                y + step_y
            )
        )
        {
            vsp =
                -vsp *
                bounce_retention;


            step_y =
                vsp /
                move_steps;


            // -----------------------------------------
            // FLOOR / CEILING BOUNCE SOUND
            //
            // If this is the same corner impact as the
            // X bounce immediately above, the tiny
            // cooldown prevents a second stacked sound.
            // -----------------------------------------

            play_bounce_sound();
        }
        else
        {
            var old_x_y =
                x;


            var old_y_y =
                y;


            y +=
                step_y;


            update_trail(
                old_x_y,
                old_y_y,
                x,
                y
            );
        }
    }


    // =================================================
    // PLAYER COLLISION
    // ====================================================

    var p =
        instance_find(
            oPlayer,
            0
        );


    if (p != noone)
    {
        var player_dead =
            variable_instance_exists(
                p,
                "state"
            )
            &&
            p.state == "dead";


        if (!player_dead)
        {
            var r =
                max(
                    0,
                    collision_radius -
                    player_hit_pad
                );


            var player_hit =
                p.bbox_right >
                    x - r
                &&
                p.bbox_left <
                    x + r
                &&
                p.bbox_bottom >
                    y - r
                &&
                p.bbox_top <
                    y + r;


            if (player_hit)
            {
                with (p)
                {
                    scr_player_died();
                }


                exit;
            }
        }
    }
}


// ====================================================
// KEEP PROJECTILE SPRITE ON SELECTED COLOUR FRAME
// ====================================================

image_speed =
    0;


image_index =
    projectile_frame;