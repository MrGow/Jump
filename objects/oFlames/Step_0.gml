/// oFlames — Step

// Hot-reload safety
if (!variable_instance_exists(id, "flame_anim_speed")) flame_anim_speed = max(0.35, image_speed);
if (!variable_instance_exists(id, "snd_flame_loop")) snd_flame_loop = asset_get_index("FlameLoop1");
if (!variable_instance_exists(id, "flame_loop_instance")) flame_loop_instance = noone;
if (!variable_instance_exists(id, "flame_loop_gain")) flame_loop_gain = 0.35;
if (!variable_instance_exists(id, "flame_loop_pitch")) flame_loop_pitch = 1.0;
if (!variable_instance_exists(id, "flame_loop_inner_dist")) flame_loop_inner_dist = 90;
if (!variable_instance_exists(id, "flame_loop_outer_dist")) flame_loop_outer_dist = 300;

// ----------------------------------------------------
// Pause freeze
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;

    if (flame_loop_instance != noone)
    {
        audio_stop_sound(flame_loop_instance);
        flame_loop_instance = noone;
    }

    exit;
}

image_speed = flame_anim_speed;

// ----------------------------------------------------
// Distance-based flame loop
// ----------------------------------------------------
var target_gain = 0;

var p_audio = instance_find(oPlayer, 0);

if (p_audio != noone)
{
    var d = point_distance(x, y, p_audio.x, p_audio.y);

    if (d <= flame_loop_inner_dist)
    {
        target_gain = flame_loop_gain;
    }
    else if (d < flame_loop_outer_dist)
    {
        var tdist = (d - flame_loop_inner_dist) / max(1, flame_loop_outer_dist - flame_loop_inner_dist);
        target_gain = flame_loop_gain * (1 - clamp(tdist, 0, 1));
    }
}

if (target_gain <= 0)
{
    if (flame_loop_instance != noone)
    {
        audio_stop_sound(flame_loop_instance);
        flame_loop_instance = noone;
    }
}
else if (snd_flame_loop != -1 && audio_group_is_loaded(audiogroupsfx))
{
    if (flame_loop_instance == noone)
    {
        flame_loop_instance = audio_play_sound(snd_flame_loop, -55, true);
        audio_sound_gain(flame_loop_instance, 0, 0);
        audio_sound_pitch(flame_loop_instance, flame_loop_pitch);
    }

    audio_sound_gain(flame_loop_instance, target_gain, 100);
}

// ----------------------------------------------------
// Kill player
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var kleft   = bbox_left   + kill_inset_x;
var kright  = bbox_right  - kill_inset_x;
var ktop    = bbox_top    + kill_inset_top;
var kbottom = bbox_bottom - kill_inset_bottom;

if (kright <= kleft)
{
    var cx = (bbox_left + bbox_right) * 0.5;
    kleft = cx;
    kright = cx + 1;
}

if (kbottom <= ktop)
{
    var cy = (bbox_top + bbox_bottom) * 0.5;
    ktop = cy;
    kbottom = cy + 1;
}

var hit =
    (p.bbox_right  > kleft)  &&
    (p.bbox_left   < kright) &&
    (p.bbox_bottom > ktop)   &&
    (p.bbox_top    < kbottom);

if (!hit) exit;

if (script_exists(asset_get_index("scr_player_died")))
{
    with (p) scr_player_died();
}
else
{
    with (p)
    {
        if (variable_instance_exists(id, "state")) state = "dead";
    }
}