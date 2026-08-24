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


// Restore correct animation speed.
if (state == "exploding")
{
    image_speed =
        explosion_image_speed;
}
else
{
    image_speed = 0.20;
}


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


// ====================================================
// BEGIN EXPLOSION
// ====================================================

var begin_explosion =
function()
{
    if (state == "exploding")
    {
        return;
    }


    state = "exploding";
    armed = false;


    // ------------------------------------------------
    // STOP BEEP
    // ------------------------------------------------

    if (beep_instance != noone)
    {
        audio_stop_sound(
            beep_instance
        );

        beep_instance =
            noone;
    }


    // ------------------------------------------------
    // CAPTURE EXPLOSION POSITION
    //
    // Mine:
    //     Top Left origin
    //
    // Explosion:
    //     Bottom Centre origin
    //
    // Capture mine's VISUAL bottom-centre before
    // switching sprites.
    // ------------------------------------------------

    explosion_draw_x =
        x +
        (
            sprite_get_width(
                spriteGunShipMine
            )
            *
            0.5
        );


    explosion_draw_y =
        y +
        draw_ground_offset +
        bob_offset +
        sprite_get_height(
            spriteGunShipMine
        );


    // ------------------------------------------------
    // EXPLOSION SPRITE
    // ------------------------------------------------

    sprite_index =
        explosion_sprite;

    image_index = 0;

    image_speed =
        explosion_image_speed;


    // Stop movement.
    hspeed = 0;
    vspeed = 0;

    bob_offset = 0;


    // Safety timer.
    explosion_timer =
        explosion_time;


    // ------------------------------------------------
    // EXPLOSION SOUND
    // ------------------------------------------------

    scr_play_sfx(
        snd_explode,
        1,
        random_range(
            0.96,
            1.04
        )
    );


    // ------------------------------------------------
    // CAMERA SHAKE
    // ------------------------------------------------

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
};


// ====================================================
// EXPLODING
// ====================================================

if (state == "exploding")
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


    explosion_timer--;


    var explosion_frames =
        max(
            1,
            sprite_get_number(
                sprite_index
            )
        );


    // ------------------------------------------------
    // Destroy after explosion animation finishes.
    // ------------------------------------------------

    if (
        image_index >=
        explosion_frames - 1
    )
    {
        instance_destroy();
        exit;
    }


    // ------------------------------------------------
    // Safety fallback.
    // ------------------------------------------------

    if (
        explosion_timer <= 0
    )
    {
        instance_destroy();
        exit;
    }


    exit;
}


// ====================================================
// FALLING
// ====================================================

if (state == "falling")
{
    draw_ground_offset = 0;
    bob_offset = 0;


    // ------------------------------------------------
    // GRAVITY
    // ------------------------------------------------

    vspeed +=
        gravity_amount;


    x +=
        hspeed;

    y +=
        vspeed;


    // ------------------------------------------------
    // LOOK FOR FLOOR
    // ------------------------------------------------

    var bottom_y =
        bbox_bottom +
        ground_check_distance;


    var check_left =
        bbox_left + 2;


    var check_middle =
        (
            bbox_left +
            bbox_right
        )
        *
        0.5;


    var check_right =
        bbox_right - 2;


    if (
        point_hits_ground(
            check_left,
            bottom_y
        )
        ||
        point_hits_ground(
            check_middle,
            bottom_y
        )
        ||
        point_hits_ground(
            check_right,
            bottom_y
        )
    )
    {
        // --------------------------------------------
        // Pull mine back out of floor.
        // --------------------------------------------

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


        state =
            "armed";

        armed =
            false;


        arm_timer =
            arm_delay;


        draw_ground_offset =
            ground_draw_inset;


        // --------------------------------------------
        // Lifetime starts after landing.
        // --------------------------------------------

        life_timer =
            mine_lifetime;


        warning_started =
            false;
    }


    exit;
}


// ====================================================
// ARMED / LANDED
// ====================================================

if (state == "armed")
{
    draw_ground_offset =
        ground_draw_inset;


    // =================================================
    // VISUAL BOB
    // =================================================

    bob_t +=
        bob_speed;


    bob_offset =
        sin(
            bob_t
        )
        *
        bob_amount;


    // =================================================
    // ARM DELAY
    // =================================================

    if (!armed)
    {
        arm_timer--;


        if (arm_timer <= 0)
        {
            armed = true;
        }
    }


    // =================================================
    // LIFETIME
    // =================================================

    life_timer--;


    // =================================================
    // WARNING PHASE
    // =================================================

    if (
        !warning_started &&
        life_timer <=
        warning_time
    )
    {
        warning_started =
            true;
    }


    // =================================================
    // AUDIO
    // =================================================

    var target_beep_gain = 0;


    if (p != noone)
    {
        var my_dist =
            point_distance(
                x,
                y,
                p.x,
                p.y
            );


        // ------------------------------------------------
        // Determine whether this mine is one of the
        // closest audible mines.
        // ------------------------------------------------

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


                if (
                    !variable_instance_exists(
                        other_mine,
                        "state"
                    )
                    ||
                    other_mine.state !=
                    "armed"
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
            // Mine gets an audio voice.
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
                        beep_max_gain
                        *
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
    // START / STOP / UPDATE BEEP
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
            }
        }


        if (
            beep_instance != noone
        )
        {
            audio_sound_gain(
                beep_instance,
                target_beep_gain,
                120
            );


            // --------------------------------------------
            // NORMAL / WARNING PITCH
            // --------------------------------------------

            var current_beep_pitch =
                beep_pitch;


            if (warning_started)
            {
                // Gradually get faster during warning.
                var warning_amount =
                    1 -
                    clamp(
                        life_timer /
                        max(
                            1,
                            warning_time
                        ),
                        0,
                        1
                    );


                current_beep_pitch =
                    lerp(
                        beep_pitch,
                        beep_warning_pitch,
                        warning_amount
                    );
            }


            audio_sound_pitch(
                beep_instance,
                current_beep_pitch
            );
        }
    }


    // =================================================
    // PLAYER CONTACT
    //
    // IMPORTANT:
    // Use bbox overlap while mine still has its normal
    // sprite/mask.
    // =================================================

    if (
        armed &&
        p != noone
    )
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
            var hit_player =
                p.bbox_right >
                bbox_left
                &&
                p.bbox_left <
                bbox_right
                &&
                p.bbox_bottom >
                bbox_top
                &&
                p.bbox_top <
                bbox_bottom;


            if (hit_player)
            {
                // ----------------------------------------
                // KILL PLAYER
                //
                // Correct JumpBot death script.
                // ----------------------------------------

                with (p)
                {
                    scr_player_died();
                }


                // ----------------------------------------
                // Then show mine explosion.
                // ----------------------------------------

                begin_explosion();


                exit;
            }
        }
    }


    // =================================================
    // TIMED SELF-DESTRUCTION
    //
    // Timeout clears the mine but does NOT kill the
    // player merely for being nearby.
    // =================================================

    if (life_timer <= 0)
    {
        begin_explosion();

        exit;
    }


    exit;
}