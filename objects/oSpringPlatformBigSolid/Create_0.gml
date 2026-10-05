/// oSpringPlatformBigSolid — Create

event_inherited();

sprite_index =
    spriteSpringPlatformBigSolidMask;

mask_index =
    spriteSpringPlatformBigSolidMask;


// ====================================================
// SOLID STATE
// ====================================================

enabled = true;
active  = true;

solid_body = true;
solid_only_when_active = false;


// ====================================================
// SIDE-COLLISION INSET
//
// The visible spring's top is handled by
// oSpringPlatformBig as a floor surface.
//
// Lower this helper slightly so landing near the edge
// does not get interpreted as a horizontal wall hit.
// ====================================================

side_collision_top_inset = 6;


// ====================================================
// VISUAL
// ====================================================

visible = false;
debug_draw = false;

image_speed = 0;
image_index = 0;


// ====================================================
// ORIGINAL POSITION
// ====================================================

solid_base_y = y;

y =
    solid_base_y +
    side_collision_top_inset;