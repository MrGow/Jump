/// oGunShipMine — Step

// ====================================================
// EXPLOSION
//
// Run this BEFORE the gameplay freeze check. An
// explosion that kills the player must still finish
// animating on the death screen.
// ====================================================

if (state == "exploding")
{
    image_speed = 0;

    image_index += explosion_image_speed;
    explosion_timer--;

    var explosion_frames = max(
        1,
        sprite_get_number(sprite_index)
    );

    if (
        image_index >= explosion_frames ||
        explosion_timer <= 0
    )
    {
        instance_destroy();
    }

    exit;
}


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
        audio_pause_sound(beep_instance);
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
    audio_resume_sound(beep_instance);
    beep_paused = false;
}

image_speed = 0.20;


// ====================================================
// PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);


// ====================================================
// BEGIN EXPLOSION
// ====================================================

var begin_explosion = function()
{
    if (state == "exploding")
    {
        return;
    }

    state = "exploding";
    armed = false;

    if (beep_instance != noone)
    {
        audio_stop_sound(beep_instance);
        beep_instance = noone;
    }

    // Capture the visible mine's bottom centre before
    // changing to the explosion sprite.
    explosion_draw_x =
        x
        +
        sprite_get_width(spriteGunShipMine)
        * 0.5;

    explosion_draw_y =
        y
        +
        draw_ground_offset
        +
        bob_offset
        +
        sprite_get_height(spriteGunShipMine);

    sprite_index = explosion_sprite;
    image_index = 0;

    // Step advances this animation, including while
    // the rest of the game is frozen.
    image_speed = 0;

    hspeed = 0;
    vspeed = 0;
    bob_offset = 0;

    // Fallback timer must allow every frame to play.
    explosion_timer = max(
        explosion_time,
        ceil(
            sprite_get_number(explosion_sprite)
            /
            max(0.01, explosion_image_speed)
        )
        + 2
    );

    scr_play_sfx(
        snd_explode,
        1,
        random_range(0.96, 1.04)
    );

    if (!variable_global_exists("shake_mag"))
    {
        global.shake_mag = 0;
    }

    if (!variable_global_exists("shake_time"))
    {
        global.shake_time = 0;
    }

    global.shake_mag =
        max(global.shake_mag, 5);

    global.shake_time =
        max(global.shake_time, 7);
};


// ====================================================
// FALLING
// ====================================================

