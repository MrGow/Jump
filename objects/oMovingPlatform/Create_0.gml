/// oMovingPlatform — Create
event_inherited();

sprite_index = spriteMovingPlatform;
image_speed  = 0;

enabled = true;
active  = true;
solid_body = true;
solid_only_when_active = false;

// ----------------------------------------------------
// Per-instance settings (room editor)
// ----------------------------------------------------
if (!variable_instance_exists(id, "move_id"))             move_id = 0;
if (!variable_instance_exists(id, "move_speed"))          move_speed = 1.0;
if (!variable_instance_exists(id, "pause_frames_end"))    pause_frames_end = 0;
if (!variable_instance_exists(id, "start_toward_marker")) start_toward_marker = true;
if (!variable_instance_exists(id, "debug_draw"))          debug_draw = false;

// Standing zone tuning
if (!variable_instance_exists(id, "ride_side_inset"))     ride_side_inset = 2;
if (!variable_instance_exists(id, "ride_top_tolerance"))  ride_top_tolerance = 6;
if (!variable_instance_exists(id, "ride_min_overlap"))    ride_min_overlap = 6;

// ----------------------------------------------------
// Internal
// ----------------------------------------------------
start_x = x;
start_y = y;

target_x = x;
target_y = y;

marker_found = false;

travel_dir = start_toward_marker ? 1 : -1;
pause_timer = 0;

prev_x = x;
prev_y = y;
dx = 0;
dy = 0;

prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;