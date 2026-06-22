/// oScrapCrusher — Step (FULL)
/// Distance-based crusher loop + robust kill when player lands on teeth.

if (!variable_instance_exists(id, "snd_crusher_loop")) snd_crusher_loop = asset_get_index("ScrapCrusherLoopSound1");
if (!variable_instance_exists(id, "crusher_loop_instance")) crusher_loop_instance = noone;
if (!variable_instance_exists(id, "crusher_loop_started"))  crusher_loop_started = false;

if (!variable_instance_exists(id, "crusher_loop_gain_max"))    crusher_loop_gain_max = 0.45;
if (!variable_instance_exists(id, "crusher_loop_inner_dist"))  crusher_loop_inner_dist = 90;
if (!variable_instance_exists(id, "crusher_loop_outer_dist"))  crusher_loop_outer_dist = 360;
if (!variable_instance_exists(id, "crusher_loop_pitch"))       crusher_loop_pitch = 1.0;

// ----------------------------------------------------
// Distance-based loop audio
// ----------------------------------------------------
var p_audio = instance_find(oPlayer, 0);

if (!enabled)
{
    if (crusher_loop_instance != noone) {
        audio_stop_sound(crusher_loop_instance);
        crusher_loop_instance = noone;
        crusher_loop_started = false;
    }
    exit;
}

if (snd_crusher_loop != -1 && audio_group_is_loaded(audiogroupsfx))
{
    if (!crusher_loop_started || crusher_loop_instance == noone)
    {
        crusher_loop_instance = audio_play_sound(snd_crusher_loop, -50, true);
        audio_sound_pitch(crusher_loop_instance, crusher_loop_pitch);
        audio_sound_gain(crusher_loop_instance, 0, 0);
        crusher_loop_started = true;
    }

    var target_gain = 0;

    if (p_audio != noone)
    {
        var d = point_distance(x, y, p_audio.x, p_audio.y);

        if (d <= crusher_loop_inner_dist)
        {
            target_gain = crusher_loop_gain_max;
        }
        else if (d < crusher_loop_outer_dist)
        {
            var tdist = (d - crusher_loop_inner_dist) / max(1, crusher_loop_outer_dist - crusher_loop_inner_dist);
            target_gain = crusher_loop_gain_max * (1 - clamp(tdist, 0, 1));
        }
        else
        {
            target_gain = 0;
        }
    }

    audio_sound_gain(crusher_loop_instance, target_gain, 120);
}

// ----------------------------------------------------
// Active frame window
// ----------------------------------------------------
if (variable_instance_exists(id, "use_active_frames") && use_active_frames) {
    var fr = floor(image_index);
    active = (fr >= active_from && fr <= active_to);
} else {
    active = true;
}
if (!active) exit;

// Find player
var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// Optional: only kill while player is moving downward
if (variable_instance_exists(id, "kill_only_when_falling") && kill_only_when_falling) {
    var pv_chk = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    if (pv_chk < 0) exit;
}

// ----------------------------------------------------
// Tunables
// ----------------------------------------------------
var band_h    = (variable_instance_exists(id, "kill_band_h"))      ? kill_band_h      : 6;
var depth_px  = (variable_instance_exists(id, "kill_depth_px"))    ? kill_depth_px    : 2;
var inset_x   = (variable_instance_exists(id, "kill_inset_x"))     ? kill_inset_x     : 10;
var inset_x2  = (variable_instance_exists(id, "kill_inset_x2"))    ? kill_inset_x2    : 0;
var headroom  = (variable_instance_exists(id, "kill_headroom_px")) ? kill_headroom_px : 3;
var sink_h    = (variable_instance_exists(id, "sink_px"))          ? sink_px          : 6;

// ----------------------------------------------------
// Crusher surface + extents
// ----------------------------------------------------
var top_y = (variable_instance_exists(id, "kill_surface_y")) ? kill_surface_y : bbox_top;

var left_x  = (variable_instance_exists(id, "kill_left"))  ? kill_left  : bbox_left;
var right_x = (variable_instance_exists(id, "kill_right")) ? kill_right : bbox_right;

// Apply oblique inset
left_x  += inset_x;
right_x -= (inset_x + inset_x2);

// Safety clamp
if (right_x < left_x) {
    var mid = (bbox_left + bbox_right) * 0.5;
    left_x = mid;
    right_x = mid;
}

var bottom_y = top_y + band_h;

// ----------------------------------------------------
// Player feet now + previous
// ----------------------------------------------------
var feet_now = p.bbox_bottom;

var feet_prev;
if (variable_instance_exists(p, "crusher_prev_feet_y")) {
    feet_prev = p.crusher_prev_feet_y;
} else {
    var pv = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    feet_prev = feet_now - pv;
}

// Horizontal overlap requirements
var feet_x     = (p.bbox_left + p.bbox_right) * 0.5;
var over_teeth = (feet_x > left_x && feet_x < right_x);
var body_over  = (p.bbox_right > left_x && p.bbox_left < right_x);
if (!(over_teeth && body_over)) exit;

// ----------------------------------------------------
// Kill tests
// ----------------------------------------------------
var in_band      = (feet_now >= (top_y + depth_px) && feet_now <= bottom_y);
var crossed      = (feet_prev < top_y && feet_now >= top_y);
var near_surface = (feet_now >= (top_y - headroom) && feet_now < top_y);

if (in_band || crossed || near_surface)
{
    var lock_feet_y = top_y + sink_h;

    with (p) {
        scr_player_died(lock_feet_y);
    }
}