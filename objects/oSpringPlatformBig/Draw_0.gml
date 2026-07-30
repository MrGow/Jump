/// oSpringPlatformBig — Draw

draw_self();

if (debug_draw)
{
    // Draw the actual separate solid-mask sprite.
    draw_set_alpha(0.35);

    draw_sprite_ext(
        spriteSpringPlatformBigSolidMask,
        0,
        x + solid_offset_x,
        y + solid_offset_y,
        image_xscale,
        image_yscale,
        image_angle,
        c_lime,
        1
    );

    draw_set_alpha(1);

    // Spring floor surface
    var surf_y = bbox_top + surface_y_offset;

    var surf_l =
        bbox_left +
        top_inset +
        surface_x_offset;

    var surf_r =
        bbox_right -
        top_inset +
        surface_x_offset;

    draw_set_color(c_yellow);
    draw_line(surf_l, surf_y, surf_r, surf_y);

    // Visible spring bbox
    draw_set_color(c_aqua);
    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        true
    );

    draw_set_color(c_white);
}