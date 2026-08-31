/// oElectricCable — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "electric_small_anim_speed"))
{
    electric_small_anim_speed =
        0.35;
}


if (!variable_instance_exists(id, "facing_direction"))
{
    facing_direction =
        1;
}


if (!variable_instance_exists(id, "snd_electric_small_loop"))
{
    snd_electric_small_loop =
        asset_get_index(
            "SmallEelectricCable1"
        );
}


if (!variable_instance_exists(id, "electric_small_loop_instance"))
{
    electric_small_loop_instance =
        noone;
}


if (!variable_instance_exists(id, "electric_small_loop_gain"))
{
    electric_small_loop_gain =
        0.22;
}


if (!variable_instance_exists(id, "electric_small_loop_pitch"))
{
    electric_small_loop_pitch =
        1.0;
}


if (!variable_instance_exists(id, "electric_small_loop_inner_dist"))
{
    electric_small_loop_inner_dist =
        80;
}


if (!variable_instance_exists(id, "electric_small_loop_outer_dist"))
{
    electric_small_loop_outer_dist =
        260;
}


if (!variable_instance_exists(id, "electric_small_loop_max_voices"))
{
    electric_small_loop_max_voices =
        2;
}


// ====================================================
// PAUSE FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed =
        0;


    if (electric_small_loop_instance != noone)
    {
        audio_stop_sound(
            electric_small_loop_instance
        );

        electric_small_loop_instance =
            noone;
    }


    exit;
}


// ====================================================
// ALWAYS ACTIVE
// ====================================================

enabled =
    true;

active =
    true;


// Never blink or disable animation during gameplay.
image_speed =
    electric_small_anim_speed;


// ====================================================
// FACING
// ====================================================

facing_direction =
    clamp(
        round(facing_direction),
        1,
        8
    );


image_angle =
    (facing_direction - 1)
    *
    45;


// ====================================================
// DISTANCE-BASED ELECTRIC LOOP
//
// Only N nearest active cables may produce sound.
// ====================================================

var target_gain =
    0;


var p_audio =
    instance_find(
        oPlayer,
        0
    );


if (p_audio != noone)
{
    var my_dist =
        point_distance(
            x,
            y,
            p_audio.x,
            p_audio.y
        );


    if (
        my_dist <
        electric_small_loop_outer_dist
    )
    {
        var closer_count =
            0;


        var cable_count =
            instance_number(
                oElectricCable
            );


        for (
            var i = 0;
            i < cable_count;
            i++
        )
        {
            var c =
                instance_find(
                    oElectricCable,
                    i
                );


            if (
                c == noone
                ||
                c == id
            )
            {
                continue;
            }


            var cd =
                point_distance(
                    c.x,
                    c.y,
                    p_audio.x,
                    p_audio.y
                );


            if (cd < my_dist)
            {
                closer_count++;


                if (
                    closer_count >=
                    electric_small_loop_max_voices
                )
                {
                    break;
                }
            }
        }


        if (
            closer_count <
            electric_small_loop_max_voices
        )
        {
            if (
                my_dist <=
                electric_small_loop_inner_dist
            )
            {
                target_gain =
                    electric_small_loop_gain;
            }
            else
            {
                var tdist =
                    (
                        my_dist
                        -
                        electric_small_loop_inner_dist
                    )
                    /
                    max(
                        1,
                        electric_small_loop_outer_dist
                        -
                        electric_small_loop_inner_dist
                    );


                target_gain =
                    electric_small_loop_gain
                    *
                    (
                        1
                        -
                        clamp(
                            tdist,
                            0,
                            1
                        )
                    );
            }
        }
    }
}


// ====================================================
// STOP LOOP IF OUT OF RANGE / NOT CLOSEST
// ====================================================

if (target_gain <= 0)
{
    if (electric_small_loop_instance != noone)
    {
        audio_stop_sound(
            electric_small_loop_instance
        );


        electric_small_loop_instance =
            noone;
    }


    exit;
}


// ====================================================
// START / UPDATE LOOP
// ====================================================

if (
    snd_electric_small_loop != -1
    &&
    audio_group_is_loaded(
        audiogroupsfx
    )
)
{
    if (electric_small_loop_instance == noone)
    {
        electric_small_loop_instance =
            audio_play_sound(
                snd_electric_small_loop,
                -60,
                true
            );


        if (
            electric_small_loop_instance != noone
        )
        {
            audio_sound_gain(
                electric_small_loop_instance,
                0,
                0
            );


            audio_sound_pitch(
                electric_small_loop_instance,
                electric_small_loop_pitch
            );
        }
    }


    if (electric_small_loop_instance != noone)
    {
        audio_sound_gain(
            electric_small_loop_instance,
            target_gain,
            100
        );
    }
}