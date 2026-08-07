/// oLaserGunMultiDirectionSolid — Create

event_inherited();


// ====================================================
// COLLISION MASK
// ====================================================

sprite_index =
    spriteLaserGunMultiDirectionCollisionMaskSolid;

mask_index =
    spriteLaserGunMultiDirectionCollisionMaskSolid;

image_speed = 0;
image_index = 0;


// ====================================================
// PHYSICAL SOLID
// ====================================================

enabled = true;
active  = true;

solid_body = true;

solid_only_when_active = false;


// ====================================================
// OWNER
// ====================================================

owner_gun = noone;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// DRAW BEHAVIOUR
//
// We use our own Draw event, so the helper does not
// normally display its collision sprite.
// ====================================================

visible = true;