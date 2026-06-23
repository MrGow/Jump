/// oArea4MovingPlatform — Create

event_inherited();

sprite_index = spriteArea4MovingPlatform;
mask_index   = spriteArea4MovingPlatform;

// Thruster animation
image_speed = 0.35;

// Optional platform loop SFX
snd_moving_platform_loop = asset_get_index("MovingPlatformArea4Loop1");

moving_platform_loop_gain = 0.18;
moving_platform_loop_pitch = 1.0;

moving_platform_loop_inner_dist = 90;
moving_platform_loop_outer_dist = 320;

prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;