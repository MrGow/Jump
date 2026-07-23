/// oGunShipMine — Draw

if (state != "exploding")
{
    draw_sprite_ext(
        sprite_index,
        image_index,
        round(x),
        round(
            y +
            draw_offset_y
        ),
        image_xscale,
        image_yscale,
        image_angle,
        c_white,
        image_alpha
    );
}