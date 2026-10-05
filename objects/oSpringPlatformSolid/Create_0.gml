/// oSpringPlatformSolid — Create

event_inherited();

sprite_index =
    spriteSpringPlatformSolidMask;

mask_index =
    spriteSpringPlatformSolidMask;


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
// The visible oSpringPlatform owns the top bounce
// surface.
//
// Lower this helper slightly so diagonal landings near
// either edge are not interpreted as wall collisions.
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