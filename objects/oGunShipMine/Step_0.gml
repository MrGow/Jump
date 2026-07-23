/// oGunShipMine — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    if (
        beep_instance != noone &&
        !beep_paused
    )
    {
        audio_pause_sound(
            beep_instance
        );

        beep_paused = true;
    }

    exit;
}


// ----------------------------------------------------
// Resume
// ----------------------------------------------------

image_speed = 0.20;

if (
    beep_instance != noone &&
    beep_paused
)
{
    audio_resume_sound(
        beep_instance
    );

    beep_paused = false;
}


// ====================================================
// STATE MACHINE
// ====================================================

switch (state)
{
    // =================================================
    // FALLING
    // =================================================

    case "falling":
    {
        vspeed +=
            gravity_amount;


        x += hspeed;
        y += vspeed;


        // --------------------------------------------
        // Check beneath mine
        // --------------------------------------------

        var bottom_y =
            bbox_bottom +
            ground_check_distance;


        if (
            point_hits_ground(
                x,
                bottom_y
            )
        )
        {
            // Move back upward until clear.
            while (
                point_hits_ground(
                    x,
                    bbox_bottom
                )
            )
            {
                y -= 1;
            }


            hspeed = 0;
            vspeed = 0;


            state = "armed";

            armed = true;

            arm_timer =
                arm_delay;


            beep_timer = 1;
        }
    }
    break;


    // =================================================
    // ARMED
    // =================================================

    case "armed":
    {
        bob_t +=
            bob_speed;


        draw_offset_y =
            sin(
                bob_t
            )
            *
            bob_amount;


        if (arm_timer > 0)
        {
            arm_timer--;
        }


        // --------------------------------------------
        // Beeping
        // --------------------------------------------

        beep_timer--;


        if (
            beep_timer <= 0 &&
            snd_beep != -1 &&
            audio_group_is_loaded(
                audiogroupsfx
            )
        )
        {
            scr_play_sfx(
                snd_beep,
                0.55,
                random_range(
                    0.98,
                    1.02
                )
            );


            beep_timer =
                beep_interval;
        }


        // --------------------------------------------
        // Player contact
        // --------------------------------------------

        if (arm_timer <= 0)
        {
            var p =
                instance_place(
                    x,
                    y,
                    oPlayer
                );


            if (
                p != noone &&
                !(
                    variable_instance_exists(
                        p,
                        "state"
                    )
                    &&
                    p.state ==
                    "dead"
                )
            )
            {
                state =
                    "exploding";

                explosion_timer =
                    explosion_time;


                scr_play_sfx(
                    snd_explode,
                    1,
                    random_range(
                        0.96,
                        1.04
                    )
                );


                if (
                    !variable_global_exists(
                        "shake_mag"
                    )
                )
                {
                    global.shake_mag = 0;
                }


                if (
                    !variable_global_exists(
                        "shake_time"
                    )
                )
                {
                    global.shake_time = 0;
                }


                global.shake_mag =
                    max(
                        global.shake_mag,
                        5
                    );

                global.shake_time =
                    max(
                        global.shake_time,
                        7
                    );


                with (p)
                {
                    scr_player_died();
                }
            }
        }
    }
    break;


    // =================================================
    // EXPLODING
    // =================================================

    case "exploding":
    {
        explosion_timer--;


        if (explosion_timer <= 0)
        {
            instance_destroy();
        }
    }
    break;
}