/// oFirstSpawn — Create
// Place at the desired landing area. Real player physics handles the fall.
// The room-editor oPlayer may remain in the starting camera zone.

if (!variable_instance_exists(id, "fall_height")) fall_height = 520;
if (!variable_instance_exists(id, "empty_hold_frames")) empty_hold_frames = 40;
if (!variable_instance_exists(id, "fall_offset_x")) fall_offset_x = -32;
if (!variable_instance_exists(id, "fall_drift_speed")) fall_drift_speed = 0.35;
if (!variable_instance_exists(id, "settle_frames")) settle_frames = 20;
if (!variable_instance_exists(id, "bars_height")) bars_height = 38;
if (!variable_instance_exists(id, "bars_open_frames")) bars_open_frames = 28;
if (!variable_instance_exists(id, "camera_offset_x")) camera_offset_x = 0;
if (!variable_instance_exists(id, "camera_offset_y")) camera_offset_y = -14;
if (!variable_instance_exists(id, "force_preview")) force_preview = false;

if (!variable_global_exists("first_spawn_played"))
    global.first_spawn_played = false;

landing_x = x;
landing_y = y;
player_ref = noone;
camera_ref = noone;
opening_zone = noone;
started = false;
state = "waiting";
hold_tick = 0;
settle_tick = 0;
bars_tick = 0;
bars_amount = 1;
has_landed = false;
old_trail_enabled = true;
old_camera_locked = false;

if (room_get_name(room) != "Scrapyard1" ||
    (global.first_spawn_played && !force_preview))
{
    instance_destroy();
    exit;
}
