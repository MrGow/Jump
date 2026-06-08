/// oSpinnerPlatform — Create

event_inherited();

sprite_index = spriteSpinnerPlatform;
mask_index   = spriteSpinnerPlatform;

visible = true;
enabled = true;
active  = true;

// Allows side/below collision through oPlayer tile_any_solid_at()
solid_body = true;
solid_only_when_active = true;

image_speed = 0;
image_index = 0;
image_angle = 0;

depth = -200;

owner_spinner = noone;
orbit_angle = 0;
orbit_radius = 42;
platform_index = 0;

// Floor-surface compatibility
surface_inset_left  = 0;
surface_inset_right = 0;
surface_y_offset    = 0;
surface_y           = bbox_top + surface_y_offset;

dx = 0;
dy = 0;