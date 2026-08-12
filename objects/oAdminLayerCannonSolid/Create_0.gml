/// oAdminLayerCannonSolid — Create

event_inherited();


// ====================================================
// COLLISION MASK
// ====================================================

sprite_index =
    spriteAdminLayerCannonMaskSolid;

mask_index =
    spriteAdminLayerCannonMaskSolid;

image_speed = 0;
image_index = 0;

image_angle = 0;


// ====================================================
// SOLID SETTINGS
// ====================================================

enabled = true;
active  = true;

solid_body = true;

solid_only_when_active = false;


// ====================================================
// OWNER
// ====================================================

owner_cannon = noone;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// DRAW
//
// Must remain visible so our Draw event can run.
// The sprite itself is only shown when debug_draw=true.
// ====================================================

visible = true;