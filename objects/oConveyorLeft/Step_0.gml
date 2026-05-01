/// oConveyorLeft - Step
var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// Basic overlap check
var overlap =
    (p.bbox_right  > bbox_left)  &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top)   &&
    (p.bbox_top    < bbox_bottom);

if (!overlap) exit;

// Detect "standing on top"
var surf_y = bbox_top + surface_offset;
var on_top =
    (p.bbox_bottom >= surf_y - 2) &&
    (p.bbox_bottom <= surf_y + top_band_px);

if (on_top) {
    // Optional solid blocking check by name (safe if object doesn't exist)
    var solid_obj = asset_get_index("oSolid");
    var can_move = true;

    if (solid_obj != -1) {
        if (place_meeting(p.x + belt_speed, p.y, solid_obj)) {
            can_move = false;
        }
    }

    if (can_move) {
        p.x += belt_speed;
    }

    // Optional: feed hsp too, for systems that read it
    if (variable_instance_exists(p, "hsp")) {
        p.hsp += belt_speed;
    }
}
else if (use_air_drag) {
    p.x += air_drag_speed;
    if (variable_instance_exists(p, "hsp")) p.hsp += air_drag_speed;
}