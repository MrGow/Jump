/// oMovingPlatformCrane — Create

event_inherited();

sprite_index = spriteMovingPlatformCrane;
mask_index   = spriteMovingPlatformCrane;

image_speed = 0;

// ----------------------------------------------------
// Override platform loop SFX
// ----------------------------------------------------
snd_moving_platform_loop = asset_get_index("MovingPlatformCraneLoop1");

moving_platform_loop_gain = 0.28;
moving_platform_loop_pitch = 1.0;

moving_platform_loop_inner_dist = 120;
moving_platform_loop_outer_dist = 420;

// Refresh previous bounds after sprite swap
prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;