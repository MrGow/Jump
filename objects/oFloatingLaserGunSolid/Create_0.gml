/// oFloatingLaserGunSolid — Create

event_inherited();

sprite_index =
    spriteLaserGunFloatingCollisionMaskSolid;

mask_index =
    spriteLaserGunFloatingCollisionMaskSolid;

image_speed = 0;
image_index = 0;

// This exists purely as physical collision.
// The parent gun draws the actual artwork.
visible = false;

enabled = true;
active  = true;

solid_body = true;
solid_only_when_active = false;

// Assigned immediately after creation by
// oFloatingLaserGun.
owner_gun = noone;