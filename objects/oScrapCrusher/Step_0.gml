/// oScrapCrusher — Step (FULL)
/// Robust kill when player lands on the crusher teeth.
/// Handles fast/big bounces by checking surface-crossing (prev feet -> now feet),
/// plus a small "near surface" tolerance for tile-clamp cases.
/// Also supports oblique art by insetting left/right kill area.

if (!enabled) exit;

// Optional: active frames window
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
// Tunables (set per instance in editor)
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
var t = (variable_instance_exists(id, "kill_surface_y")) ? kill_surface_y : bbox_top;

var l = (variable_instance_exists(id, "kill_left"))  ? kill_left  : bbox_left;
var r = (variable_instance_exists(id, "kill_right")) ? kill_right : bbox_right;

// Apply oblique inset
l += inset_x;
r -= (inset_x + inset_x2);

// Safety clamp
if (r < l) {
    var mid = (bbox_left + bbox_right) * 0.5;
    l = mid; r = mid;
}

var b = t + band_h;

// ----------------------------------------------------
// Player feet now + previous (to detect crossing at high speed)
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
var over_teeth = (feet_x > l && feet_x < r);
var body_over  = (p.bbox_right > l && p.bbox_left < r);
if (!(over_teeth && body_over)) exit;

// ----------------------------------------------------
// Kill tests
// ----------------------------------------------------
var in_band      = (feet_now >= (t + depth_px) && feet_now <= b);
var crossed      = (feet_prev < t && feet_now >= t);
var near_surface = (feet_now >= (t - headroom) && feet_now < t);

if (in_band || crossed || near_surface)
{
    var lock_feet_y = t + sink_h;

    with (p) {
        scr_player_died(lock_feet_y);
    }
}
