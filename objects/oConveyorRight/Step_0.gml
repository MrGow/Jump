/// oConveyorRight - Step

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// AABB overlap with player
var overlap =
    (p.bbox_right  > bbox_left)  &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top)   &&
    (p.bbox_top    < bbox_bottom);

if (!overlap) exit;

// Is player standing on conveyor top?
var surf_y = bbox_top + surface_offset;
var on_top =
    (p.bbox_bottom >= surf_y - 2) &&
    (p.bbox_bottom <= surf_y + top_band_px);

if (on_top)
{
    // Optional blocking against object named "oSolid" (safe if it doesn't exist)
    var solid_obj = asset_get_index("oSolid");
    var can_move = true;

    if (solid_obj != -1) {
        if (place_meeting(p.x + belt_speed, p.y, solid_obj)) {
            can_move = false;
        }
    }

    if (can_move) {
        // Transport player directly.
        // IMPORTANT: do not add to p.hsp (prevents charge-jump slingshot bug).
        p.x += belt_speed;
    }
}
else if (use_air_drag)
{
    // Optional tiny pull when merely overlapping
    p.x += air_drag_speed;
}