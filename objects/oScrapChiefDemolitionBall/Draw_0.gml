/// oScrapChiefDemolitionBall — Draw

if (!visible)
{
    exit;
}


// ====================================================
// DRAW DEMOLITION BALL
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,

    round(x),
    round(y),

    1,
    1,
    0,
    c_white,
    1
);


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_color(c_yellow);

    draw_rectangle(
        x,
        y,
        x + ball_width - 1,
        y + ball_height - 1,
        true
    );


    // --------------------------------------------
    // Chain attachment point
    // --------------------------------------------

    draw_set_color(c_lime);

    draw_circle(
        chain_attach_x,
        chain_attach_y,
        3,
        false
    );


    // --------------------------------------------
    // Ball information
    // --------------------------------------------

    draw_set_color(c_white);

    draw_text(
        x,
        y + ball_height + 4,

        "BALL " + string(ball_id)
    );

    draw_text(
        x,
        y + ball_height + 16,

        chain_attached ?
        "ATTACHED" :
        "DETACHED"
    );
}