/// oArea1ElevatorPlatform — Draw


// ====================================================
// DRAW PLATFORM
//
// Visual shake only.
// Collision position remains at actual x/y.
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,

    round(
        x +
        visual_shake_x
    ),

    round(
        y +
        visual_shake_y
    ),

    image_xscale,
    image_yscale,
    image_angle,
    image_blend,
    image_alpha
);


// ====================================================
// DEBUG STANDING SURFACE
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.35);

    draw_set_color(c_lime);


    draw_line(
        bbox_left +
        surface_inset_left,

        surface_y,

        bbox_right -
        surface_inset_right,

        surface_y
    );


    draw_set_alpha(1);

    draw_set_color(c_white);
}