/// oSpringPlatformAngular — Create

event_inherited();

sprite_index = spriteHazardBouncePadWall;
mask_index   = spriteHazardBouncePadWall;

enabled = true;
active  = true;

image_speed = 0;
image_index = 0;

// Direction this pad launches the player.
//  1 = launches up/right
// -1 = launches up/left
if (!variable_instance_exists(id, "wall_dir")) {
    wall_dir = (image_xscale >= 0) ? 1 : -1;
}

angular_h_power = 5.0;
angular_v_power = 10.5;

player_retrigger_lock_frames = 4;

pressed_frames = 8;
pressed_timer  = 0;

debug_draw = false;