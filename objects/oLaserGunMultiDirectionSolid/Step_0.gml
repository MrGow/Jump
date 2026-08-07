/// oLaserGunMultiDirectionSolid — Step


// ====================================================
// OWNER SAFETY
// ====================================================

if (
    owner_gun == noone ||
    !instance_exists(
        owner_gun
    )
)
{
    instance_destroy();
    exit;
}


// ====================================================
// FOLLOW OWNER
// ====================================================

x =
    owner_gun.x;

y =
    owner_gun.y;


// Multidirectional gun does not need facing rotation.
image_angle = 0;


// ====================================================
// ENABLED STATE
// ====================================================

enabled =
    owner_gun.enabled;

active =
    enabled;


// ====================================================
// ENFORCE MASK
// ====================================================

sprite_index =
    spriteLaserGunMultiDirectionCollisionMaskSolid;

mask_index =
    spriteLaserGunMultiDirectionCollisionMaskSolid;

image_speed = 0;
image_index = 0;