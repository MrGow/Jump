/// oSwivelGun — Step

// ----------------------------------------------------
// Freeze
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;

    if (
        patrol_loop_instance != noone &&
        !patrol_loop_paused
    )
    {
        audio_pause_sound(
            patrol_loop_instance
        );

        patrol_loop_paused = true;
    }

    exit;
}

// Resume loop after unfreezing.
if (
    patrol_loop_instance != noone &&
    patrol_loop_paused
)
{
    audio_resume_sound(
        patrol_loop_instance
    );

    patrol_loop_paused = false;
}

if (!enabled)
{
    if (patrol_loop_instance != noone)
    {
        audio_stop_sound(
            patrol_loop_instance
        );

        patrol_loop_instance = noone;
    }

    exit;
}

active = true;
image_speed = 0;

// ----------------------------------------------------
// General visual animation
// ----------------------------------------------------
scan_pulse_t += scan_pulse_speed;
laser_scroll += laser_scroll_speed;

gun_recoil = max(
    0,
    gun_recoil - gun_recoil_return
);

if (respawn_safe_timer > 0)
{
    respawn_safe_timer--;
}

// ----------------------------------------------------
// State machine
// ----------------------------------------------------
switch (state)
{
    case "patrol":
    {
        beam_visible = true;
        beam_lethal  = false;

        image_index = 0;

        alert_target = noone;
        alert_elapsed = 0;

        recoil_triggered = false;

        patrol_offset +=
            patrol_speed *
            patrol_direction;

        if (
            patrol_offset >=
            patrol_half_arc
        )
        {
            patrol_offset =
                patrol_half_arc;

            patrol_direction = -1;
        }
        else if (
            patrol_offset <=
            -patrol_half_arc
        )
        {
            patrol_offset =
                -patrol_half_arc;

            patrol_direction = 1;
        }

        beam_angle =
            beam_center_angle +
            patrol_offset;
    }
    break;

    case "alert":
    {
        beam_visible = true;
        beam_lethal  = false;

        image_index = 0;

        alert_elapsed++;

        if (
            instance_exists(alert_target) &&
            !(
                variable_instance_exists(
                    alert_target,
                    "state"
                ) &&
                alert_target.state == "dead"
            )
        )
        {
            var player_angle =
                point_direction(
                    x,
                    y,
                    alert_target.x,
                    alert_target.y
                );

            var angle_delta =
                angle_difference(
                    beam_angle,
                    player_angle
                );

            angle_delta = clamp(
                angle_delta,
                -alert_max_adjust,
                alert_max_adjust
            );

            var desired_angle =
                beam_angle +
                angle_delta;

            beam_angle +=
                angle_difference(
                    beam_angle,
                    desired_angle
                ) *
                alert_track_strength;
        }

        var alert_progress =
            1 -
            (
                state_timer /
                max(1, alert_frames)
            );

        var twitch =
            sin(alert_progress * pi * 2) *
            alert_overshoot_degrees *
            (1 - alert_progress);

        beam_angle += twitch;

        state_timer--;

        if (state_timer <= 0)
        {
            state = "firing";

            image_index = 0;
            laser_fx_frame = 0;

            recoil_triggered = false;

            play_dist_sfx(
                snd_shoot,
                shoot_gain,
                random_range(0.98, 1.02)
            );
        }
    }
    break;

    case "firing":
    {
        beam_visible = true;

        image_index +=
            shoot_anim_speed;

        var frame_now =
            floor(image_index);

        beam_lethal =
            frame_now >=
            shoot_active_from &&
            frame_now <=
            shoot_active_to;

        laser_fx_frame += 0.45;

        if (
            beam_lethal &&
            !recoil_triggered
        )
        {
            recoil_triggered = true;

            gun_recoil =
                gun_recoil_max;

            if (!variable_global_exists("shake_mag"))
            {
                global.shake_mag = 0;
            }

            if (!variable_global_exists("shake_time"))
            {
                global.shake_time = 0;
            }

            global.shake_mag =
                max(
                    global.shake_mag,
                    shoot_shake_strength
                );

            global.shake_time =
                max(
                    global.shake_time,
                    shoot_shake_frames
                );
        }

        if (
            image_index >=
            image_number - 1
        )
        {
            image_index =
                image_number - 1;

            beam_visible = false;
            beam_lethal  = false;

            state = "cooldown";
            state_timer = cooldown_frames;
        }
    }
    break;

    case "cooldown":
    {
        beam_visible = false;
        beam_lethal  = false;

        image_index = 0;

        state_timer--;

        if (state_timer <= 0)
        {
            state = "patrol";
            image_index = 0;
        }
    }
    break;
}

