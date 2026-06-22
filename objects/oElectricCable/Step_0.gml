/// oElectricCable — Step

// Hot-reload safety
if (!variable_instance_exists(id, "snd_electric_small_loop")) snd_electric_small_loop = asset_get_index("SmallEelectricCable1");
if (!variable_instance_exists(id, "electric_small_loop_instance")) electric_small_loop_instance = noone;
if (!variable_instance_exists(id, "electric_small_loop_gain")) electric_small_loop_gain = 0.22;
if (!variable_instance_exists(id, "electric_small_loop_pitch")) electric_small_loop_pitch = 1.0;
if (!variable_instance_exists(id, "electric_small_loop_inner_dist")) electric_small_loop_inner_dist = 80;
if (!variable_instance_exists(id, "electric_small_loop_outer_dist")) electric_small_loop_outer_dist = 260;

enabled = true;
active  = true;

// Keep angle clean even if rotated in room editor
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

// ----------------------------------------------------
// Distance-based always-on electric loop
// ----------------------------------------------------
var target_gain = 0;

var p_audio = instance_find(oPlayer, 0);

if (p_audio != noone)
{
    var d = point_distance(x, y, p_audio.x, p_audio.y);

    if (d <= electric_small_loop_inner_dist)
    {
        target_gain = electric_small_loop_gain;
    }
    else if (d < electric_small_loop_outer_dist)
    {
        var tdist = (d - electric_small_loop_inner_dist) / max(1, electric_small_loop_outer_dist - electric_small_loop_inner_dist);
        target_gain = electric_small_loop_gain * (1 - clamp(tdist, 0, 1));
    }
}

if (snd_electric_small_loop != -1 && audio_group_is_loaded(audiogroupsfx))
{
    if (electric_small_loop_instance == noone)
    {
        electric_small_loop_instance = audio_play_sound(snd_electric_small_loop, -60, true);
        audio_sound_gain(electric_small_loop_instance, 0, 0);
        audio_sound_pitch(electric_small_loop_instance, electric_small_loop_pitch);
    }

    audio_sound_gain(electric_small_loop_instance, target_gain, 100);
}