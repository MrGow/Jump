/// oSpringPlatform — Create
event_inherited();

mask_index = spriteSpringPlatformMask;
enabled = true;
active  = true;

// This object is handled by the floor-surface system now
solid_body = true;
solid_only_when_active = false;

// Sprite
sprite_index = spriteHazardBouncePad;
image_speed  = 0;

// ----------------------------------------------------
// Spring tuning
// ----------------------------------------------------
spring_power      = 12;
spring_h_mult     = 1.0;
spring_min_h_kick = 1.8;
spring_max_h_kick = 3.25;

top_inset        = -2; // wider than sprite
surface_y_offset = 1;  // slightly more generous vertically
surface_x_offset = 0;
min_overlap_px   = 5.5;  // easier edge trigger
edge_bias_px     = 2;

player_retrigger_lock_frames = 4;

// ----------------------------------------------------
// Floor-surface compatibility
// ----------------------------------------------------
surface_inset_left  = top_inset;
surface_inset_right = top_inset;
surface_y           = bbox_top + surface_y_offset;
dx = 0;
dy = 0;

// ----------------------------------------------------
// Visual press/recover animation
// ----------------------------------------------------
pressed_frames = 8;
pressed_timer  = 0;

// Optional debug
debug_draw = false;