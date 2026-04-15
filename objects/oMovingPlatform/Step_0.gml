/// oMovingPlatform — Step

if (!enabled) exit;

active = true;
solid_body = true;

// Store previous transform/bounds
prev_x = x;
prev_y = y;

prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;

dx = 0;
dy = 0;

if (!marker_found) exit;

if (pause_timer > 0) {
    pause_timer--;
    exit;
}

// ----------------------------------------------------
// Destination
// ----------------------------------------------------
var dest_x = (travel_dir == 1) ? target_x : start_x;
var dest_y = (travel_dir == 1) ? target_y : start_y;

var dist = point_distance(x, y, dest_x, dest_y);

if (dist <= move_speed || dist <= 0.0001)
{
    x = dest_x;
    y = dest_y;

    travel_dir = -travel_dir;
    pause_timer = pause_frames_end;
}
else
{
    var dir = point_direction(x, y, dest_x, dest_y);
    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
}

dx = x - prev_x;
dy = y - prev_y;