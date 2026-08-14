/// oTeleporterSolid — Create

event_inherited();


// ====================================================
// COLLISION MASK
// ====================================================

sprite_index =
    spriteTeleporterMaskSolid;

mask_index =
    spriteTeleporterMaskSolid;

image_index =
    0;

image_speed =
    0;


// ====================================================
// OWNER
// ====================================================

owner_teleporter =
    noone;


// ====================================================
// DEBUG
// ====================================================

debug_draw =
    false;


// Must remain visible or its Draw event won't execute.
//
// We don't use draw_self(), so the actual mask won't
// appear unless debug_draw is enabled.
visible =
    true;