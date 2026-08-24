/// oGunShipMine — Draw


// ====================================================
// EXPLOSION
//
// spriteDeathExplosion uses Bottom Centre origin.
//
// We draw its origin at the stored bottom-centre point
// of the mine so it visually erupts exactly from where
// the mine was sitting.
// ====================================================

if (state == "exploding")
{
    draw_sprite_ext(
        sprite_index,
        image_index,

        round(
            explosion_draw_x
        ),

        round(
            explosion_draw_y
        ),

        image_xscale,
        image_yscale,

        image_angle,

        c_white,
        image_alpha
    );


    exit;
}


// ====================================================
// NORMAL MINE
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,

    round(x),

    round(
        y +
        draw_ground_offset +
        bob_offset
    ),

    image_xscale,
    image_yscale,

    image_angle,

    c_white,
    image_alpha
);