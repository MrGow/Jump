/// oAdministratorTalkScreen — Draw


// ====================================================
// READ CURRENT MODE DIRECTLY
// ====================================================

var mode =
    string_lower(
        string(
            screen_mode
        )
    );


// ====================================================
// DRAW SCREEN BODY
// ====================================================

draw_set_alpha(
    screen_alpha
);

draw_set_color(
    c_white
);


draw_sprite(
    sprite_index,
    image_index,
    round(x),
    round(y)
);


draw_set_alpha(1);


if (!activated)
{
    exit;
}


// ====================================================
// SCREEN BOUNDS
//
// Your sprite origin is Middle Centre.
// ====================================================

var spr_w =
    sprite_get_width(
        sprite_index
    );

var spr_h =
    sprite_get_height(
        sprite_index
    );


var left =
    x -
    spr_w * 0.5;

var top =
    y -
    spr_h * 0.5;


var right =
    left +
    spr_w;

var bottom =
    top +
    spr_h;


// ====================================================
// FONT
// ====================================================

if (
    text_font != -1
)
{
    draw_set_font(
        text_font
    );
}


draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);


// ====================================================
// BOOT LINE
// ====================================================

if (
    screen_state == 1
)
{
    var centre_x =
        round(
            (
                left +
                right
            )
            *
            0.5
        );


    var centre_y =
        round(
            (
                top +
                bottom
            )
            *
            0.5
        );


    var max_half_width =
        (
            spr_w -
            18
        )
        *
        0.5;


    var current_half_width =
        max_half_width *
        boot_line_progress;


    draw_set_color(
        boot_line_colour
    );


    draw_rectangle(
        centre_x -
        current_half_width,

        centre_y,

        centre_x +
        current_half_width,

        centre_y + 1,

        false
    );
}


// ====================================================
// BOOT DATA
// ====================================================

else if (
    screen_state == 2
)
{
    var boot_draw_text =
        string_replace_all(
            boot_data_text,
            "#",
            "\n"
        );


    draw_set_color(
        boot_text_colour
    );

    draw_set_alpha(
        0.85
    );


    draw_text(
        round(
            left +
            text_left_padding
        ),

        round(
            top +
            text_top_padding
        ),

        boot_draw_text
    );


    draw_set_alpha(1);
}


// ====================================================
// TYPEWRITER
// ====================================================

else if (
    mode ==
    "typewriter"
    &&
    (
        screen_state == 4 ||
        screen_state == 5
    )
)
{
    var text_to_draw =
        string_replace_all(
            display_text,
            "#",
            "\n"
        );


    if (
        cursor_visible
    )
    {
        text_to_draw +=
            "█";
    }


    draw_set_color(
        normal_text_colour
    );


    draw_text(
        round(
            left +
            text_left_padding
        ),

        round(
            top +
            text_top_padding
        ),

        text_to_draw
    );
}


// ====================================================
// SCROLL TICKER
// ====================================================

else if (
    mode ==
    "scroll"
    &&
    screen_state == 4
)
{
    draw_set_color(
        warning_text_colour
    );


    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_middle
    );


    var spacing =
        max(
            8,
            scroll_spacing
        );


    var ticker_y =
        round(
            (
                top +
                bottom
            )
            *
            0.5
        );


    // ------------------------------------------------
    // Begin one STOP before the panel.
    //
    // scroll_x changes every Step.
    // ------------------------------------------------

    var first_x =
        left +
        scroll_x -
        spacing;


    // ------------------------------------------------
    // Draw repeated copies:
    //
    // STOP   STOP   STOP   STOP   STOP
    // ------------------------------------------------

    for (
        var i = 0;
        i < 8;
        i++
    )
    {
        var tx =
            first_x +
            (
                i *
                spacing
            );


        draw_text(
            round(tx),
            ticker_y,
            message
        );
    }
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_font(-1);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);

draw_set_alpha(1);

draw_set_color(
    c_white
);