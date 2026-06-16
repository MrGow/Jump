/// oMovingPlatformCrane — Create

event_inherited();

sprite_index = spriteMovingPlatformCrane;
mask_index   = spriteMovingPlatformCrane;

image_speed = 0;

// Refresh previous bounds after sprite swap
prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;