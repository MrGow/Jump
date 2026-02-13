/// oScrapCrusher — End Step (FULL)
/// Robust kill even with big bounces / tile collision clamping.
/// Uses player-stored previous feet (crusher_prev_feet_y) if present.
/// Uses inset + feet-center-x + depth threshold so oblique art doesn’t “kill early”.

if (!enabled) exit;

// Active frame window (optional)
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

// Frozen surface + extents (fallback if old instances)
var surf_y = (variable_instance_exists(id, "kill_surface_y")) ? kill_surface_y : bbox_top;
var left0  = (variable_instance_exists(id, "kill_left"))      ? kill_left      : bbox_left;
var right0 = (variable_instance_exists(id, "kill_right"))     ? kill_right     : bbox_right;

// Tunables
var band_h   = (variable_instance_exists(id, "kill_band_h"))      ? kill_band_h      : 6;
var depth_px = (variable_instance_exists(id, "kill_depth_px"))    ? kill_depth_px    : 2;
var inset_x  = (variable_instance_exists(id, "kill_inset_x"))     ? kill_inset_x     : 12;
var headroom = (variable_instance_exists(id, "kill_headroom_px")) ? kill_headroom_px : 2;
var sink_h   = (variable_instance_exists(id, "sink_px"))          ? sink_px          : 6;

var t = surf_y;
var b = t + band_h;

// Optional: only kill when falling (OFF by default — bounces can clamp vsp)
if (kill_only_when_falling) {
    var pv_check = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    if (pv_check < 0) exit;
}

// Horizontal “teeth strip” (inset to match oblique art)
var l = left0 + inset_x;
var r = right0 - inset_x;
if (r < l) { var mid = (left0 + right0) * 0.5; l = mid; r = mid; }

// Require feet-center to be over teeth strip
var feet_x = (p.bbox_left + p.bbox_right) * 0.5;
if (!(feet_x > l && feet_x < r)) exit;

// Feet now and previous (from Begin Step, before collisions)
var feet_now = p.bbox_bottom;

var feet_prev;
if (variable_instance_exists(p, "crusher_prev_feet_y")) feet_prev = p.crusher_prev_feet_y;
else {
    var pv = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    feet_prev = feet_now - pv;
}

// Conditions:
// A) deep enough into band (prevents “barely touching” kills)
var in_band_deep = (feet_now >= (t + depth_px) && feet_now <= b);

// B) crossed the surface this frame (falling onto it)
var crossed = (feet_prev < t && feet_now >= t);

// C) near-surface ONLY counts if crossed (prevents “standing nearby” kills)
//    This handles tile clamp leaving feet slightly above t on impact.
var crossed_near = crossed && (feet_now >= (t - headroom) && feet_now < t);

if (in_band_deep || crossed || crossed_near)
{
    var lock_feet_y = t + sink_h;

    // Call death on player context, with optional sink lock
    with (p) {
        scr_player_died(lock_feet_y);
    }
}
