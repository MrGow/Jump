/// oLaserGun — Create

event_inherited();

sprite_index = spriteLaserGunShoot;
image_speed  = 0;
image_index  = 0;

enabled = true;
active  = false;

// Editor variable:
// "right", "up", "left", "down"
if (!variable_instance_exists(id, "laser_facing")) laser_facing = "right";

if (laser_facing == "right") {
    laser_dir = 0;
    image_angle = 0;
}
else if (laser_facing == "up") {
    laser_dir = 90;
    image_angle = 90;
}
else if (laser_facing == "left") {
    laser_dir = 180;
    image_angle = 180;
}
else if (laser_facing == "down") {
    laser_dir = 270;
    image_angle = 270;
}
else {
    laser_dir = 0;
    image_angle = 0;
}

// Timing
if (!variable_instance_exists(id, "wait_frames")) wait_frames = room_speed * 1.5;
if (!variable_instance_exists(id, "fire_hold_frames")) fire_hold_frames = room_speed * 0.75;
if (!variable_instance_exists(id, "fire_frame")) fire_frame = 10;

anim_speed = 0.35;

state = "waiting";
timer = wait_frames;
fire_timer = 0;

// Laser tuning
if (!variable_instance_exists(id, "max_laser_length")) max_laser_length = 640;
if (!variable_instance_exists(id, "ray_step")) ray_step = 4;
if (!variable_instance_exists(id, "laser_start_dist")) laser_start_dist = 72;

laser_start_x = 0;
laser_start_y = 0;
laser_end_x   = 0;
laser_end_y   = 0;
laser_len     = 0;

// Shared manual frame for beam + end animation
laser_fx_frame = 0;

debug_draw = false;