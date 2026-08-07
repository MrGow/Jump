/// oLaserGunMultiDirectionSolid — Draw

// Normally draw absolutely nothing.
if (!debug_draw)
{
    exit;
}


// ====================================================
// DEBUG COLLISION SPRITE
// ====================================================

draw_set_alpha(0.40);

draw_sprite_ext(
    spriteLaserGunMultiDirectionCollisionMaskSolid,
    0,
    x,
    y,
    1,
    1,
    0,
    c_lime,
    1
);


// ====================================================
// DEBUG BOUNDING BOX
// ====================================================

draw_set_alpha(1);
draw_set_color(c_lime);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    true
);

draw_set_color(c_white);