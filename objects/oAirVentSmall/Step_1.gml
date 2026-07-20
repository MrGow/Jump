/// oAirVentSmall — Begin Step

// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_air_vent_small_loop"))
{
    snd_air_vent_small_loop = asset_get_index("AirVentSmallLoop1");
}

if (!variable_instance_exists(id, "air_vent_loop_instance"))
{
    air_vent_loop_instance = noone;
}

if (!variable_instance_exists(id, "air_vent_audio_emitter"))
{
    air_vent_audio_emitter = audio_emitter_create();
}

if (!variable_instance_exists(id, "air_vent_loop_gain"))
{
    air_vent_loop_gain = 0.32;
}

if (!variable_instance_exists(id, "air_vent_loop_pitch"))
{
    air_vent_loop_pitch = 1.0;
}

if (!variable_instance_exists(id, "air_vent_loop_inner_dist"))
{
    air_vent_loop_inner_dist = 100;
}

if (!variable_instance_exists(id, "air_vent_loop_outer_dist"))
{
    air_vent_loop_outer_dist = 380;
}

if (!variable_instance_exists(id, "air_vent_loop_max_voices"))
{
    air_vent_loop_max_voices = 3;
}

if (!variable_instance_exists(id, "air_vent_pan_strength"))
{
    air_vent_pan_strength = 1.0;
}

// ====================================================
// PAUSE / DEATH-MENU FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    if (air_vent_loop_instance != noone)
    {
        audio_stop_sound(air_vent_loop_instance);
        air_vent_loop_instance = noone;
    }

    exit;
}

// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    image_speed = 0;

    if (air_vent_loop_instance != noone)
    {
        audio_stop_sound(air_vent_loop_instance);
        air_vent_loop_instance = noone;
    }

    exit;
}

// ====================================================
// FIND PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);

// ====================================================
// DIRECTIONAL, DISTANCE-BASED LOOP AUDIO
// ====================================================

var target_gain = 0;
var allowed_to_play = false;

if (p != noone)
{
    var my_dist = point_distance(x, y, p.x, p.y);

    if (my_dist < air_vent_loop_outer_dist)
    {
        var closer_count = 0;
        var vent_count = instance_number(oAirVentSmall);

        for (var ai = 0; ai < vent_count; ai++)
        {
            var other_vent = instance_find(oAirVentSmall, ai);

            if (other_vent == noone || other_vent == id)
            {
                continue;
            }

            if (
                variable_instance_exists(other_vent, "enabled") &&
                !other_vent.enabled
            )
            {
                continue;
            }

            var other_dist = point_distance(
                other_vent.x,
                other_vent.y,
                p.x,
                p.y
            );

            if (other_dist < my_dist)
            {
                closer_count++;

                if (closer_count >= air_vent_loop_max_voices)
                {
                    break;
                }
            }
        }

        allowed_to_play =
            closer_count < air_vent_loop_max_voices;

        if (allowed_to_play)
        {
            if (my_dist <= air_vent_loop_inner_dist)
            {
                target_gain = air_vent_loop_gain;
            }
            else
            {
                var dist_amount =
                    (my_dist - air_vent_loop_inner_dist) /
                    max(
                        1,
                        air_vent_loop_outer_dist -
                        air_vent_loop_inner_dist
                    );

                target_gain =
                    air_vent_loop_gain *
                    (1 - clamp(dist_amount, 0, 1));
            }

            // ------------------------------------------------
            // Relative emitter position for stereo direction
            // ------------------------------------------------
            var relative_x =
                clamp(
                    (x - p.x) /
                    max(1, air_vent_loop_outer_dist),
                    -1,
                    1
                ) *
                air_vent_pan_strength;

            var relative_y =
                clamp(
                    (y - p.y) /
                    max(1, air_vent_loop_outer_dist),
                    -1,
                    1
                );

            audio_emitter_position(
                air_vent_audio_emitter,
                relative_x,
                relative_y,
                0
            );
        }
    }
}

if (
    !allowed_to_play ||
    target_gain <= 0 ||
    snd_air_vent_small_loop == -1
)
{
    if (air_vent_loop_instance != noone)
    {
        audio_stop_sound(air_vent_loop_instance);
        air_vent_loop_instance = noone;
    }
}
else if (audio_group_is_loaded(audiogroupsfx))
{
    if (air_vent_loop_instance == noone)
    {
        air_vent_loop_instance = audio_play_sound_on(
            air_vent_audio_emitter,
            snd_air_vent_small_loop,
            true,
            -60
        );

        audio_sound_gain(
            air_vent_loop_instance,
            0,
            0
        );

        audio_sound_pitch(
            air_vent_loop_instance,
            air_vent_loop_pitch
        );
    }

    audio_sound_gain(
        air_vent_loop_instance,
        target_gain,
        100
    );
}

// ====================================================
// PLAYER SAFETY
// ====================================================

if (p == noone)
{
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}

if (wind_sprite == -1)
{
    exit;
}

// ====================================================
// CALCULATE WIND COLUMN
// ====================================================

var wind_width = sprite_get_width(wind_sprite);
var wind_height = sprite_get_height(wind_sprite);

var column_width =
    wind_width *
    wind_collision_width_scale *
    abs(image_xscale);

var column_height =
    wind_tiles *
    (
        wind_height +
        wind_tile_gap
    );

// The air begins at the top of the vent sprite.
var column_bottom = bbox_top;
var column_top = column_bottom - column_height;

var column_left = x - column_width * 0.5;
var column_right = x + column_width * 0.5;

// ====================================================
// PLAYER / WIND OVERLAP
// ====================================================

var inside_wind =
    p.bbox_right  > column_left &&
    p.bbox_left   < column_right &&
    p.bbox_bottom > column_top &&
    p.bbox_top    < column_bottom;

if (!inside_wind)
{
    exit;
}

// ====================================================
// MARK PLAYER AS INSIDE A VENT THIS FRAME
// ====================================================

p.air_vent_active_until = current_time + 40;
p.air_vent_source = id;

p.air_vent_up_accel = updraft_acceleration;
p.air_vent_max_rise_speed = maximum_rise_speed;

p.air_vent_bias = horizontal_bias;
p.air_vent_bias_max_speed = bias_max_speed;
p.air_vent_horizontal_accel = horizontal_acceleration;