/// oMovingPlatform — End Step
/// Carry player when standing on top

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (dx == 0 && dy == 0) exit;

// Don't affect dead player
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// ----------------------------------------------------
// Check if player is standing on the top surface
// ----------------------------------------------------
var standing_horiz =
    (p.bbox_right > bbox_left + 2) &&
    (p.bbox_left  < bbox_right - 2);

var feet_near_top =
    (abs(p.bbox_bottom - bbox_top) <= 3);

var moving_down_or_grounded = true;
if (variable_instance_exists(p, "vsp")) {
    moving_down_or_grounded = (p.vsp >= 0);
}

if (standing_horiz && feet_near_top && moving_down_or_grounded)
{
    with (p)
    {
        x += other.dx;
        y += other.dy;

        // keep grounded state coherent
        if (variable_instance_exists(id, "ground_stick")) ground_stick = max(ground_stick, 1);
        if (variable_instance_exists(id, "prev_on_ground")) prev_on_ground = true;
    }
}