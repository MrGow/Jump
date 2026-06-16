/// oConveyorVerticalUp — Step

if (!enabled) exit;

active = true;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (variable_instance_exists(p, "state") && p.state == "dead")
{
    if (player_lock == p) player_lock = noone;
    exit;
}

// ----------------------------------------------------
// If currently carrying player
// ----------------------------------------------------
if (player_lock == p)
{
    // If player somehow leaves the belt area sideways, release
    var still_inside =
        (p.bbox_right  > bbox_left  - attach_pad_x) &&
        (p.bbox_left   < bbox_right + attach_pad_x) &&
        (p.bbox_bottom > bbox_top) &&
        (p.bbox_top    < bbox_bottom);

    if (!still_inside)
    {
        player_lock = noone;
        exit;
    }

    // Snap to centre of conveyor
    p.x = x + snap_x_offset;

    // Carry upward
    p.y -= magnet_speed;

    // Kill normal movement while attached
    if (variable_instance_exists(p, "hsp")) p.hsp = 0;
    if (variable_instance_exists(p, "vsp")) p.vsp = 0;

    if (variable_instance_exists(p, "jump_charging")) jump_charging = false;
    if (variable_instance_exists(p, "standing_platform")) p.standing_platform = noone;
    if (variable_instance_exists(p, "coyote_timer")) p.coyote_timer = 0;

    // Release/fling when reaching top
    if (p.bbox_top <= bbox_top + top_release_pad)
    {
        player_lock = noone;

        p.y = bbox_top - (p.bbox_bottom - p.y) - 1;

        p.vsp = -fling_power;

        if (variable_instance_exists(p, "state")) p.state = "jumping";
        if (variable_instance_exists(p, "jump_pose_timer")) p.jump_pose_timer = p.jump_pose_min_frames;
    }

    exit;
}

// ----------------------------------------------------
// Attach player when overlapping conveyor
// ----------------------------------------------------
var overlap =
    (p.bbox_right  > bbox_left  - attach_pad_x) &&
    (p.bbox_left   < bbox_right + attach_pad_x) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom);

if (!overlap) exit;

// Attach
player_lock = p;

// Clear player movement states
if (variable_instance_exists(p, "jump_charging")) p.jump_charging = false;
if (variable_instance_exists(p, "jump_charge")) p.jump_charge = 0;
if (variable_instance_exists(p, "jump_charge_level")) p.jump_charge_level = 0;
if (variable_instance_exists(p, "standing_platform")) p.standing_platform = noone;
if (variable_instance_exists(p, "hsp")) p.hsp = 0;
if (variable_instance_exists(p, "vsp")) p.vsp = 0;