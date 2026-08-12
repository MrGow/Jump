/// oAdminLayerCannonSolid — Step


// ====================================================
// OWNER SAFETY
// ====================================================

if (
    owner_cannon == noone ||
    !instance_exists(owner_cannon)
)
{
    instance_destroy();
    exit;
}


// ====================================================
// FOLLOW CANNON
// ====================================================

x =
    owner_cannon.x;

y =
    owner_cannon.y;


// The physical body does NOT rotate with barrel facing.
image_angle = 0;


// ====================================================
// ENABLED STATE
// ====================================================

enabled =
    owner_cannon.enabled;

active =
    enabled;


// ====================================================
// ENFORCE MASK
// ====================================================

sprite_index =
    spriteAdminLayerCannonMaskSolid;

mask_index =
    spriteAdminLayerCannonMaskSolid;

image_speed = 0;
image_index = 0;


// ====================================================
// DEBUG SYNC
// ====================================================

if (
    variable_instance_exists(
        owner_cannon,
        "debug_draw"
    )
)
{
    debug_draw =
        owner_cannon.debug_draw;
}