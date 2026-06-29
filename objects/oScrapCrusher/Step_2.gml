/// oScrapCrusher — End Step

if (scr_game_frozen()) exit;

if (!enabled) exit;

// Active frame window
if (use_active_frames) {
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

// Frozen surface + extents
var surf_y = (variable_instance_exists(id, "kill_surface_y")) ? kill_surface_y : bbox_top;
var left0  = (variable_instance_exists(id, "kill_left"))      ? kill_left      : bbox_left;
var right0 = (variable_instance_exists(id, "kill_right"))     ? kill_right     : bbox_right;

// Tunables
var band_h   = (variable_instance_exists(id, "kill_band_h"))      ? kill_band_h      : 6;
var depth_px = (variable_instance_exists(id, "kill_depth_px"))    ? kill_depth_px    : 2;
var inset_x  = (variable_instance_exists(id, "kill_inset_x"))     ? kill_inset_x     : 12;
var headroom = (variable_instance_exists(id, "kill_headroom_px")) ? kill_headroom_px : 2;
var sink_h   = (variable_instance_exists(id, "sink_px"))          ? sink_px          : 6;

var top_y = surf_y;
var bottom_y = top_y + band_h;

// Optional: only kill when falling
if (kill_only_when_falling) {
    var pv_check = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    if (pv_check < 0) exit;
}

// Horizontal teeth strip
var left_x = left0 + inset_x;
var right_x = right0 - inset_x;
if (right_x < left_x) {
    var mid = (left0 + right0) * 0.5;
    left_x = mid;
    right_x = mid;
}

// Require feet-center to be over teeth strip
var feet_x = (p.bbox_left + p.bbox_right) * 0.5;
if (!(feet_x > left_x && feet_x < right_x)) exit;

// Feet now and previous
var feet_now = p.bbox_bottom;

var feet_prev;
if (variable_instance_exists(p, "crusher_prev_feet_y")) {
    feet_prev = p.crusher_prev_feet_y;
} else {
    var pv = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    feet_prev = feet_now - pv;
}

var in_band_deep = (feet_now >= (top_y + depth_px) && feet_now <= bottom_y);
var crossed = (feet_prev < top_y && feet_now >= top_y);
var crossed_near = crossed && (feet_now >= (top_y - headroom) && feet_now < top_y);

if (in_band_deep || crossed || crossed_near)
{
    var lock_feet_y = top_y + sink_h;

    with (p) {
        scr_player_died(lock_feet_y);
    }
}