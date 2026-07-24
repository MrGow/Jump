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


// ====================================================
// RESUME
// ====================================================

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
        // No visual floor inset while airborne.
        draw_ground_offset = 0;
        bob_offset = 0;


        vspeed +=
            gravity_amount;


        x += hspeed;
        y += vspeed;


        // ------------------------------------------------
        // Check beneath mine
        // ------------------------------------------------

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
            // Pull the actual collision position back
            // out of the floor.
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


            // Visual sprite now sinks into the oblique
            // tile while collision remains at floor level.
            draw_ground_offset =
                ground_draw_inset;
        }
    }
    break;


    // =================================================
    // ARMED
    // =================================================

    case "armed":
    {
        draw_ground_offset =
            ground_draw_inset;


        // ------------------------------------------------
        // Tiny visual idle bob
        // ------------------------------------------------

        bob_t +=
            bob_speed;


        bob_offset =
            sin(
                bob_t
            )
            *
            bob_amount;


        if (arm_timer > 0)
        {
            arm_timer--;
        }


        // =================================================
        // DISTANCE-BASED BEEP LOOP
        //
        // Only the TWO closest armed mines may produce
        // their looping beep.
        // =================================================

        var target_beep_gain = 0;


        var p =
            instance_find(
                oPlayer,
                0
            );


        if (p != noone)
        {
            var my_dist =
                point_distance(
                    x,
                    y,
                    p.x,
                    p.y
                );


            // Only bother competing for an audio slot
            // when inside audible range.
            if (
                my_dist <
                beep_outer_dist
            )
            {
                var closer_count = 0;


                var mine_count =
                    instance_number(
                        oGunShipMine
                    );


                for (
                    var i = 0;
                    i < mine_count;
                    i++
                )
                {
                    var other_mine =
                        instance_find(
                            oGunShipMine,
                            i
                        );


                    if (
                        other_mine == noone ||
                        other_mine == id
                    )
                    {
                        continue;
                    }


                    // Only armed mines compete.
                    if (
                        !variable_instance_exists(
                            other_mine,
                            "state"
                        )
                        ||
                        other_mine.state != "armed"
                    )
                    {
                        continue;
                    }


                    var other_dist =
                        point_distance(
                            other_mine.x,
                            other_mine.y,
                            p.x,
                            p.y
                        );


                    if (
                        other_dist <
                        my_dist
                    )
                    {
                        closer_count++;


                        if (
                            closer_count >=
                            beep_max_voices
                        )
                        {
                            break;
                        }
                    }
                }


                // ------------------------------------------------
                // This mine is one of the two closest.
                // ------------------------------------------------

                if (
                    closer_count <
                    beep_max_voices
                )
                {
                    if (
                        my_dist <=
                        beep_inner_dist
                    )
                    {
                        target_beep_gain =
                            beep_max_gain;
                    }
                    else
                    {
                        var fade_amount =
                            (
                                my_dist -
                                beep_inner_dist
                            )
                            /
                            max(
                                1,
                                beep_outer_dist -
                                beep_inner_dist
                            );


                        target_beep_gain =
                            beep_max_gain *
                            (
                                1 -
                                clamp(
                                    fade_amount,
                                    0,
                                    1
                                )
                            );
                    }
                }
            }
        }


        // =================================================
        // START / UPDATE / STOP LOOP
        // =================================================

        if (
            target_beep_gain <= 0
        )
        {
            if (
                beep_instance != noone
            )
            {
                audio_stop_sound(
                    beep_instance
                );

                beep_instance =
                    noone;
            }
        }
        else if (
            snd_beep != -1 &&
            audio_group_is_loaded(
                audiogroupsfx
            )
        )
        {
            // --------------------------------------------
            // Start when this mine gains an audio slot.
            // --------------------------------------------

            if (
                beep_instance == noone
            )
            {
                beep_instance =
                    audio_play_sound(
                        snd_beep,
                        -65,
                        true
                    );


                if (
                    beep_instance != noone
                )
                {
                    audio_sound_gain(
                        beep_instance,
                        0,
                        0
                    );


                    audio_sound_pitch(
                        beep_instance,
                        beep_pitch
                    );
                }
            }


            // --------------------------------------------
            // Smooth distance-volume changes.
            // --------------------------------------------

            if (
                beep_instance != noone
            )
            {
                audio_sound_gain(
                    beep_instance,
                    target_beep_gain,
                    120
                );
            }
        }


        // =================================================
        // PLAYER CONTACT
        // =================================================

        if (
            arm_timer <= 0
        )
        {
            var hit_player =
                instance_place(
                    x,
                    y,
                    oPlayer
                );


            if (
                hit_player != noone &&
                !(
                    variable_instance_exists(
                        hit_player,
                        "state"
                    )
                    &&
                    hit_player.state ==
                    "dead"
                )
            )
            {
                state =
                    "exploding";


                explosion_timer =
                    explosion_time;


                // Stop beeping immediately.
                if (
                    beep_instance != noone
                )
                {
                    audio_stop_sound(
                        beep_instance
                    );

                    beep_instance =
                        noone;
                }


                scr_play_sfx(
                    snd_explode,
                    1,
                    random_range(
                        0.96,
                        1.04
                    )
                );


                // ----------------------------------------
                // Camera shake
                // ----------------------------------------

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


                with (hit_player)
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
        bob_offset = 0;


        if (
            beep_instance != noone
        )
        {
            audio_stop_sound(
                beep_instance
            );

            beep_instance =
                noone;
        }


        explosion_timer--;


        if (
            explosion_timer <= 0
        )
        {
            instance_destroy();
        }
    }
    break;
}