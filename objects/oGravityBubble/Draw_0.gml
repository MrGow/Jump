/// oGravityBubble — Draw


// ====================================================
// COOLDOWN
// ====================================================

if (!visible)
{
    exit;
}


// ====================================================
// DRAW POSITION
// ====================================================

var _draw_x =
    x;

var _draw_y =
    y +
    visual_offset_y;


// ====================================================
// BUBBLE
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    _draw_x,
    _draw_y,
    visual_scale_x,
    visual_scale_y,
    0,
    c_white,
    visual_alpha
);


// ====================================================
// DIRECTION SPINNER
//
// Only visible once the player is fully captured.
// ====================================================

if (bubble_state == 2)
{
    draw_sprite_ext(
        spriteBubbleDirectionSpinner,
        0,
        _draw_x,
        _draw_y,
        visual_scale_x,
        visual_scale_y,
        spinner_angle,
        c_white,
        visual_alpha
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(1);

    draw_set_color(
        c_lime
    );

    draw_circle(
        x,
        y,
        capture_radius,
        true
    );


    // ------------------------------------------------
    // LAUNCH DIRECTION
    // ------------------------------------------------

    if (bubble_state == 2)
    {
        var _line_length =
            48;

        draw_set_color(
            c_yellow
        );

        draw_line(
            x,
            y,
            x +
            lengthdir_x(
                _line_length,
                spinner_angle
            ),
            y +
            lengthdir_y(
                _line_length,
                spinner_angle
            )
        );
    }


    // ------------------------------------------------
    // CENTRE
    // ------------------------------------------------

    draw_set_color(
        c_red
    );

    draw_circle(
        x,
        y,
        2,
        false
    );


    draw_set_color(
        c_white
    );

    draw_text(
        x - 32,
        y - 56,
        "STATE: "
        +
        string(bubble_state)
        +
        "\nANGLE: "
        +
        string(
            round(spinner_angle)
        )
    );
}