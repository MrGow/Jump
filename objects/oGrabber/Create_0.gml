/// oGrabber — Create

if (!variable_instance_exists(id, "route_id")) route_id = 0;
if (!variable_instance_exists(id, "move_speed")) move_speed = 2.0;
if (!variable_instance_exists(id, "close_animation_speed")) close_animation_speed = 0.25;
if (!variable_instance_exists(id, "open_animation_speed")) open_animation_speed = 0.25;
if (!variable_instance_exists(id, "connector_segments")) connector_segments = 2;
if (!variable_instance_exists(id, "capture_half_width")) capture_half_width = 16;
if (!variable_instance_exists(id, "capture_top_offset")) capture_top_offset = 0;
if (!variable_instance_exists(id, "capture_bottom_offset")) capture_bottom_offset = 28;
if (!variable_instance_exists(id, "player_hold_top_offset")) player_hold_top_offset = 10;
if (!variable_instance_exists(id, "release_momentum")) release_momentum = 1.0;
if (!variable_instance_exists(id, "release_vsp")) release_vsp = 0;
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;

connector_segments = max(0, round(connector_segments));

// Hanging-motion tuning
if (!variable_instance_exists(id, "sway_length")) sway_length = 24;
if (!variable_instance_exists(id, "sway_move_lean")) sway_move_lean = 5.0;
if (!variable_instance_exists(id, "sway_idle_amount")) sway_idle_amount = 1.1;
if (!variable_instance_exists(id, "sway_idle_speed")) sway_idle_speed = 0.075;
if (!variable_instance_exists(id, "sway_spring")) sway_spring = 0.075;
if (!variable_instance_exists(id, "sway_damping")) sway_damping = 0.88;
if (!variable_instance_exists(id, "sway_stop_kick")) sway_stop_kick = 1.6;
if (!variable_instance_exists(id, "sway_release_kick")) sway_release_kick = 0.22;
if (!variable_instance_exists(id, "catch_jerk_pixels")) catch_jerk_pixels = 2.0;
if (!variable_instance_exists(id, "machine_vibration_amount")) machine_vibration_amount = 0.65;

start_x = x;
start_y = y;
destination = noone;
grabbed_player = noone;
grab_state = "idle";
dx = 0;
dy = 0;
last_dx = 0;
release_armed = false;
claw_opening = false;

// Visual-only secondary motion
sway_angle = 0;
sway_velocity = 0;
sway_phase = random(100);
catch_jerk = 0;
player_visual_offset_x = 0;
player_visual_offset_y = 0;
player_visual_angle = 0;
machine_visual_y = 0;

image_speed = 0;
image_index = max(0, image_number - 1);

