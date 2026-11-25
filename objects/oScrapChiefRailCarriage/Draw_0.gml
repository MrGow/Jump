/// oScrapChiefRailCarriage — Draw

if (!visible)
{
    exit;
}


// ====================================================
// DRAW CARRIAGE
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,

    round(x),
    round(y),

    image_xscale,
    image_yscale,

    0,

    image_blend,
    image_alpha
);


// ====================================================
// DEBUG ATTACHMENT POINT
// ====================================================

if (debug_draw)
{
    draw_set_color(c_lime);

    draw_circle(
        attachment_x,
        attachment_y,
        3,
        false
    );

    draw_set_color(c_yellow);

    draw_text(
        x,
        y + sprite_height + 8,
        "Carriage " + string(carriage_id)
    );

    draw_set_color(c_white);
}