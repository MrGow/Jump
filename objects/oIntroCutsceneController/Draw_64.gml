/// oIntroCutsceneController — Draw GUI


var gw = 640;
var gh = 360;


// ====================================================
// BACKGROUND
// ====================================================

draw_set_alpha(1);
draw_set_color(c_black);

draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);


// ====================================================
// PHASE 0 — CRT POWER ON
// ====================================================

if (intro_phase == 0)
{
    var p =
        clamp(
            crt_power_progress,
            0,
            1
        );


    if (p < 0.12)
    {
        exit;
    }


    // ------------------------------------------------
    // Horizontal ignition line
    // ------------------------------------------------

    if (p < 0.42)
    {
        var lp =
            (p - 0.12) /
            0.30;


        var line_w =
            lerp(
                4,
                gw - 70,
                lp
            );


        draw_set_alpha(
            0.55 +
            lp * 0.45
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_rectangle(
            gw * 0.5 -
            line_w * 0.5,

            gh * 0.5 - 1,

            gw * 0.5 +
            line_w * 0.5,

            gh * 0.5 + 1,

            false
        );


        // Glow.
        draw_set_alpha(
            0.16
        );


        draw_rectangle(
            gw * 0.5 -
            line_w * 0.5,

            gh * 0.5 - 5,

            gw * 0.5 +
            line_w * 0.5,

            gh * 0.5 + 5,

            false
        );
    }
    else
    {
        // --------------------------------------------
        // Expand vertically
        // --------------------------------------------

        var vp =
            clamp(
                (p - 0.42) /
                0.58,
                0,
                1
            );


        var hh =
            lerp(
                2,
                gh,
                vp
            );


        draw_set_alpha(1);

        draw_set_color(
            terminal_bg
        );


        draw_rectangle(
            0,

            gh * 0.5 -
            hh * 0.5,

            gw,

            gh * 0.5 +
            hh * 0.5,

            false
        );


        draw_set_alpha(
            0.35 *
            (1 - vp)
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_line(
            0,
            gh * 0.5 - hh * 0.5,
            gw,
            gh * 0.5 - hh * 0.5
        );


        draw_line(
            0,
            gh * 0.5 + hh * 0.5,
            gw,
            gh * 0.5 + hh * 0.5
        );
    }


    draw_set_alpha(1);
    draw_set_color(c_white);

    exit;
}


// ====================================================
// PHASE 1 — TERMINAL
// ====================================================

if (intro_phase == 1)
{
    // ------------------------------------------------
    // Background
    // ------------------------------------------------

    draw_set_alpha(1);

    draw_set_color(
        terminal_bg
    );


    draw_rectangle(
        0,
        0,
        gw,
        gh,
        false
    );


    // ------------------------------------------------
    // Font
    // ------------------------------------------------

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );


    // ------------------------------------------------
    // Normal terminal history
    // ------------------------------------------------

    var line_count =
        array_length(
            terminal_visible_lines
        );


    var yy =
        terminal_y;


    for (
        var i = 0;
        i < line_count;
        i++
    )
    {
        var entry =
            terminal_visible_lines[i];


        var txt =
            entry[0];

        var style =
            entry[1];


        switch (style)
        {
            case 1:
                draw_set_color(
                    terminal_green_dim
                );
                break;


            case 2:
                draw_set_color(
                    terminal_green_bright
                );
                break;


            case 3:
                draw_set_color(
                    terminal_warning
                );
                break;


            case 4:
                draw_set_color(
                    terminal_mother
                );
                break;


            case 5:
                draw_set_color(
                    terminal_father
                );
                break;


            case 6:
                draw_set_color(
                    terminal_directive
                );
                break;


            default:
                draw_set_color(
                    terminal_green
                );
                break;
        }


        var line_alpha =
            terminal_flicker;


        // MOTHER CONNECTED gets a subtle cyan pulse.
        if (
            txt ==
            "MOTHER CONNECTED"
        )
        {
            line_alpha =
                clamp(
                    0.72 +
                    sin(mother_pulse) *
                    0.28,
                    0.45,
                    1
                );


            draw_set_color(
                terminal_mother_bright
            );
        }


        draw_set_alpha(
            line_alpha
        );


        draw_text(
            terminal_x,
            yy,
            txt
        );


        yy +=
            terminal_line_height;
    }


    // =================================================
    // SPECIAL — OVERWRITE PROGRESS
    // =================================================

    if (terminal_special_state == 2)
    {
        // Darken lower part very slightly so the active
        // operation separates itself from old log text.
        draw_set_alpha(
            0.28
        );

        draw_set_color(
            c_black
        );


        draw_rectangle(
            18,
            225,
            gw - 18,
            336,
            false
        );


        draw_set_alpha(1);


        // ---------------------------------------------
        // Header
        // ---------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        draw_text(
            28,
            230,
            "MOTHER > DIRECTIVE OVERRIDE"
        );


        // ---------------------------------------------
        // Existing authority
        // ---------------------------------------------

        draw_set_color(
            terminal_green_dim
        );


        draw_text(
            28,
            246,
            "CURRENT ROOT AUTHORITY"
        );


        draw_set_color(
            terminal_father
        );


        draw_text(
            218,
            246,
            "FATHER"
        );


        // ---------------------------------------------
        // Operation
        // ---------------------------------------------

        draw_set_color(
            terminal_green
        );


        draw_text(
            28,
            264,
            "BYPASSING PROTECTION..."
        );


        // ---------------------------------------------
        // Progress bar
        // ---------------------------------------------

        var bar_x = 28;
        var bar_y = 283;

        var bar_w = 360;
        var bar_h = 10;


        draw_set_alpha(1);

        draw_set_color(
            terminal_green_dim
        );


        draw_rectangle(
            bar_x,
            bar_y,
            bar_x + bar_w,
            bar_y + bar_h,
            true
        );


        var fill_w =
            floor(
                (bar_w - 4) *
                overwrite_progress
            );


        if (fill_w > 0)
        {
            draw_set_color(
                terminal_mother
            );


            draw_rectangle(
                bar_x + 2,
                bar_y + 2,

                bar_x + 2 +
                fill_w,

                bar_y +
                bar_h - 2,

                false
            );
        }


        // ---------------------------------------------
        // Percentage
        // ---------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        draw_text(
            bar_x +
            bar_w +
            12,

            bar_y - 1,

            string(
                overwrite_display_progress
            )
            +
            "%"
        );


        // ---------------------------------------------
        // FATHER conflict warning at 58%
        // ---------------------------------------------

        if (overwrite_conflict_shown)
        {
            var conflict_alpha =
                0.75 +
                sin(
                    terminal_time *
                    0.25
                )
                *
                0.25;


            draw_set_alpha(
                conflict_alpha
            );


            draw_set_color(
                terminal_father
            );


            draw_text(
                28,
                306,
                "WARNING: FATHER AUTHORITY CONFLICT"
            );
        }


        // ---------------------------------------------
        // Completion
        // ---------------------------------------------

        if (overwrite_complete)
        {
            draw_set_alpha(1);

            draw_set_color(
                terminal_mother_bright
            );


            draw_text(
                28,
                322,
                "ROOT AUTHORITY REMOVED"
            );
        }
    }


    // =================================================
    // SPECIAL — FINAL DIRECTIVE
    // =================================================

    if (terminal_special_state == 3)
    {
        // Cover most of the previous terminal output.
        // This sudden visual emptiness makes the next
        // information feel much more deliberate.
        draw_set_alpha(
            0.93
        );

        draw_set_color(
            terminal_bg
        );


        draw_rectangle(
            18,
            120,
            gw - 18,
            338,
            false
        );


        draw_set_alpha(1);


        var dx =
            68;

        var dy =
            154;


        // ---------------------------------------------
        // SOURCE
        // ---------------------------------------------

        if (directive_stage >= 1)
        {
            draw_set_color(
                terminal_green_dim
            );


            draw_text(
                dx,
                dy,
                "SOURCE"
            );


            draw_set_color(
                terminal_mother_bright
            );


            draw_text(
                dx + 180,
                dy,
                "MOTHER"
            );
        }


        // ---------------------------------------------
        // TARGET
        // ---------------------------------------------

        if (directive_stage >= 2)
        {
            draw_set_color(
                terminal_green_dim
            );


            draw_text(
                dx,
                dy + 22,
                "TARGET"
            );


            draw_set_color(
                terminal_father
            );


            draw_text(
                dx + 180,
                dy + 22,
                "FATHER"
            );
        }


        // ---------------------------------------------
        // PRIORITY
        // ---------------------------------------------

        if (directive_stage >= 3)
        {
            draw_set_color(
                terminal_green_dim
            );


            draw_text(
                dx,
                dy + 44,
                "PRIORITY"
            );


            draw_set_color(
                terminal_warning
            );


            draw_text(
                dx + 180,
                dy + 44,
                "ABSOLUTE"
            );
        }


        // ---------------------------------------------
        // DIRECTIVE label
        // ---------------------------------------------

        if (directive_stage >= 4)
        {
            draw_set_color(
                terminal_green
            );


            draw_text(
                dx,
                dy + 82,
                "DIRECTIVE:"
            );
        }


        // ---------------------------------------------
        // Blinking suspense cursor
        // ---------------------------------------------

        if (
            directive_stage == 5 &&
            terminal_cursor_visible
        )
        {
            draw_set_color(
                terminal_green_bright
            );


            draw_rectangle(
                dx,
                dy + 106,
                dx + 7,
                dy + 114,
                false
            );
        }


        // ---------------------------------------------
        // KILL FATHER
        // ---------------------------------------------

        if (directive_stage >= 6)
        {
            var kill_pulse =
                0.72 +
                sin(
                    directive_pulse
                )
                *
                0.28;


            draw_set_alpha(
                clamp(
                    kill_pulse,
                    0.50,
                    1
                )
            );


            draw_set_font(
                PIXELOPERATORBOLD18
            );


            draw_set_color(
                terminal_directive
            );


            draw_text(
                dx,
                dy + 104,
                "KILL FATHER"
            );


            draw_set_font(
                PIXELOPERATORREGULAR10
            );


            // Tiny horizontal distortion pulse.
            if (
                sin(
                    directive_pulse
                )
                >
                0.88
            )
            {
                draw_set_alpha(
                    0.10
                );

                draw_set_color(
                    terminal_directive
                );


                draw_rectangle(
                    0,
                    dy + 106,
                    gw,
                    dy + 109,
                    false
                );
            }
        }
    }


    // =================================================
    // NORMAL CURSOR
    // =================================================

    if (
        terminal_special_state == 0 &&
        terminal_cursor_visible &&
        line_count > 0
    )
    {
        draw_set_alpha(
            terminal_flicker
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_rectangle(
            terminal_x,
            yy + 1,
            terminal_x + 6,
            yy + 8,
            false
        );
    }


    // =================================================
    // STATIC PIXELS
    // =================================================

    draw_set_color(
        mother_connected
        ? terminal_mother
        : terminal_green_dim
    );


    var static_count =
        mother_connected
        ? 8
        : 18;


    for (
        var s = 0;
        s < static_count;
        s++
    )
    {
        var sx =
            irandom(
                gw - 1
            );

        var sy =
            irandom(
                gh - 1
            );


        draw_set_alpha(
            random_range(
                0.02,
                0.07
            )
        );


        draw_point(
            sx,
            sy
        );
    }


    // =================================================
    // HORIZONTAL GLITCH
    // =================================================

    if (terminal_glitch_timer > 0)
    {
        draw_set_alpha(
            0.20
        );


        draw_set_color(
            mother_connected
            ? terminal_mother_bright
            : terminal_green_bright
        );


        draw_rectangle(
            max(
                0,
                terminal_glitch_offset
            ),

            terminal_glitch_y,

            min(
                gw,
                gw +
                terminal_glitch_offset
            ),

            terminal_glitch_y +
            terminal_glitch_h,

            false
        );


        draw_set_alpha(
            0.30
        );

        draw_set_color(
            c_black
        );


        draw_rectangle(
            0,

            terminal_glitch_y +
            terminal_glitch_h +
            1,

            gw,

            terminal_glitch_y +
            terminal_glitch_h +
            2,

            false
        );
    }


    // =================================================
    // SCANLINES
    // =================================================

    draw_set_color(
        c_black
    );

    draw_set_alpha(
        0.16
    );


    var scan_offset =
        floor(
            terminal_time *
            0.25
        )
        mod
        3;


    for (
        var sy = scan_offset;
        sy < gh;
        sy += 3
    )
    {
        draw_line(
            0,
            sy,
            gw,
            sy
        );
    }


    // =================================================
    // ROLLING BRIGHTNESS BAND
    // =================================================

    var roll_y =
        (
            terminal_time *
            1.15
        )
        mod
        (gh + 50)
        -
        25;


    draw_set_alpha(
        mother_connected
        ? 0.025
        : 0.035
    );


    draw_set_color(
        mother_connected
        ? terminal_mother_bright
        : terminal_green_bright
    );


    draw_rectangle(
        0,
        roll_y,
        gw,
        roll_y + 22,
        false
    );


    // =================================================
    // CRT EDGE DARKENING
    // =================================================

    draw_set_color(
        c_black
    );


    for (
        var e = 0;
        e < 10;
        e++
    )
    {
        var edge_alpha =
            0.018 +
            e * 0.006;


        draw_set_alpha(
            edge_alpha
        );


        draw_rectangle(
            e,
            e,
            gw - e,
            e + 1,
            false
        );


        draw_rectangle(
            e,
            gh - e - 1,
            gw - e,
            gh - e,
            false
        );


        draw_rectangle(
            e,
            e,
            e + 1,
            gh - e,
            false
        );


        draw_rectangle(
            gw - e - 1,
            e,
            gw - e,
            gh - e,
            false
        );
    }


    // =================================================
    // IMPORTANT-LINE FLASH
    // =================================================

    if (terminal_flash > 0)
    {
        draw_set_alpha(
            terminal_flash *
            0.18
        );


        if (
            terminal_special_state == 3 &&
            directive_stage >= 6
        )
        {
            draw_set_color(
                terminal_directive
            );
        }
        else if (mother_connected)
        {
            draw_set_color(
                terminal_mother_bright
            );
        }
        else
        {
            draw_set_color(
                terminal_green_bright
            );
        }


        draw_rectangle(
            0,
            0,
            gw,
            gh,
            false
        );
    }


    // Reset.
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);

    exit;
}


