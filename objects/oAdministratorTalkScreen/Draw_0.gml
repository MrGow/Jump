/// oAdministratorTalkScreen — Draw


// ====================================================
// READ CURRENT MODE
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
// Sprite origin = Middle Centre
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

if (text_font != -1)
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

if (screen_state == 1)
{
    var centre_x =
        round(
            (
                left +
                right
            )
            * 0.5
        );

    var centre_y =
        round(
            (
                top +
                bottom
            )
            * 0.5
        );

    var max_half_width =
        (
            spr_w -
            18
        )
        * 0.5;

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

else if (screen_state == 2)
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
    mode == "typewriter"
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


    if (cursor_visible)
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
//
// Draw the moving text to a small surface the same
// size as the black panel.
//
// Anything outside that surface is automatically
// clipped.
// ====================================================

else if (
    mode == "scroll"
    &&
    screen_state == 4
)
{
    // ------------------------------------------------
    // INNER DISPLAY AREA
    //
    // A small inset stops STOP touching the exact
    // edges of the monitor.
    // ------------------------------------------------

    var clip_margin_x = 4;
    var clip_margin_y = 4;

    var clip_w =
        max(
            1,
            floor(
                spr_w -
                clip_margin_x * 2
            )
        );

    var clip_h =
        max(
            1,
            floor(
                spr_h -
                clip_margin_y * 2
            )
        );


    // ------------------------------------------------
    // CREATE / RECREATE SURFACE
    // ------------------------------------------------

    if (!surface_exists(scroll_surface))
    {
        scroll_surface =
            surface_create(
                clip_w,
                clip_h
            );
    }
    else if (
        surface_get_width(scroll_surface) != clip_w ||
        surface_get_height(scroll_surface) != clip_h
    )
    {
        surface_free(
            scroll_surface
        );

        scroll_surface =
            surface_create(
                clip_w,
                clip_h
            );
    }


    // ------------------------------------------------
    // DRAW TICKER INSIDE SURFACE
    // ------------------------------------------------

    if (surface_exists(scroll_surface))
    {
        surface_set_target(
            scroll_surface
        );

        draw_clear_alpha(
            c_black,
            0
        );


        if (text_font != -1)
        {
            draw_set_font(
                text_font
            );
        }


        draw_set_color(
            warning_text_colour
        );

        draw_set_alpha(1);

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


        // --------------------------------------------
        // IMPORTANT
        //
        // We use the SAME scroll_x controlled by your
        // working Step event.
        // --------------------------------------------

        var first_x =
            scroll_x -
            spacing;


        var ticker_y =
            clip_h * 0.5;


        // Draw enough copies to cover the panel.
        for (
            var i = 0;
            i < 12;
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
                round(ticker_y),
                message
            );
        }


        surface_reset_target();


        // ------------------------------------------------
        // DRAW CLIPPED RESULT ONTO MONITOR
        // ------------------------------------------------

        draw_surface(
            scroll_surface,

            round(
                left +
                clip_margin_x
            ),

            round(
                top +
                clip_margin_y
            )
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