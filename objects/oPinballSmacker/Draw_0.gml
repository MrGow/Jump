/// oPinballSmacker — Draw

var draw_colour =
    hit_flash > 0
    ? make_color_rgb(
        255,
        245,
        190
    )
    : c_white;

draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    image_xscale,
    image_yscale,
    image_angle,
    draw_colour,
    image_alpha
);


// ====================================================
// DEBUG COLLISION
// ====================================================

if (debug_draw)
{
    var radius =
        min(
            sprite_get_width(sprite_index),
            sprite_get_height(sprite_index)
        )
        *
        collision_radius_scale
        *
        max(
            abs(image_xscale),
            abs(image_yscale)
        );

    draw_set_alpha(0.35);
    draw_set_color(c_red);

    draw_circle(
        x,
        y,
        radius,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}