// ----------------------------------------------------
// Mechanical stepped gun rotation
//
// spriteGun points DOWN at draw angle 0.
// beam_angle uses GameMaker world directions.
// ----------------------------------------------------
gun_target_draw_angle =
    beam_angle - 270;

var visual_step =
    max(1, gun_visual_angle_step);

var snapped_target =
    round(
        gun_target_draw_angle /
        visual_step
    ) * visual_step;

// Normalise target to 0–359.
snapped_target =
    ((snapped_target mod 360) + 360) mod 360;

if (gun_visual_step_timer > 0)
{
    gun_visual_step_timer--;
}
else
{
    // Guaranteed signed shortest difference:
    // negative = turn one way
    // positive = turn the other way
    var visual_difference =
        ((snapped_target - gun_draw_angle + 540) mod 360) - 180;

    if (abs(visual_difference) >= visual_step * 0.5)
    {
        gun_draw_angle +=
            visual_step * sign(visual_difference);

        gun_draw_angle =
            ((gun_draw_angle mod 360) + 360) mod 360;

        gun_visual_step_timer =
            gun_visual_step_delay;
    }
    else
    {
        gun_draw_angle = snapped_target;
    }
}

// ----------------------------------------------------
// Distance-based patrol loop
// Only the two closest patrolling guns.
// ----------------------------------------------------
var target_loop_gain = 0;

if (state == "patrol")
{
    var player_audio =
        instance_find(oPlayer, 0);

    if (player_audio != noone)
    {
        var my_dist =
            point_distance(
                x,
                y,
                player_audio.x,
                player_audio.y
            );

        if (my_dist < sfx_outer_dist)
        {
            var closer_count = 0;
            var gun_count =
                instance_number(oSwivelGun);

            for (
                var i = 0;
                i < gun_count;
                i++
            )
            {
                var gun =
                    instance_find(
                        oSwivelGun,
                        i
                    );

                if (
                    gun == noone ||
                    gun == id
                )
                {
                    continue;
                }

                if (
                    variable_instance_exists(
                        gun,
                        "enabled"
                    ) &&
                    !gun.enabled
                )
                {
                    continue;
                }

                if (
                    !variable_instance_exists(
                        gun,
                        "state"
                    ) ||
                    gun.state != "patrol"
                )
                {
                    continue;
                }

                var other_dist =
                    point_distance(
                        gun.x,
                        gun.y,
                        player_audio.x,
                        player_audio.y
                    );

                if (other_dist < my_dist)
                {
                    closer_count++;

                    if (
                        closer_count >=
                        patrol_loop_max_voices
                    )
                    {
                        break;
                    }
                }
            }

            if (
                closer_count <
                patrol_loop_max_voices
            )
            {
                if (my_dist <= sfx_inner_dist)
                {
                    target_loop_gain =
                        patrol_loop_gain;
                }
                else
                {
                    var fade_amount =
                        (
                            my_dist -
                            sfx_inner_dist
                        ) /
                        max(
                            1,
                            sfx_outer_dist -
                            sfx_inner_dist
                        );

                    target_loop_gain =
                        patrol_loop_gain *
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
}

if (target_loop_gain <= 0)
{
    if (patrol_loop_instance != noone)
    {
        audio_stop_sound(
            patrol_loop_instance
        );

        patrol_loop_instance = noone;
    }
}
else if (
    snd_patrol_loop != -1 &&
    audio_group_is_loaded(
        audiogroupsfx
    )
)
{
    if (patrol_loop_instance == noone)
    {
        patrol_loop_instance =
            audio_play_sound(
                snd_patrol_loop,
                -70,
                true
            );

        audio_sound_gain(
            patrol_loop_instance,
            0,
            0
        );

        audio_sound_pitch(
            patrol_loop_instance,
            random_range(0.98, 1.02)
        );
    }

    audio_sound_gain(
        patrol_loop_instance,
        target_loop_gain,
        100
    );
}