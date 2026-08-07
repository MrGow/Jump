/// oFloatingLaserGunSolid — Step

// ====================================================
// OWNER SAFETY
// ====================================================

if (
    owner_gun == noone ||
    !instance_exists(owner_gun)
)
{
    instance_destroy();
    exit;
}


// ====================================================
// FOLLOW FLOATING GUN
// ====================================================

x =
    owner_gun.x;

y =
    owner_gun.y;

image_angle =
    owner_gun.image_angle;


// ====================================================
// ENABLED STATE
// ====================================================

enabled =
    owner_gun.enabled;

active =
    enabled;


// ----------------------------------------------------
// The sprite/mask must remain the dedicated solid mask.
// ----------------------------------------------------
sprite_index =
    spriteLaserGunFloatingCollisionMaskSolid;

mask_index =
    spriteLaserGunFloatingCollisionMaskSolid;

image_speed = 0;
image_index = 0;