if (state == "falling")
{
    draw_ground_offset = 0;
    bob_offset = 0;

    // Remember where the bottom was before moving so
    // fast falls cannot skip a thin plate.
    var previous_bottom = bbox_bottom;

    vspeed += gravity_amount;

    x += hspeed;
    y += vspeed;


    // =================================================
    // LAND ON LAUNCHER / PRESSURE PLATE SOLID HELPERS
    //
    // Check only while descending across their tops.
    // Select the highest surface if both overlap.
    // =================================================

    var support_hit = noone;
    var support_top = 1000000000;

    for (var kind = 0; kind < 2; kind++)
    {
        var support_object = oMissileLauncherSolid;

        if (kind == 1)
        {
            support_object = oPressurePlateSolid;
        }

        var support_count =
            instance_number(support_object);

        for (
            var i = 0;
            i < support_count;
            i++
        )
        {
            var support =
                instance_find(support_object, i);

            if (!instance_exists(support))
            {
                continue;
            }

            var horizontal_overlap =
                bbox_right >
                    support.bbox_left + 2
                &&
                bbox_left <
                    support.bbox_right - 2;

            var crossed_top =
                previous_bottom <=
                    support.bbox_top
                    + max(4, abs(vspeed))
                &&
                bbox_bottom
                    + ground_check_distance
                    >= support.bbox_top;

            if (
                horizontal_overlap &&
                crossed_top &&
                support.bbox_top < support_top
            )
            {
                support_hit = support;
                support_top = support.bbox_top;
            }
        }
    }

    if (instance_exists(support_hit))
    {
        // Snap the mine's actual collision bottom onto
        // the helper's collision top.
        y += support_top - bbox_bottom;

        hspeed = 0;
        vspeed = 0;

        state = "armed";
        armed = false;
        arm_timer = arm_delay;

        // Silo/plate artwork is flat. The 13 px inset
        // is only for the oblique train floor tiles.
        ground_draw_inset = 0;
        draw_ground_offset = 0;

        life_timer = mine_lifetime;
        warning_started = false;

        exit;
    }


    // =================================================
    // EXISTING TILE / DYNAMIC FLOOR LANDING
    // =================================================

    var bottom_y =
        bbox_bottom +
        ground_check_distance;

    var check_left =
        bbox_left + 2;

    var check_middle =
        (bbox_left + bbox_right) * 0.5;

    var check_right =
        bbox_right - 2;

    if (
        point_hits_ground(check_left, bottom_y)
        ||
        point_hits_ground(check_middle, bottom_y)
        ||
        point_hits_ground(check_right, bottom_y)
    )
    {
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
        armed = false;
        arm_timer = arm_delay;

        draw_ground_offset =
            ground_draw_inset;

        life_timer = mine_lifetime;
        warning_started = false;
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

    // ------------------------------------------------
    // VISUAL BOB
    // ------------------------------------------------

    bob_t += bob_speed;

    bob_offset =
        sin(bob_t)
        *
        bob_amount;

    // ------------------------------------------------
    // ARM DELAY
    // ------------------------------------------------

    if (!armed)
    {
        arm_timer--;

        if (arm_timer <= 0)
        {
            armed = true;
        }
    }

    // ------------------------------------------------
    // LIFETIME / WARNING
    // ------------------------------------------------

    life_timer--;

    if (
        !warning_started &&
        life_timer <= warning_time
    )
    {
        warning_started = true;
    }


    // =================================================
    // AUDIO: ONLY THE CLOSEST MINES BEEP
    // =================================================

    var target_beep_gain = 0;

    if (p != noone)
    {
        var my_dist = point_distance(
            x,
            y,
            p.x,
            p.y
        );

        if (my_dist < beep_outer_dist)
        {
            var closer_count = 0;

            var mine_count =
                instance_number(oGunShipMine);

            for (
                var m = 0;
                m < mine_count;
                m++
            )
            {
                var other_mine =
                    instance_find(
                        oGunShipMine,
                        m
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
                    other_mine.state != "armed"
                )
                {
                    continue;
                }

                var other_dist = point_distance(
                    other_mine.x,
                    other_mine.y,
                    p.x,
                    p.y
                );

                if (other_dist < my_dist)
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

            if (closer_count < beep_max_voices)
            {
                if (my_dist <= beep_inner_dist)
                {
                    target_beep_gain =
                        beep_max_gain;
                }
                else
                {
                    var fade_amount =
                        (my_dist - beep_inner_dist)
                        /
                        max(
                            1,
                            beep_outer_dist
                            - beep_inner_dist
                        );

                    target_beep_gain =
                        beep_max_gain
                        *
                        (
                            1
                            -
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

    if (target_beep_gain <= 0)
    {
        if (beep_instance != noone)
        {
            audio_stop_sound(beep_instance);
            beep_instance = noone;
        }
    }
    else if (
        snd_beep != -1 &&
        audio_group_is_loaded(audiogroupsfx)
    )
    {
        if (beep_instance == noone)
        {
            beep_instance = audio_play_sound(
                snd_beep,
                -65,
                true
            );

            if (beep_instance != noone)
            {
                audio_sound_gain(
                    beep_instance,
                    0,
                    0
                );
            }
        }

        if (beep_instance != noone)
        {
            audio_sound_gain(
                beep_instance,
                target_beep_gain,
                120
            );

            var current_beep_pitch =
                beep_pitch;

            if (warning_started)
            {
                var warning_amount =
                    1
                    -
                    clamp(
                        life_timer
                        /
                        max(1, warning_time),
                        0,
                        1
                    );

                current_beep_pitch = lerp(
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
                p.bbox_right > bbox_left
                &&
                p.bbox_left < bbox_right
                &&
                p.bbox_bottom > bbox_top
                &&
                p.bbox_top < bbox_bottom;

            if (hit_player)
            {
                with (p)
                {
                    scr_player_died();
                }

                begin_explosion();
                exit;
            }
        }
    }


    // =================================================
    // TIMED SELF-DESTRUCTION
    // =================================================

    if (life_timer <= 0)
    {
        begin_explosion();
        exit;
    }

    exit;
}