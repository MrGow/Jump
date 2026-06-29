/// oConveyorLeft - Step

// Hot reload safety
if (!variable_instance_exists(id, "conveyor_speed")) conveyor_speed = 5;
if (!variable_instance_exists(id, "conveyor_anim_speed")) conveyor_anim_speed = image_speed;

if (!variable_instance_exists(id, "snd_conveyor_loop")) snd_conveyor_loop = asset_get_index("ConveyorBeltLoop1");
if (!variable_instance_exists(id, "conveyor_loop_instance")) conveyor_loop_instance = noone;
if (!variable_instance_exists(id, "conveyor_loop_gain")) conveyor_loop_gain = 0.32;
if (!variable_instance_exists(id, "conveyor_loop_pitch")) conveyor_loop_pitch = 1.0;
if (!variable_instance_exists(id, "conveyor_loop_inner_dist")) conveyor_loop_inner_dist = 100;
if (!variable_instance_exists(id, "conveyor_loop_outer_dist")) conveyor_loop_outer_dist = 320;

// ----------------------------------------------------
// Pause freeze
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;
    dx = 0;
    dy = 0;

    if (conveyor_loop_instance != noone)
    {
        audio_stop_sound(conveyor_loop_instance);
        conveyor_loop_instance = noone;
    }

    exit;
}

if (!enabled)
{
    image_speed = 0;
    dx = 0;
    dy = 0;

    if (conveyor_loop_instance != noone)
    {
        audio_stop_sound(conveyor_loop_instance);
        conveyor_loop_instance = noone;
    }

    exit;
}

conveyor_speed = clamp(conveyor_speed, 1, 10);

// Update belt force from speed setting
belt_speed = -lerp(0.35, 2.5, (conveyor_speed - 1) / 9);

// Update animation speed too
conveyor_anim_speed = lerp(0.25, 2.0, (conveyor_speed - 1) / 9);
image_speed = conveyor_anim_speed;

surface_y = bbox_top + surface_offset;

dx = belt_speed;
dy = 0;

// ----------------------------------------------------
// Distance-based conveyor loop
// ----------------------------------------------------
var target_gain = 0;

var p_audio = instance_find(oPlayer, 0);

if (p_audio != noone)
{
    var d = point_distance(x, y, p_audio.x, p_audio.y);

    if (d <= conveyor_loop_inner_dist)
    {
        target_gain = conveyor_loop_gain;
    }
    else if (d < conveyor_loop_outer_dist)
    {
        var tdist = (d - conveyor_loop_inner_dist) / max(1, conveyor_loop_outer_dist - conveyor_loop_inner_dist);
        target_gain = conveyor_loop_gain * (1 - clamp(tdist, 0, 1));
    }
}

if (target_gain <= 0)
{
    if (conveyor_loop_instance != noone)
    {
        audio_stop_sound(conveyor_loop_instance);
        conveyor_loop_instance = noone;
    }
}
else if (snd_conveyor_loop != -1 && audio_group_is_loaded(audiogroupsfx))
{
    if (conveyor_loop_instance == noone)
    {
        conveyor_loop_instance = audio_play_sound(snd_conveyor_loop, -58, true);
        audio_sound_gain(conveyor_loop_instance, 0, 0);
        audio_sound_pitch(conveyor_loop_instance, conveyor_loop_pitch);
    }

    audio_sound_gain(conveyor_loop_instance, target_gain, 100);
}