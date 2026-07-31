/// oPinballSmacker — Draw

var draw_colour =
    hit_flash > 0
    ? make_color_rgb(
        255,
        245,
        190
    )
    : c_white;

// ----------------------------------------------------
// Draw animated visual sprite
// ----------------------------------------------------
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
// DEBUG COLLISION MASK
// ====================================================

if (debug_draw)
{
    // Draw the exact permanent collision sprite.
    draw_set_alpha(
        clamp(
            debug_mask_alpha,
            0,
            1
        )
    );

    draw_sprite_ext(
        spritePinballSmackerMaskSolid,
        0,
        x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        c_lime,
        1
    );

    draw_set_alpha(1);

    // Draw the resulting mask bounding box.
    draw_set_color(c_red);

    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        true
    );

    // Show physical centre used for radial force.
    var centre_x =
        (
            bbox_left +
            bbox_right
        )
        * 0.5;

    var centre_y =
        (
            bbox_top +
            bbox_bottom
        )
        * 0.5;

    draw_set_color(c_yellow);

    draw_line(
        centre_x - 4,
        centre_y,
        centre_x + 4,
        centre_y
    );

    draw_line(
        centre_x,
        centre_y - 4,
        centre_x,
        centre_y + 4
    );

    draw_set_color(c_white);
}