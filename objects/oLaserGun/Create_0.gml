/// oLaserGun — Create

event_inherited();

sprite_index = spriteLaserGunShoot;
image_speed  = 0;
image_index  = 0;

enabled = true;
active  = false;

solid_body = false;
solid_only_when_active = false;

// SFX
snd_laser_shoot = asset_get_index("LaserGunShoot1");
laser_shoot_gain = 0.9;
laser_sfx_inner_dist = 120;
laser_sfx_outer_dist = 520;
laser_shot_sfx_played = false;

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
// The final two sprite frames form the firing loop.
// Eight frames = indices 0–7, so this becomes frame 6.
fire_frame =
    max(
        0,
        sprite_get_number(sprite_index) - 2
    );

// Slower so the muzzle-flash frames remain visible.
anim_speed = 0.18;

state = "waiting";
timer = wait_frames;
fire_timer = 0;

// Laser tuning
if (!variable_instance_exists(id, "max_laser_length")) max_laser_length = 640;
if (!variable_instance_exists(id, "ray_step")) ray_step = 4;
if (!variable_instance_exists(id, "laser_start_dist")) laser_start_dist = 72;
if (!variable_instance_exists(id, "laser_hit_start_back")) laser_hit_start_back = 16;
if (!variable_instance_exists(id, "laser_hit_pad")) laser_hit_pad = 3;

laser_start_x = 0;
laser_start_y = 0;
laser_end_x   = 0;
laser_end_y   = 0;
laser_len     = 0;

laser_fx_frame = 0;

debug_draw = false;

// Spawn physical cannon collision
solid_inst = instance_create_layer(x, y, "Instances", oLaserGunSolid);
solid_inst.image_angle = image_angle;