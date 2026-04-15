/// oMovingPlatform — End Step
/// Mark player as standing on this platform for the NEXT frame.

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
} else if (variable_instance_exists(p, "vsp")) {
    feet_prev = feet_now - p.vsp;
} else {
    feet_prev = feet_now;
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

var landed_from_above =
    (overlap_prev_w >= ride_min_overlap || overlap_w >= ride_min_overlap) &&
    (feet_prev <= prev_top_y + 1) &&
    (feet_now  >= top_y - 2) &&
    (feet_now  <= top_y + ride_top_tolerance);

var upward_jump = false;
if (variable_instance_exists(p, "vsp")) upward_jump = (p.vsp < 0);

// Only mark if actually rideable this frame
if (!(standing_now || landed_from_above) || upward_jump) exit;

with (p)
{
    var _new_attach = (standing_platform != other.id);

    standing_platform = other.id;

    // Capture local X offset the instant we attach
    if (_new_attach) {
        standing_platform_xoff = x - other.x;
    }
}