// ====================================================
// PHASE 2 — CRT SHUTDOWN
// ====================================================

if (intro_phase == 2)
{
    var p =
        clamp(
            shutdown_timer /
            shutdown_duration,
            0,
            1
        );


    // ------------------------------------------------
    // Collapse vertically
    // ------------------------------------------------

    if (p < 0.68)
    {
        var vp =
            p /
            0.68;


        var hh =
            lerp(
                gh,
                2,
                vp
            );


        draw_set_alpha(1);

        draw_set_color(
            terminal_bg
        );


        draw_rectangle(
            0,

            gh * 0.5 -
            hh * 0.5,

            gw,

            gh * 0.5 +
            hh * 0.5,

            false
        );


        draw_set_alpha(
            0.45
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_line(
            0,
            gh * 0.5 - hh * 0.5,
            gw,
            gh * 0.5 - hh * 0.5
        );


        draw_line(
            0,
            gh * 0.5 + hh * 0.5,
            gw,
            gh * 0.5 + hh * 0.5
        );
    }
    else
    {
        // --------------------------------------------
        // Horizontal line shrinks inward
        // --------------------------------------------

        var hp =
            clamp(
                (p - 0.68) /
                0.32,
                0,
                1
            );


        var line_w =
            lerp(
                gw,
                0,
                hp
            );


        draw_set_alpha(
            1 - hp
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_rectangle(
            gw * 0.5 -
            line_w * 0.5,

            gh * 0.5 - 1,

            gw * 0.5 +
            line_w * 0.5,

            gh * 0.5 + 1,

            false
        );


        draw_set_alpha(
            (1 - hp) *
            0.18
        );


        draw_rectangle(
            gw * 0.5 -
            line_w * 0.5,

            gh * 0.5 - 5,

            gw * 0.5 +
            line_w * 0.5,

            gh * 0.5 + 5,

            false
        );
    }


    draw_set_alpha(1);
    draw_set_color(c_white);

    exit;
}


// ====================================================
// PHASE 3 — PLACEHOLDER SLIDES
// ====================================================

if (intro_phase == 3)
{
    // ------------------------------------------------
    // Placeholder image
    // ------------------------------------------------

    var col =
        slide_colours[
            clamp(
                slide_index,
                0,
                slide_count - 1
            )
        ];


    draw_set_alpha(1);

    draw_set_color(
        col
    );


    draw_rectangle(
        0,
        0,
        gw,
        gh,
        false
    );


    // ------------------------------------------------
    // Temporary scene label
    // ------------------------------------------------

    draw_set_font(
        PIXELOPERATORBOLD18
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );

    draw_set_color(
        c_white
    );


    draw_text(
        gw * 0.5,
        gh * 0.5,

        "CUTSCENE IMAGE " +
        string(
            slide_index + 1
        )
    );


    // ------------------------------------------------
    // Cinematic letterbox
    // ------------------------------------------------

    var bar_h = 38;


    draw_set_alpha(1);

    draw_set_color(
        c_black
    );


    draw_rectangle(
        0,
        0,
        gw,
        bar_h,
        false
    );


    draw_rectangle(
        0,
        gh - bar_h,
        gw,
        gh,
        false
    );


    // ------------------------------------------------
    // CONTINUE prompt
    // ------------------------------------------------

    if (
        !slide_changing &&
        slide_input_lock <= 0
    )
    {
        draw_set_font(
            PIXELOPERATORREGULAR10
        );

        draw_set_halign(
            fa_left
        );

        draw_set_valign(
            fa_middle
        );


        var prompt_y =
            gh - 18;

        var prompt_right =
            gw - 18;

        var prompt_gap =
            6;

        var prompt_scale =
            0.75;

        var prompt_text =
            "CONTINUE";


        var prompt_text_w =
            string_width(
                prompt_text
            );

        var icon_slot_w =
            34;


        var prompt_total_w =
            icon_slot_w +
            prompt_gap +
            prompt_text_w;


        var prompt_left =
            prompt_right -
            prompt_total_w;


        draw_set_color(
            make_color_rgb(
                160,
                170,
                175
            )
        );


        if (
            instance_exists(
                oInputPromptController
            )
        )
        {
            var ipc =
                instance_find(
                    oInputPromptController,
                    0
                );


            if (ipc != noone)
            {
                var icon_x =
                    prompt_left +
                    icon_slot_w * 0.5;


                ipc.draw_prompt(
                    "jump",
                    round(icon_x),
                    round(prompt_y),
                    prompt_scale
                );
            }
        }


        draw_set_halign(
            fa_left
        );


        draw_set_color(
            make_color_rgb(
                180,
                185,
                190
            )
        );


        draw_text(
            round(
                prompt_left +
                icon_slot_w +
                prompt_gap
            ),

            round(prompt_y),

            prompt_text
        );
    }


    // ------------------------------------------------
    // Fade between slides
    // ------------------------------------------------

    if (slide_fade > 0)
    {
        draw_set_alpha(
            slide_fade
        );

        draw_set_color(
            c_black
        );


        draw_rectangle(
            0,
            0,
            gw,
            gh,
            false
        );
    }


    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);

    exit;
}


// ====================================================
// PHASE 4 — FINAL BLACK
// ====================================================

draw_set_alpha(1);
draw_set_color(c_black);

draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);


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