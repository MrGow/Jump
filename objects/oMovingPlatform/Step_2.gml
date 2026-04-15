/// oMovingPlatform — End Step
/// Publish ride info to the player if they are standing on top.

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// ----------------------------------------------------
// Top ride zone
// ----------------------------------------------------
var top_l = bbox_left  + ride_side_inset;
var top_r = bbox_right - ride_side_inset;
var top_y = bbox_top;

var prev_top_l = prev_left  + ride_side_inset;
var prev_top_r = prev_right - ride_side_inset;
var prev_top_y = prev_top;

// Player feet now / previous
var feet_now  = p.bbox_bottom;
var feet_prev;

if (variable_instance_exists(p, "crusher_prev_feet_y")) {
    feet_prev = p.crusher_prev_feet_y;
} else {
    var pv_fallback = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    feet_prev = feet_now - pv_fallback;
}

// Current overlap
var overlap_l = max(p.bbox_left,  top_l);
var overlap_r = min(p.bbox_right, top_r);
var overlap_w = overlap_r - overlap_l;

// Previous overlap
var overlap_prev_l = max(p.bbox_left,  prev_top_l);
var overlap_prev_r = min(p.bbox_right, prev_top_r);
var overlap_prev_w = overlap_prev_r - overlap_prev_l;

var standing_now =
    (overlap_w >= ride_min_overlap) &&
    (feet_now >= top_y - 2) &&
    (feet_now <= top_y + ride_top_tolerance);

var landed_from_above_local =
    (overlap_prev_w >= ride_min_overlap || overlap_w >= ride_min_overlap) &&
    (feet_prev <= prev_top_y + 1) &&
    (feet_now  >= top_y - 2) &&
    (feet_now  <= top_y + ride_top_tolerance);

var upward_jump = false;
if (variable_instance_exists(p, "vsp")) upward_jump = (p.vsp < 0);

// Only publish if actually rideable this frame
if (!(standing_now || landed_from_above_local) || upward_jump) exit;

// Store onto this platform instance so `other` can read it safely in with()
landed_from_above = landed_from_above_local;

// ----------------------------------------------------
// Publish ride info to player
// ----------------------------------------------------
with (p)
{
    mp_ride_active   = true;
    mp_ride_id       = other.id;
    mp_ride_dx       = other.dx;
    mp_ride_dy       = other.dy;
    mp_ride_top      = other.bbox_top;
    mp_ride_left     = other.bbox_left;
    mp_ride_right    = other.bbox_right;
    mp_ride_landed   = other.landed_from_above;
}