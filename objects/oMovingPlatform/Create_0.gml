/// oMovingPlatform — Create
event_inherited();

sprite_index = spriteMovingPlatform;
image_speed  = 0;

// Treated as a solid moving platform
enabled = true;
active  = true;
solid_body = true;
solid_only_when_active = false;

// ----------------------------------------------------
// Per-instance settings (set these in the room editor)
// ----------------------------------------------------
if (!variable_instance_exists(id, "move_id"))            move_id = 0;
if (!variable_instance_exists(id, "move_speed"))         move_speed = 1.0;
if (!variable_instance_exists(id, "pause_frames_end"))   pause_frames_end = 0;
if (!variable_instance_exists(id, "start_toward_marker")) start_toward_marker = true;
if (!variable_instance_exists(id, "debug_draw"))         debug_draw = false;

// ----------------------------------------------------
// Internal
// Platform start point = placed room position
// Marker point = looked up in Room Start
// ----------------------------------------------------
start_x = x;
start_y = y;

target_x = x;
target_y = y;

marker_found = false;

// Motion state
travel_dir = start_toward_marker ? 1 : -1; // 1=start->marker, -1=marker->start
pause_timer = 0;

// Previous/platform delta for carrying player
prev_x = x;
prev_y = y;
dx = 0;
dy = 0;