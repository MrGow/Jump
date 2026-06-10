/// oLaserGun — Create

event_inherited();

sprite_index = spriteLaserGunShoot;
image_speed  = 0;
image_index  = 0;

enabled = true;
active  = false;

// Direction laser shoots:
// 0 = right, 90 = up, 180 = left, 270 = down
if (!variable_instance_exists(id, "laser_dir")) laser_dir = 0;

// Timing
if (!variable_instance_exists(id, "wait_frames")) wait_frames = room_speed * 1.5;
if (!variable_instance_exists(id, "fire_hold_frames")) fire_hold_frames = room_speed * 0.75;

// GM frame where laser begins
if (!variable_instance_exists(id, "fire_frame")) fire_frame = 10;

anim_speed = 0.35;

state = "waiting";
timer = wait_frames;
fire_timer = 0;

// Laser tuning
if (!variable_instance_exists(id, "max_laser_length")) max_laser_length = 640;
if (!variable_instance_exists(id, "ray_step")) ray_step = 4;

// Pull end splash slightly back from walls/ceilings/floors
if (!variable_instance_exists(id, "wall_end_inset")) wall_end_inset = 50;

// Ray spawn offset from gun origin
if (!variable_instance_exists(id, "laser_start_dist")) laser_start_dist = 72;

laser_start_x = 0;
laser_start_y = 0;
laser_end_x   = 0;
laser_end_y   = 0;
laser_len     = 0;

debug_draw = false;