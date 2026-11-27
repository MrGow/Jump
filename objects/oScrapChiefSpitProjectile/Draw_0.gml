/// oScrapChiefSpitProjectile — Draw

// ====================================================
// DRAW PROJECTILE
//
// Apply the spawn pop visually without modifying
// the object's actual image scale or collision mask.
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    image_xscale * pop_scale,
    image_yscale * pop_scale,
    image_angle,
    image_blend,
    image_alpha
);