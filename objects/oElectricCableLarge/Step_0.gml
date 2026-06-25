/// oElectricCableLarge — Step

// Hot-reload safety
if (!variable_instance_exists(id, "cable_anim_speed")) cable_anim_speed = 0.35;
if (!variable_instance_exists(id, "snd_electric_loop")) snd_electric_loop = asset_get_index("LargeElectricCableSound");
if (!variable_instance_exists(id, "electric_loop_instance")) electric_loop_instance = noone;
if (!variable_instance_exists(id, "electric_loop_gain")) electric_loop_gain = 0.35;
if (!variable_instance_exists(id, "electric_loop_pitch")) electric_loop_pitch = 1.0;
if (!variable_instance_exists(id, "electric_loop_inner_dist")) electric_loop_inner_dist = 90;
if (!variable_instance_exists(id, "electric_loop_outer_dist")) electric_loop_outer_dist = 320;

// ----------------------------------------------------
// Pause freeze
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;

    if (electric_loop_instance != noone)
    {
        audio_stop_sound(electric_loop_instance);
        electric_loop_instance = noone;
    }

    exit;
}

image_speed = cable_anim_speed;

if (!enabled)
{
    if (electric_loop_instance != noone)
    {
        audio_stop_sound(electric_loop_instance);
        electric_loop_instance = noone;
    }

    exit;
}

// Keep angle clean even if rotated in room editor
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

var fr = floor(image_index);
active = (fr >= active_from && fr <= active_to);

// ----------------------------------------------------
// Distance-based electric loop during dangerous frames only
// ----------------------------------------------------
if (active)
{
    var target_gain = 0;

    var p_audio = instance_find(oPlayer, 0);

    if (p_audio != noone)
    {
        var d = point_distance(x, y, p_audio.x, p_audio.y);

        if (d <= electric_loop_inner_dist)
        {
            target_gain = electric_loop_gain;
        }
        else if (d < electric_loop_outer_dist)
        {
            var tdist = (d - electric_loop_inner_dist) / max(1, electric_loop_outer_dist - electric_loop_inner_dist);
            target_gain = electric_loop_gain * (1 - clamp(tdist, 0, 1));
        }
    }

    if (snd_electric_loop != -1 && audio_group_is_loaded(audiogroupsfx))
    {
        if (electric_loop_instance == noone)
        {
            electric_loop_instance = audio_play_sound(snd_electric_loop, -40, true);
            audio_sound_gain(electric_loop_instance, 0, 0);
            audio_sound_pitch(electric_loop_instance, electric_loop_pitch);
        }

        audio_sound_gain(electric_loop_instance, target_gain, 80);
    }
}
else
{
    if (electric_loop_instance != noone)
    {
        audio_stop_sound(electric_loop_instance);
        electric_loop_instance = noone;
    }
}

// Keep solid base attached
if (instance_exists(solid_inst))
{
    solid_inst.x = x;
    solid_inst.y = y;
    solid_inst.image_angle = image_angle;
}