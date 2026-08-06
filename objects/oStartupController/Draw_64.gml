/// oStartupController — Draw GUI

var gw =
    display_get_gui_width();

var gh =
    display_get_gui_height();


// ====================================================
// BACKGROUND
// ====================================================

draw_set_alpha(1);

draw_set_color(
    make_color_rgb(
        8,
        12,
        20
    )
);

draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);


// ====================================================
// CONTENT ALPHA
// ====================================================

draw_set_alpha(fade_alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// ====================================================
// SCREEN 0 — FULL SEND GAMES
// ====================================================

if (startup_screen == 0)
{
    var centre_x =
        gw * 0.5;

    var centre_y =
        gh * 0.5;

    // Temporary FSG mark
    if (font_logo_large != -1)
    {
        draw_set_font(
            font_logo_large
        );
    }

    draw_set_color(c_white);

    draw_text(
        centre_x,
        centre_y - 34,
        "FSG"
    );

    // Company name
    if (font_logo_small != -1)
    {
        draw_set_font(
            font_logo_small
        );
    }

    draw_set_color(
        make_color_rgb(
            190,
            210,
            225
        )
    );

    draw_text(
        centre_x,
        centre_y + 34,
        "FULL SEND GAMES"
    );
}


// ====================================================
// SCREEN 1 — SAVE WARNING
// ====================================================

else if (startup_screen == 1)
{
    var centre_x =
        gw * 0.5;


    // ------------------------------------------------
    // Title
    // ------------------------------------------------

    if (font_warning_title != -1)
    {
        draw_set_font(
            font_warning_title
        );
    }

    draw_set_color(c_white);

    draw_text(
        centre_x,
        88,
        "SAVING"
    );


    // ------------------------------------------------
    // Animated save icon
    // ------------------------------------------------

    if (save_icon_sprite != -1)
    {
        var icon_x =
            centre_x;

        var icon_y =
            150;

        draw_sprite_ext(
            save_icon_sprite,
            floor(save_icon_frame),
            icon_x,
            icon_y,
            save_icon_scale,
            save_icon_scale,
            0,
            c_white,
            fade_alpha
        );
    }


    // ------------------------------------------------
    // Warning text
    // ------------------------------------------------

    if (font_warning_body != -1)
    {
        draw_set_font(
            font_warning_body
        );
    }

    draw_set_color(
        make_color_rgb(
            205,
            215,
            225
        )
    );

    draw_text(
        centre_x,
        245,
        "WHEN THIS ICON APPEARS IN THE BOTTOM-RIGHT,\n" +
        "THE GAME IS SAVING.\n\n" +
        "DO NOT CLOSE THE GAME OR TURN OFF YOUR DEVICE."
    );
}


// ====================================================
// SKIP PROMPT
// ====================================================

if (
    startup_screen == 0 ||
    startup_screen == 1
)
{
    if (font_continue != -1)
    {
        draw_set_font(
            font_continue
        );
    }

    draw_set_color(
        make_color_rgb(
            135,
            150,
            165
        )
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_text(
        gw * 0.5,
        gh - 20,
        "SPACE / A TO CONTINUE"
    );
}


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);