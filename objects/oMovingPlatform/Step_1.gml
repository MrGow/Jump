/// oMovingPlatform — Begin Step

// Hot-reload safety
if (!variable_instance_exists(id, "snd_moving_platform_loop")) snd_moving_platform_loop = asset_get_index("MovingPlatformCableHellLoop1");
if (!variable_instance_exists(id, "moving_platform_loop_instance")) moving_platform_loop_instance = noone;
if (!variable_instance_exists(id, "moving_platform_loop_gain")) moving_platform_loop_gain = 0.22;
if (!variable_instance_exists(id, "moving_platform_loop_pitch")) moving_platform_loop_pitch = 1.0;
if (!variable_instance_exists(id, "moving_platform_loop_inner_dist")) moving_platform_loop_inner_dist = 90;
if (!variable_instance_exists(id, "moving_platform_loop_outer_dist")) moving_platform_loop_outer_dist = 320;
if (!variable_instance_exists(id, "moving_platform_loop_max_voices")) moving_platform_loop_max_voices = 2;

if (!enabled)
{
    if (moving_platform_loop_instance != noone)
    {
        audio_stop_sound(moving_platform_loop_instance);
        moving_platform_loop_instance = noone;
    }

    exit;
}

active = true;
solid_body = true;

// Store previous transform/bounds
prev_x = x;
prev_y = y;

prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;

dx = 0;
dy = 0;

// ----------------------------------------------------
// Movement
// ----------------------------------------------------
var is_moving_this_frame = false;

if (marker_found)
{
    if (pause_timer > 0)
    {
        pause_timer--;
    }
    else
    {
        var dest_x = (travel_dir == 1) ? target_x : start_x;
        var dest_y = (travel_dir == 1) ? target_y : start_y;

        var dist = point_distance(x, y, dest_x, dest_y);

        if (dist <= move_speed || dist <= 0.0001)
        {
            x = dest_x;
            y = dest_y;

            travel_dir = -travel_dir;
            pause_timer = pause_frames_end;
        }
        else
        {
            var dir = point_direction(x, y, dest_x, dest_y);

            x += lengthdir_x(move_speed, dir);
            y += lengthdir_y(move_speed, dir);

            is_moving_this_frame = true;
        }
    }
}

dx = x - prev_x;
dy = y - prev_y;

if (abs(dx) > 0.01 || abs(dy) > 0.01) {
    is_moving_this_frame = true;
}

// ----------------------------------------------------
// Distance-based loop SFX, limited to closest platforms
// Only plays while platform is actually moving
// ----------------------------------------------------
var target_gain = 0;

if (is_moving_this_frame)
{
    var p_audio = instance_find(oPlayer, 0);

    if (p_audio != noone)
    {
        var my_dist = point_distance(x, y, p_audio.x, p_audio.y);

        if (my_dist < moving_platform_loop_outer_dist)
        {
            var closer_count = 0;
            var plat_count = instance_number(oMovingPlatform);

            for (var i = 0; i < plat_count; i++)
            {
                var mp = instance_find(oMovingPlatform, i);
                if (mp == noone || mp == id) continue;

                if (variable_instance_exists(mp, "enabled") && !mp.enabled) continue;
                if (!variable_instance_exists(mp, "marker_found") || !mp.marker_found) continue;

                var mp_dx = variable_instance_exists(mp, "dx") ? mp.dx : 0;
                var mp_dy = variable_instance_exists(mp, "dy") ? mp.dy : 0;

                if (abs(mp_dx) <= 0.01 && abs(mp_dy) <= 0.01) continue;

                var mp_dist = point_distance(mp.x, mp.y, p_audio.x, p_audio.y);

                if (mp_dist < my_dist)
                {
                    closer_count++;

                    if (closer_count >= moving_platform_loop_max_voices)
                    {
                        break;
                    }
                }
            }

            if (closer_count < moving_platform_loop_max_voices)
            {
                if (my_dist <= moving_platform_loop_inner_dist)
                {
                    target_gain = moving_platform_loop_gain;
                }
                else
                {
                    var tdist = (my_dist - moving_platform_loop_inner_dist) / max(1, moving_platform_loop_outer_dist - moving_platform_loop_inner_dist);
                    target_gain = moving_platform_loop_gain * (1 - clamp(tdist, 0, 1));
                }
            }
        }
    }
}

if (target_gain <= 0)
{
    if (moving_platform_loop_instance != noone)
    {
        audio_stop_sound(moving_platform_loop_instance);
        moving_platform_loop_instance = noone;
    }
}
else if (snd_moving_platform_loop != -1 && audio_group_is_loaded(audiogroupsfx))
{
    if (moving_platform_loop_instance == noone)
    {
        moving_platform_loop_instance = audio_play_sound(snd_moving_platform_loop, -65, true);
        audio_sound_gain(moving_platform_loop_instance, 0, 0);
        audio_sound_pitch(moving_platform_loop_instance, moving_platform_loop_pitch);
    }

    audio_sound_gain(moving_platform_loop_instance, target_gain, 100);
}