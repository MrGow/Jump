/// oSpringPlatformAngular — Create

event_inherited();

sprite_index = spriteHazardBouncePadWall;
mask_index   = spriteHazardBouncePadWall;

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;

image_speed = 1;
image_index = 0;

//  1 = launches up/right
// -1 = launches up/left


angular_h_power = 5.25;
angular_v_power = 10.5;

player_retrigger_lock_frames = 8;

pressed_frames = 8;
pressed_timer  = 0;

debug_draw = false;