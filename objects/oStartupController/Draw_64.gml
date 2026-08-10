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
        20,
        29,
        40
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

draw_set_alpha(
    fade_alpha
);

draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);


// ====================================================
// SCREEN 0 — FULL SEND GAMES
// ====================================================

if (startup_screen == 0)
{
    var centre_x =
        gw * 0.5;

    var centre_y =
        gh * 0.5 +
        fsg_logo_y_offset;


    // ------------------------------------------------
    // Advance logo power-up effect
    // ------------------------------------------------

    if (
        fade_state != 2 &&
        fsg_power_timer <
            fsg_power_duration
    )
    {
        fsg_power_timer++;
    }


    // ------------------------------------------------
    // Optional power-on sound
    // ------------------------------------------------

    if (
        !fsg_power_sound_played &&
        fade_alpha > 0.08
    )
    {
        fsg_power_sound_played = true;

        if (snd_fsg_power != -1)
        {
            scr_play_sfx(
                snd_fsg_power,
                fsg_power_sound_gain,
                random_range(
                    0.99,
                    1.01
                )
            );
        }
    }


    // ------------------------------------------------
    // Base power-on brightness
    // ------------------------------------------------

    var power_progress =
        clamp(
            fsg_power_timer /
            max(
                1,
                fsg_power_duration
            ),
            0,
            1
        );

    var power_alpha =
        lerp(
            0.28,
            1.0,
            power_progress
        );


    // ------------------------------------------------
    // Flicker windows
    //
    // Very short interruptions make it feel like an
    // industrial display powering into a stable state.
    // ------------------------------------------------

    if (
        fsg_power_timer >= 8 &&
        fsg_power_timer <= 10
    )
    {
        power_alpha = 0.18;
    }

    if (
        fsg_power_timer >= 15 &&
        fsg_power_timer <= 17
    )
    {
        power_alpha = 0.85;
    }

    if (
        fsg_power_timer >= 20 &&
        fsg_power_timer <= 22
    )
    {
        power_alpha = 0.12;
    }

    if (
        fsg_power_timer >= 28 &&
        fsg_power_timer <= 30
    )
    {
        power_alpha = 0.72;
    }

    if (
        fsg_power_timer >= 34 &&
        fsg_power_timer <= 36
    )
    {
        power_alpha = 0.30;
    }

    if (fsg_power_timer >= 39)
    {
        power_alpha = 1;
    }


    // ------------------------------------------------
    // Tiny final mechanical jolt
    // ------------------------------------------------

    var logo_jolt_x = 0;
    var logo_jolt_y = 0;

    if (
        fsg_power_timer >= 38 &&
        fsg_power_timer <= 39
    )
    {
        logo_jolt_x = 1;
        logo_jolt_y = -1;
    }
    else if (
        fsg_power_timer == 40
    )
    {
        logo_jolt_x = -1;
        logo_jolt_y = 1;
    }


    // ------------------------------------------------
    // Full Send Games logo
    // ------------------------------------------------

    if (fsg_logo_sprite != -1)
    {
        var logo_width =
            sprite_get_width(
                fsg_logo_sprite
            );

        var logo_scale = 1;

        if (logo_width > 0)
        {
            logo_scale =
                min(
                    1,
                    fsg_logo_max_width /
                    logo_width
                );
        }


        draw_sprite_ext(
            fsg_logo_sprite,
            0,
            centre_x + logo_jolt_x,
            centre_y + logo_jolt_y,
            logo_scale,
            logo_scale,
            0,
            c_white,
            fade_alpha * power_alpha
        );
    }
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

    draw_set_color(
        c_white
    );

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
            floor(
                save_icon_frame
            ),
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

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_bottom
    );

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