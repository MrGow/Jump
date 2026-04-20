/// oSpringPlatform — Create
event_inherited();
mask_index = spriteSpringPlatformMask;
enabled = true;
active  = true;

// Make player collision system treat this as a solid object
solid_body = true;
solid_only_when_active = false;

// Sprite
sprite_index = spriteHazardBouncePad;
image_speed  = 0;

// ----------------------------------------------------
// Spring tuning
// ----------------------------------------------------
spring_power        = 12; // upward launch speed
spring_h_mult       = 1; // scales incoming horizontal into spring kick
spring_min_h_kick   = 1.8;  // guaranteed sideways kick so player won't softlock bouncing forever
spring_max_h_kick   = 3.25; // clamp so it doesn't get silly

top_inset           = 2;    // slightly shrink usable top width
surface_y_offset    = 2;    // tweak if visible top plate sits slightly below bbox_top
min_overlap_px      = 6;    // require at least this much body overlap to trigger reliably
edge_bias_px        = 2;    // tiny center bias helper when deciding kick direction

// If player somehow remains overlapping, don't retrigger instantly forever
player_retrigger_lock_frames = 4;

// ----------------------------------------------------
// Visual press/recover animation
// ----------------------------------------------------
pressed_frames = 8;
pressed_timer  = 0;

// Optional debug
debug_draw = false;