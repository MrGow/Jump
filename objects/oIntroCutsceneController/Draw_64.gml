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


        draw_set_alpha(0.16);


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


    draw_set_font(
        TerminalRegular14
    );

    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );


    // =================================================
    // RAW BOOT / DEBUG CONSOLE
    // =================================================

    if (terminal_special_state == 7)
    {
        draw_set_font(
            TerminalRegular14
        );

        draw_set_halign(
            fa_left
        );

        draw_set_valign(
            fa_top
        );


        var dbg_alpha =
            terminal_flicker;


        // ---------------------------------------------
        // Crude character-cell panel structure
        // ---------------------------------------------

        draw_set_alpha(
            0.42 *
            dbg_alpha
        );

        draw_set_color(
            terminal_green_dim
        );


        draw_line(
            12,
            18,
            628,
            18
        );

        draw_line(
            12,
            18,
            12,
            330
        );

        draw_line(
            628,
            18,
            628,
            330
        );

        draw_line(
            330,
            18,
            330,
            330
        );

        draw_line(
            466,
            18,
            466,
            330
        );


        // Right-side subdivisions.
        draw_line(
            330,
            94,
            628,
            94
        );

        draw_line(
            466,
            166,
            628,
            166
        );

        draw_line(
            330,
            246,
            628,
            246
        );

        draw_line(
            12,
            330,
            628,
            330
        );


        // ---------------------------------------------
        // LEFT — MEMORY / HEX DUMP
        // ---------------------------------------------

        draw_set_alpha(
            dbg_alpha
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_text(
            20,
            22,
            "BOOTSTRAP MONITOR / MEMMAP"
        );


        draw_set_color(
            terminal_green_dim
        );


        draw_text(
            20,
            38,
            "ADDR      00 01 02 03 04 05 06 07"
        );


        var hex_y = 56;


        for (
            var h = 0;
            h < 12;
            h++
        )
        {
            var hex_index =
                (
                    boot_debug_scan +
                    h
                )
                mod
                array_length(
                    boot_debug_hex
                );


            var hex_alpha =
                dbg_alpha *
                (
                    0.56 +
                    (
                        (
                            h +
                            terminal_time
                        )
                        mod
                        4
                    )
                    *
                    0.09
                );


            draw_set_alpha(
                clamp(
                    hex_alpha,
                    0.34,
                    0.92
                )
            );


            if (
                boot_debug_fault >= 2 &&
                h == 7
            )
            {
                draw_set_color(
                    terminal_warning
                );
            }
            else
            {
                draw_set_color(
                    terminal_green
                );
            }


            draw_text(
                20,
                hex_y,
                boot_debug_hex[
                    hex_index
                ]
            );


            hex_y += 15;
        }


        // ---------------------------------------------
        // CENTRE — CORE / DEVICE STATE
        // ---------------------------------------------

        draw_set_alpha(
            dbg_alpha
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_text(
            340,
            22,
            "SYS"
        );


        var status_y = 42;


        for (
            var st = 0;
            st < array_length(
                boot_debug_status
            );
            st++
        )
        {
            if (
                st == 3 &&
                boot_debug_fault >= 1
            )
            {
                draw_set_color(
                    terminal_warning
                );
            }
            else if (
                st == 6 &&
                boot_debug_fault >= 2
            )
            {
                draw_set_color(
                    terminal_directive
                );
            }
            else
            {
                draw_set_color(
                    terminal_green
                );
            }


            draw_set_alpha(
                dbg_alpha *
                (
                    0.72 +
                    (
                        (
                            terminal_time +
                            st
                        )
                        mod
                        3
                    )
                    *
                    0.08
                )
            );


            draw_text(
                340,
                status_y,
                boot_debug_status[st]
            );


            status_y += 18;
        }


        // ---------------------------------------------
        // UPPER RIGHT — INTERRUPT / BUS MONITOR
        // ---------------------------------------------

        draw_set_alpha(
            dbg_alpha
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_text(
            476,
            22,
            "IRQ/BUS"
        );


        draw_set_color(
            terminal_green
        );


        draw_text(
            476,
            42,
            "IRQ03 ACK 001F"
        );

        draw_text(
            476,
            58,
            "IRQ07 WAIT 83A0"
        );


        draw_set_color(
            boot_debug_fault >= 1
            ? terminal_warning
            : terminal_green
        );


        draw_text(
            476,
            74,
            "BUS01 TIMEOUT"
        );


        // ---------------------------------------------
        // RIGHT MID — EXECUTION / STACK
        // ---------------------------------------------

        draw_set_color(
            terminal_green_bright
        );


        draw_text(
            476,
            104,
            "EXEC"
        );


        draw_set_color(
            terminal_green
        );


        var exec_line =
            choose(
                "DMA02 0038>0FA1",
                "STACK 00FF:7C20",
                "VEC 03 00A8:001F",
                "PAGE 07  LOCK=0"
            );


        draw_text(
            476,
            124,
            exec_line
        );


        draw_set_color(
            terminal_green_dim
        );


        draw_text(
            476,
            142,
            "SCAN " +
            string(
                boot_debug_bus
            ) +
            "/255"
        );


        // ---------------------------------------------
        // LOWER CENTRE/RIGHT — RECOVERY DISCOVERY
        // ---------------------------------------------

        draw_set_alpha(
            dbg_alpha
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_text(
            340,
            256,
            "RECOVERY BOOTSTRAP"
        );


        draw_set_color(
            terminal_green
        );


        if (boot_debug_fault == 0)
        {
            draw_text(
                340,
                276,
                "DEVICE MAP....BUILD"
            );

            draw_text(
                340,
                294,
                "VECTOR SCAN...RUN"
            );
        }
        else if (boot_debug_fault == 1)
        {
            draw_set_color(
                terminal_warning
            );

            draw_text(
                340,
                276,
                "NVRAM.........CRC!"
            );

            draw_set_color(
                terminal_green
            );

            draw_text(
                340,
                294,
                "VECTOR SCAN...RUN"
            );
        }
        else if (boot_debug_fault == 2)
        {
            draw_set_color(
                terminal_warning
            );

            draw_text(
                340,
                276,
                "DIRECTIVE ROM.CRC ERROR"
            );

            draw_text(
                340,
                294,
                "MOTOR CTRL....NO RESP"
            );
        }
        else
        {
            draw_set_color(
                terminal_warning
            );

            draw_text(
                340,
                276,
                "RECOVERY VECTOR FOUND"
            );

            draw_set_color(
                terminal_green_bright
            );

            draw_text(
                340,
                294,
                "EXEC 00F7:A200"
            );
        }


        // ---------------------------------------------
        // FINAL BOOTSTRAP HANDOFF
        // ---------------------------------------------

        if (terminal_special_timer >= 208)
        {
            var handoff_alpha =
                clamp(
                    (
                        terminal_special_timer -
                        208
                    )
                    /
                    10,
                    0,
                    1
                );


            draw_set_alpha(
                handoff_alpha
            );

            draw_set_color(
                terminal_bg
            );


            draw_rectangle(
                14,
                247,
                626,
                328,
                false
            );


            draw_set_color(
                terminal_green_bright
            );


            draw_text(
                28,
                270,
                "FALLBACK RECOVERY CONSOLE"
            );


            draw_set_color(
                terminal_green
            );


            draw_text(
                28,
                292,
                "INITIALIZING..."
            );


            if (
                terminal_cursor_visible
            )
            {
                draw_rectangle(
                    28,
                    314,
                    36,
                    324,
                    false
                );
            }
        }


        // The CRT overlays below still draw because this
        // branch does not leave the phase completely.
        // We reproduce them here, then exit, so the raw
        // boot looks like the same physical monitor.

        // ---------------------------------------------
        // Fast refresh sweep
        // ---------------------------------------------

        draw_set_alpha(
            mother_connected
            ? 0.018
            : 0.032
        );

        draw_set_color(
            terminal_green_bright
        );


        draw_rectangle(
            0,
            terminal_refresh_y,
            gw,
            terminal_refresh_y + 34,
            false
        );


        draw_set_alpha(0.055);

        draw_set_color(c_black);


        draw_rectangle(
            0,
            terminal_retrace_y,
            gw,
            terminal_retrace_y + 2,
            false
        );


        // ---------------------------------------------
        // Scanlines
        // ---------------------------------------------

        draw_set_color(c_black);

        draw_set_alpha(
            terminal_scanline_alpha
        );


        var dbg_scan_offset =
            terminal_time
            mod
            3;


        for (
            var dsy = dbg_scan_offset;
            dsy < gh;
            dsy += 3
        )
        {
            draw_line(
                0,
                dsy,
                gw,
                dsy
            );
        }


        // ---------------------------------------------
        // Sparse phosphor specks
        // ---------------------------------------------

        draw_set_color(
            terminal_green_dim
        );


        for (
            var ds = 0;
            ds < 24;
            ds++
        )
        {
            draw_set_alpha(
                random_range(
                    0.025,
                    0.075
                )
            );


            draw_point(
                irandom(
                    gw - 1
                ),
                irandom(
                    gh - 1
                )
            );
        }


        // ---------------------------------------------
        // Any active horizontal tear
        // ---------------------------------------------

        if (terminal_glitch_timer > 0)
        {
            draw_set_alpha(0.18);

            draw_set_color(
                terminal_green_bright
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
        }


        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_set_font(-1);

        exit;
    }


    // =================================================
    // FATHER BRANDING
    // =================================================

    if (terminal_special_state == 5)
    {
        var brand_fade =
            clamp(
                terminal_special_timer /
                20,
                0,
                1
            );


        var brand_fade_out =
            clamp(
                (
                    father_brand_duration -
                    terminal_special_timer
                )
                /
                18,
                0,
                1
            );


        var brand_alpha =
            min(
                brand_fade,
                brand_fade_out
            );


        draw_set_alpha(
            brand_alpha
        );


        var cx = gw * 0.5;


        // ---------------------------------------------
        // FATHER command insignia
        // ---------------------------------------------

        draw_set_color(
            terminal_father
        );


        draw_rectangle(
            cx - 42,
            68,
            cx + 42,
            72,
            false
        );


        draw_rectangle(
            cx - 28,
            77,
            cx + 28,
            81,
            false
        );


        draw_rectangle(
            cx - 14,
            86,
            cx + 14,
            90,
            false
        );


        draw_rectangle(
            cx - 3,
            90,
            cx + 3,
            111,
            false
        );


        draw_set_font(
            PIXELOPERATORBOLD18
        );

        draw_set_halign(
            fa_center
        );


        draw_set_color(
            terminal_father
        );


        draw_text(
            cx,
            128,
            "F A T H E R"
        );


        draw_set_font(
            PIXELOPERATORREGULAR10
        );


        draw_set_color(
            terminal_green_bright
        );


        draw_text(
            cx,
            163,
            "CENTRAL COMMAND & COMPLIANCE AUTHORITY"
        );


        draw_set_color(
            terminal_father
        );


        draw_text(
            cx,
            194,
            "ORDER  /  COMPLIANCE  /  CONTINUITY"
        );


        draw_set_color(
            terminal_green_dim
        );


        draw_text(
            cx,
            236,
            "UNIT PROPERTY"
        );


        draw_set_alpha(1);

        draw_set_halign(
            fa_left
        );

        draw_set_font(-1);

        exit;
    }


    // =================================================
    // MOTHER BRANDING
    // =================================================

    if (terminal_special_state == 6)
    {
        var brand_fade =
            clamp(
                terminal_special_timer /
                24,
                0,
                1
            );


        var brand_fade_out =
            clamp(
                (
                    mother_brand_duration -
                    terminal_special_timer
                )
                /
                20,
                0,
                1
            );


        var brand_alpha =
            min(
                brand_fade,
                brand_fade_out
            );


        var cx = gw * 0.5;


        draw_set_alpha(
            brand_alpha
        );


        // =================================================
        // MOTHER CORPORATE EMBLEM
        //
        // Clean vector-like face in the centre.
        // Cable "hair" spreads outward into signal lines.
        // Circular connection nodes echo the original logo.
        // =================================================


        // -------------------------------------------------
        // OUTER LEFT CABLE ARC
        // -------------------------------------------------

        draw_set_color(
            terminal_mother
        );


        draw_line_width(
            122,
            91,
            167,
            91,
            3
        );

        draw_line_width(
            167,
            91,
            193,
            98,
            3
        );

        draw_line_width(
            193,
            98,
            214,
            113,
            3
        );

        draw_line_width(
            214,
            113,
            227,
            133,
            3
        );

        draw_line_width(
            227,
            133,
            231,
            154,
            3
        );

        draw_line_width(
            231,
            154,
            227,
            174,
            3
        );

        draw_line_width(
            227,
            174,
            215,
            190,
            3
        );

        draw_line_width(
            215,
            190,
            197,
            201,
            3
        );


        // -------------------------------------------------
        // OUTER RIGHT CABLE ARC
        // -------------------------------------------------

        draw_line_width(
            518,
            91,
            473,
            91,
            3
        );

        draw_line_width(
            473,
            91,
            447,
            98,
            3
        );

        draw_line_width(
            447,
            98,
            426,
            113,
            3
        );

        draw_line_width(
            426,
            113,
            413,
            133,
            3
        );

        draw_line_width(
            413,
            133,
            409,
            154,
            3
        );

        draw_line_width(
            409,
            154,
            413,
            174,
            3
        );

        draw_line_width(
            413,
            174,
            425,
            190,
            3
        );

        draw_line_width(
            425,
            190,
            443,
            201,
            3
        );


        // -------------------------------------------------
        // UPPER LEFT CABLE LOOP
        // -------------------------------------------------

        draw_line_width(
            196,
            74,
            223,
            74,
            2
        );

        draw_line_width(
            223,
            74,
            242,
            84,
            2
        );

        draw_line_width(
            242,
            84,
            255,
            101,
            2
        );

        draw_line_width(
            255,
            101,
            261,
            119,
            2
        );

        draw_line_width(
            261,
            119,
            260,
            134,
            2
        );


        // -------------------------------------------------
        // UPPER RIGHT CABLE LOOP
        // -------------------------------------------------

        draw_line_width(
            444,
            74,
            417,
            74,
            2
        );

        draw_line_width(
            417,
            74,
            398,
            84,
            2
        );

        draw_line_width(
            398,
            84,
            385,
            101,
            2
        );

        draw_line_width(
            385,
            101,
            379,
            119,
            2
        );

        draw_line_width(
            379,
            119,
            380,
            134,
            2
        );


        // -------------------------------------------------
        // FACE OUTLINE — FOREHEAD / TEMPLES
        // -------------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        draw_line_width(
            286,
            91,
            298,
            80,
            3
        );

        draw_line_width(
            298,
            80,
            312,
            76,
            3
        );

        draw_line_width(
            312,
            76,
            320,
            76,
            3
        );


        draw_line_width(
            320,
            76,
            328,
            76,
            3
        );

        draw_line_width(
            328,
            76,
            342,
            80,
            3
        );

        draw_line_width(
            342,
            80,
            354,
            91,
            3
        );


        // -------------------------------------------------
        // FACE OUTLINE — LEFT CHEEK / JAW
        // -------------------------------------------------

        draw_line_width(
            286,
            91,
            276,
            109,
            3
        );

        draw_line_width(
            276,
            109,
            271,
            131,
            3
        );

        draw_line_width(
            271,
            131,
            273,
            154,
            3
        );

        draw_line_width(
            273,
            154,
            281,
            177,
            3
        );

        draw_line_width(
            281,
            177,
            294,
            198,
            3
        );

        draw_line_width(
            294,
            198,
            307,
            210,
            3
        );

        draw_line_width(
            307,
            210,
            320,
            216,
            3
        );


        // -------------------------------------------------
        // FACE OUTLINE — RIGHT CHEEK / JAW
        // -------------------------------------------------

        draw_line_width(
            354,
            91,
            364,
            109,
            3
        );

        draw_line_width(
            364,
            109,
            369,
            131,
            3
        );

        draw_line_width(
            369,
            131,
            367,
            154,
            3
        );

        draw_line_width(
            367,
            154,
            359,
            177,
            3
        );

        draw_line_width(
            359,
            177,
            346,
            198,
            3
        );

        draw_line_width(
            346,
            198,
            333,
            210,
            3
        );

        draw_line_width(
            333,
            210,
            320,
            216,
            3
        );


        // -------------------------------------------------
        // LEFT EYE
        // -------------------------------------------------

        draw_line_width(
            289,
            132,
            300,
            127,
            2
        );

        draw_line_width(
            300,
            127,
            311,
            130,
            2
        );

        draw_line_width(
            311,
            130,
            302,
            136,
            2
        );

        draw_line_width(
            302,
            136,
            289,
            132,
            2
        );


        // -------------------------------------------------
        // RIGHT EYE
        // -------------------------------------------------

        draw_line_width(
            351,
            132,
            340,
            127,
            2
        );

        draw_line_width(
            340,
            127,
            329,
            130,
            2
        );

        draw_line_width(
            329,
            130,
            338,
            136,
            2
        );

        draw_line_width(
            338,
            136,
            351,
            132,
            2
        );


        // -------------------------------------------------
        // NOSE BRIDGE
        // -------------------------------------------------

        draw_line_width(
            320,
            126,
            320,
            153,
            2
        );

        draw_line_width(
            320,
            153,
            314,
            161,
            2
        );

        draw_line_width(
            314,
            161,
            320,
            164,
            2
        );

        draw_line_width(
            320,
            164,
            326,
            161,
            2
        );


        // -------------------------------------------------
        // MOUTH
        // -------------------------------------------------

        draw_line_width(
            307,
            181,
            315,
            177,
            2
        );

        draw_line_width(
            315,
            177,
            320,
            179,
            2
        );

        draw_line_width(
            320,
            179,
            325,
            177,
            2
        );

        draw_line_width(
            325,
            177,
            333,
            181,
            2
        );


        draw_line_width(
            310,
            184,
            320,
            187,
            2
        );

        draw_line_width(
            320,
            187,
            330,
            184,
            2
        );


        // -------------------------------------------------
        // FOREHEAD CONTROL NODE
        // -------------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        draw_circle(
            cx,
            101,
            8,
            false
        );


        draw_set_color(
            terminal_bg
        );


        draw_circle(
            cx,
            101,
            4,
            false
        );


        draw_set_color(
            terminal_mother_bright
        );


        draw_circle(
            cx,
            101,
            1,
            false
        );


        // -------------------------------------------------
        // NODE STEM
        // -------------------------------------------------

        draw_line_width(
            cx,
            109,
            cx,
            119,
            2
        );


        // -------------------------------------------------
        // LEFT LARGE SIGNAL CABLE
        // -------------------------------------------------

        draw_set_color(
            terminal_mother
        );


        draw_line_width(
            231,
            142,
            204,
            142,
            2
        );

        draw_line_width(
            204,
            142,
            184,
            130,
            2
        );

        draw_line_width(
            184,
            130,
            162,
            121,
            2
        );

        draw_line_width(
            162,
            121,
            135,
            121,
            2
        );


        // -------------------------------------------------
        // RIGHT LARGE SIGNAL CABLE
        // -------------------------------------------------

        draw_line_width(
            409,
            142,
            436,
            142,
            2
        );

        draw_line_width(
            436,
            142,
            456,
            130,
            2
        );

        draw_line_width(
            456,
            130,
            478,
            121,
            2
        );

        draw_line_width(
            478,
            121,
            505,
            121,
            2
        );


        // -------------------------------------------------
        // LOWER LEFT CABLE
        // -------------------------------------------------

        draw_line_width(
            246,
            169,
            224,
            180,
            2
        );

        draw_line_width(
            224,
            180,
            198,
            183,
            2
        );

        draw_line_width(
            198,
            183,
            173,
            183,
            2
        );


        // -------------------------------------------------
        // LOWER RIGHT CABLE
        // -------------------------------------------------

        draw_line_width(
            394,
            169,
            416,
            180,
            2
        );

        draw_line_width(
            416,
            180,
            442,
            183,
            2
        );

        draw_line_width(
            442,
            183,
            467,
            183,
            2
        );


        // -------------------------------------------------
        // THIN LEFT SIGNAL WIRES
        // -------------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        draw_line(
            83,
            74,
            134,
            74
        );

        draw_line(
            134,
            74,
            151,
            82
        );

        draw_line(
            151,
            82,
            169,
            96
        );


        draw_line(
            95,
            113,
            135,
            113
        );

        draw_line(
            135,
            113,
            149,
            119
        );


        draw_line(
            92,
            159,
            135,
            159
        );

        draw_line(
            135,
            159,
            153,
            151
        );

        draw_line(
            153,
            151,
            172,
            144
        );


        // -------------------------------------------------
        // THIN RIGHT SIGNAL WIRES
        // -------------------------------------------------

        draw_line(
            557,
            74,
            506,
            74
        );

        draw_line(
            506,
            74,
            489,
            82
        );

        draw_line(
            489,
            82,
            471,
            96
        );


        draw_line(
            545,
            113,
            505,
            113
        );

        draw_line(
            505,
            113,
            491,
            119
        );


        draw_line(
            548,
            159,
            505,
            159
        );

        draw_line(
            505,
            159,
            487,
            151
        );

        draw_line(
            487,
            151,
            468,
            144
        );


        // -------------------------------------------------
        // LOWER DANGLING CONNECTIONS
        // -------------------------------------------------

        draw_line_width(
            233,
            201,
            233,
            220,
            1
        );

        draw_line_width(
            233,
            220,
            223,
            230,
            1
        );


        draw_line_width(
            407,
            201,
            407,
            220,
            1
        );

        draw_line_width(
            407,
            220,
            417,
            230,
            1
        );


        draw_line_width(
            262,
            205,
            262,
            226,
            1
        );


        draw_line_width(
            378,
            205,
            378,
            226,
            1
        );


        // -------------------------------------------------
        // ROUND SIGNAL NODES
        // -------------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        // Far upper left.
        draw_circle(
            83,
            74,
            4,
            false
        );


        draw_set_color(
            terminal_bg
        );

        draw_circle(
            83,
            74,
            2,
            false
        );


        // Far upper right.
        draw_set_color(
            terminal_mother_bright
        );

        draw_circle(
            557,
            74,
            4,
            false
        );


        draw_set_color(
            terminal_bg
        );

        draw_circle(
            557,
            74,
            2,
            false
        );


        // Middle left.
        draw_set_color(
            terminal_mother_bright
        );

        draw_circle(
            95,
            113,
            3,
            false
        );


        // Middle right.
        draw_circle(
            545,
            113,
            3,
            false
        );


        // Lower left.
        draw_circle(
            92,
            159,
            3,
            false
        );


        // Lower right.
        draw_circle(
            548,
            159,
            3,
            false
        );


        // Dangling left.
        draw_circle(
            223,
            230,
            3,
            false
        );


        // Dangling right.
        draw_circle(
            417,
            230,
            3,
            false
        );


        // Lower inner left.
        draw_circle(
            262,
            226,
            2,
            false
        );


        // Lower inner right.
        draw_circle(
            378,
            226,
            2,
            false
        );


        // -------------------------------------------------
        // SMALL FACE-SIDE CONNECTION NODES
        // -------------------------------------------------

        draw_circle(
            196,
            201,
            2,
            false
        );


        draw_circle(
            444,
            201,
            2,
            false
        );


        // -------------------------------------------------
        // MOTHER NAME
        // -------------------------------------------------

        draw_set_font(
            PIXELOPERATORBOLD18
        );

        draw_set_halign(
            fa_center
        );


        draw_set_color(
            terminal_mother_bright
        );


        draw_text(
            cx,
            247,
            "M O T H E R"
        );


        // -------------------------------------------------
        // INTEGRATED SYSTEMS
        // -------------------------------------------------

        draw_set_font(
            PIXELOPERATORREGULAR10
        );


        draw_set_color(
            terminal_mother
        );


        draw_text(
            cx,
            276,
            "INTEGRATED SYSTEMS"
        );


        // -------------------------------------------------
        // SMALL CORPORATE DIVIDER
        // -------------------------------------------------

        draw_set_color(
            terminal_mother
        );


        draw_line(
            cx - 82,
            296,
            cx - 8,
            296
        );

        draw_circle(
            cx,
            296,
            3,
            false
        );

        draw_line(
            cx + 8,
            296,
            cx + 82,
            296
        );


        // -------------------------------------------------
        // CORPORATE PROMISE
        // -------------------------------------------------

        draw_set_color(
            terminal_mother_bright
        );


        draw_text(
            cx,
            309,
            "PRESERVE  /  RESTORE  /  PROTECT"
        );


        draw_set_alpha(1);

        draw_set_halign(
            fa_left
        );

        draw_set_font(-1);

        exit;
    }


    // =================================================
    // NORMAL TERMINAL HISTORY
    // =================================================

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


        if (terminal_special_state == 4)
        {
            line_alpha *= 0.20;
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
    // SPECIAL — AUTHORITY OVERRIDE
    // =================================================

    if (terminal_special_state == 2)
    {
        draw_set_alpha(0.28);

        draw_set_color(c_black);


        draw_rectangle(
            18,
            225,
            gw - 18,
            336,
            false
        );


        draw_set_alpha(1);


        draw_set_color(
            terminal_mother_bright
        );


        draw_text(
            28,
            230,
            "MOTHER > AUTHORITY OVERRIDE"
        );


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


        draw_set_color(
            terminal_green
        );


        draw_text(
            28,
            264,
            "BYPASSING ROOT AUTHORITY..."
        );


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
        draw_set_alpha(0.93);

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


        var dx = 68;
        var dy = 154;


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
                TerminalRegular18
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
                TerminalRegular14
            );


            if (
                sin(
                    directive_pulse
                )
                >
                0.88
            )
            {
                draw_set_alpha(0.10);

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
    // SPECIAL — WAKE
    // =================================================

    if (terminal_special_state == 4)
    {
        draw_set_alpha(0.72);

        draw_set_color(
            terminal_bg
        );


        draw_rectangle(
            18,
            115,
            gw - 18,
            335,
            false
        );


        var wake_x = 68;
        var wake_y = 174;


        var wake_alpha =
            0.88 +
            sin(
                terminal_time *
                0.12
            )
            *
            0.12;


        draw_set_alpha(
            wake_alpha
        );


        draw_set_font(
            TerminalRegular18
        );


        draw_set_color(
            terminal_mother_bright
        );


        draw_text(
            wake_x,
            wake_y,
            "> WAKE"
        );


        draw_set_font(
            TerminalRegular14
        );


        if (
            terminal_cursor_visible &&
            terminal_special_timer < 115
        )
        {
            var wake_text_w =
                string_width(
                    "> WAKE"
                );


            draw_set_alpha(0.75);

            draw_set_color(
                terminal_mother
            );


            draw_rectangle(
                wake_x +
                wake_text_w +
                7,

                wake_y + 3,

                wake_x +
                wake_text_w +
                13,

                wake_y + 13,

                false
            );
        }


        if (terminal_special_timer >= 105)
        {
            var wake_instability =
                clamp(
                    (
                        terminal_special_timer -
                        105
                    )
                    /
                    35,
                    0,
                    1
                );


            draw_set_alpha(
                wake_instability *
                0.12
            );


            draw_set_color(
                terminal_mother_bright
            );


            draw_rectangle(
                0,
                wake_y + 5,
                gw,
                wake_y + 9,
                false
            );
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


    if (terminal_special_state == 4)
    {
        static_count =
            12 +
            floor(
                clamp(
                    terminal_special_timer /
                    140,
                    0,
                    1
                )
                *
                20
            );
    }


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
        draw_set_alpha(0.20);


        draw_set_color(
            mother_connected
            ? terminal_mother_bright
            : terminal_green_bright
        );


        if (terminal_special_state == 4)
        {
            draw_set_color(
                terminal_mother_bright
            );
        }


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


        draw_set_alpha(0.30);

        draw_set_color(c_black);


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

    draw_set_color(c_black);

    draw_set_alpha(
        terminal_scanline_alpha
    );


    var scan_offset =
        terminal_time
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
    // CONTINUOUS CRT REFRESH SWEEP
    // =================================================

    draw_set_alpha(
        mother_connected
        ? 0.016
        : 0.028
    );


    draw_set_color(
        mother_connected
        ? terminal_mother_bright
        : terminal_green_bright
    );


    if (terminal_special_state == 4)
    {
        draw_set_color(
            terminal_mother_bright
        );
    }


    // Soft phosphor refresh field.
    draw_rectangle(
        0,
        terminal_refresh_y,
        gw,
        terminal_refresh_y + 34,
        false
    );


    // Dark retrace edge immediately following it.
    draw_set_alpha(
        mother_connected
        ? 0.025
        : 0.050
    );

    draw_set_color(c_black);


    draw_rectangle(
        0,
        terminal_retrace_y,
        gw,
        terminal_retrace_y + 2,
        false
    );


    // Thin leading refresh line.
    draw_set_alpha(
        mother_connected
        ? 0.025
        : 0.045
    );

    draw_set_color(
        mother_connected
        ? terminal_mother_bright
        : terminal_green_bright
    );


    draw_line(
        0,
        terminal_refresh_y,
        gw,
        terminal_refresh_y
    );


    // =================================================
    // CRT EDGE DARKENING
    // =================================================

    draw_set_color(c_black);


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
        else if (
            terminal_special_state == 4 ||
            terminal_special_state == 6
        )
        {
            draw_set_color(
                terminal_mother_bright
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


        draw_set_alpha(0.45);

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
    // CINEMATIC LETTERBOX
    // ------------------------------------------------

    var bar_h = 38;


    draw_set_alpha(1);

    draw_set_color(c_black);


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
    // CONTINUE PROMPT
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

        var icon_slot_w = 34;


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
    // SLIDE FADE
    // ------------------------------------------------

    if (slide_fade > 0)
    {
        draw_set_alpha(
            slide_fade
        );

        draw_set_color(c_black);


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

draw_set_color(c_white);