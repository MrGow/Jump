 /// oIntroCutsceneController — Draw GUI


    var gw = 640;
    var gh = 360;


    // ====================================================
    // CRT BORDER
    //
    // spriteMainMenuBorder is the full 640 x 360 transparent
    // overlay with the thin CRT border around the outside.
    //
    // Draw it normally over CRT/terminal phases only.
    // This helper is called before the phase exits for:
    //     0 = CRT power-on
    //     1 = terminal
    //     2 = CRT shutdown
    //
    // It is NOT called for:
    //     3 = cinematic slides
    //     4 = finish
    // ====================================================

    var draw_crt_frame =
    function()
    {
        draw_set_alpha(1);
        draw_set_color(c_white);

        draw_sprite_ext(
            spriteMainMenuBorder,
            0,
            320,
            0,
            1,
            1,
            0,
            c_white,
            1
        );

        draw_set_alpha(1);
        draw_set_color(c_white);
    };

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
    // PHASE -1 — SIGNAL LOSS / CCCA RELAY HANDOFF
    //
    // Sequence:
    //
    // 0–29    violent acquisition static
    // 30–67   CCCA interface establishes
    // 68–96   relay diagnostics fail
    // 97–451  confirmed communications-loss display
    // 452–474 signal collapse
    // 475+    blackout before local CRT ignition
    //
    // Typography:
    //
    // 11px = system metadata / equipment labels
    // 14px = operational telemetry
    // 16px = alert classification
    // 18px = critical warning
    // ====================================================

    if (intro_phase == -1)
    {
        var st =
            signal_transition_timer;


        // ====================================================
        // STATIC FIELD
        // ====================================================

        var static_amount = 0;


        if (st < 28)
        {
            static_amount = 210;
        }
        else if (st < 452)
        {
            static_amount = 82;
        }
        else if (st < 475)
        {
            static_amount = 190;
        }


        if (static_amount > 0)
        {
            for (
                var sn = 0;
                sn < static_amount;
                sn++
            )
            {
                var sx =
                    (
                        sn * 73
                        +
                        st * 41
                        +
                        sn * sn * 3
                    )
                    mod
                    gw;

                var sy =
                    (
                        sn * 47
                        +
                        st * 29
                        +
                        sn * sn * 5
                    )
                    mod
                    gh;

                var sw =
                    1
                    +
                    (
                        (
                            sn * 17
                            +
                            st * 3
                        )
                        mod
                        13
                    );

                var sh =
                    1
                    +
                    (
                        (
                            sn * 11
                            +
                            st
                        )
                        mod
                        3
                    );


                var grain =
                    50
                    +
                    (
                        (
                            sn * 61
                            +
                            st * 17
                        )
                        mod
                        190
                    );


                draw_set_alpha(
                    st < 28
                    ? 0.72
                    : 0.38
                );

                draw_set_color(
                    make_color_rgb(
                        grain,
                        grain,
                        grain
                    )
                );


                draw_rectangle(
                    sx,
                    sy,
                    min(
                        gw,
                        sx + sw
                    ),
                    min(
                        gh,
                        sy + sh
                    ),
                    false
                );
            }


            // ------------------------------------------------
            // HORIZONTAL SIGNAL TEARS
            // ------------------------------------------------

            var tear_a =
                sin(
                    st * 0.83
                );

            var tear_b =
                sin(
                    st * 1.37 + 2.2
                );


            if (tear_a > 0.55)
            {
                var ty =
                    42
                    +
                    (
                        st * 7
                        mod
                        252
                    );

                draw_set_alpha(0.42);
                draw_set_color(c_white);

                draw_rectangle(
                    0,
                    ty,
                    gw,
                    ty + 2,
                    false
                );
            }


            if (tear_b > 0.72)
            {
                var ty2 =
                    28
                    +
                    (
                        st * 11
                        mod
                        286
                    );

                draw_set_alpha(0.68);
                draw_set_color(c_black);

                draw_rectangle(
                    0,
                    ty2,
                    gw,
                    ty2 + 5,
                    false
                );
            }
        }


        // ====================================================
        // CCCA INTERPLANETARY COMMUNICATIONS ALERT
        // ====================================================

        if (
            st >= 30
            &&
            st < 468
        )
        {
            var msg_alpha =
                clamp(
                    (st - 30)
                    /
                    12,
                    0,
                    1
                );


            // ------------------------------------------------
            // SIGNAL DROPOUTS
            //
            // Only during initial acquisition/failure.
            // Once the warning is established, readability
            // takes priority.
            // ------------------------------------------------

            if (
                st < 97
                &&
                (
                    st mod 19 == 0
                    ||
                    st mod 31 == 0
                )
            )
            {
                msg_alpha *= 0.28;
            }


            // ------------------------------------------------
            // ALERT PALETTE
            // ------------------------------------------------

            var alert_amber =
                make_color_rgb(
                    224,
                    174,
                    72
                );

            var alert_amber_dim =
                make_color_rgb(
                    128,
                    94,
                    38
                );

            var alert_dark =
                make_color_rgb(
                    18,
                    15,
                    8
                );


            draw_set_alpha(
                msg_alpha
            );

            draw_set_valign(
                fa_top
            );


            // =================================================
            // COMMAND HEADER
            //
            // Small equipment / command metadata.
            // =================================================

            draw_set_font(
                TerminalRegular11
            );

            draw_set_halign(
                fa_left
            );

            draw_set_color(
                terminal_green_bright
            );

            draw_text(
                54,
                39,
                "CCCA // INTERPLANETARY COMMUNICATIONS COMMAND"
            );


            draw_set_halign(
                fa_right
            );

            draw_set_color(
                terminal_green
            );

            draw_text(
                gw - 54,
                39,
                "CH 04"
            );


            // ------------------------------------------------
            // HEADER RULE
            // ------------------------------------------------

            draw_set_color(
                terminal_green_dim
            );

            draw_rectangle(
                54,
                56,
                gw - 54,
                57,
                false
            );


            // ------------------------------------------------
            // NETWORK IDENTIFICATION
            // ------------------------------------------------

            draw_set_halign(
                fa_left
            );

            draw_set_color(
                terminal_green_dim
            );

            draw_text(
                54,
                63,
                "DEEP-LINK RELAY NETWORK"
            );


            draw_set_halign(
                fa_right
            );

            draw_text(
                gw - 54,
                63,
                "ARRAY 07 // NODE 04"
            );


            // =================================================
            // CENTRAL ALERT PANEL
            // =================================================

            if (st >= 68)
            {
                var alert_x1 = 102;
                var alert_y1 = 86;

                var alert_x2 =
                    gw - 102;

                var alert_y2 = 142;


                // ---------------------------------------------
                // DARK PANEL BACKING
                // ---------------------------------------------

                draw_set_alpha(
                    msg_alpha * 0.74
                );

                draw_set_color(
                    alert_dark
                );

                draw_rectangle(
                    alert_x1,
                    alert_y1,
                    alert_x2,
                    alert_y2,
                    false
                );


                // ---------------------------------------------
                // CORNER BRACKETS
                // ---------------------------------------------

                draw_set_alpha(
                    msg_alpha
                );

                draw_set_color(
                    alert_amber_dim
                );


                // Top left.
                draw_line(
                    alert_x1,
                    alert_y1,
                    alert_x1 + 22,
                    alert_y1
                );

                draw_line(
                    alert_x1,
                    alert_y1,
                    alert_x1,
                    alert_y1 + 10
                );


                // Top right.
                draw_line(
                    alert_x2 - 22,
                    alert_y1,
                    alert_x2,
                    alert_y1
                );

                draw_line(
                    alert_x2,
                    alert_y1,
                    alert_x2,
                    alert_y1 + 10
                );


                // Bottom left.
                draw_line(
                    alert_x1,
                    alert_y2,
                    alert_x1 + 22,
                    alert_y2
                );

                draw_line(
                    alert_x1,
                    alert_y2 - 10,
                    alert_x1,
                    alert_y2
                );


                // Bottom right.
                draw_line(
                    alert_x2 - 22,
                    alert_y2,
                    alert_x2,
                    alert_y2
                );

                draw_line(
                    alert_x2,
                    alert_y2 - 10,
                    alert_x2,
                    alert_y2
                );


                // ---------------------------------------------
                // SIDE STRIPE DECORATION
                // ---------------------------------------------

                var stripe_y1 = 116;
                var stripe_y2 = 127;

                var stripe_left_x1 = alert_x1 + 18;
                var stripe_left_x2 = alert_x1 + 74;

                var stripe_right_x1 = alert_x2 - 74;
                var stripe_right_x2 = alert_x2 - 18;

                var stripe_spacing = 9;
                var stripe_slant = 6;

                draw_set_alpha(msg_alpha * 0.72);
                draw_set_color(alert_amber_dim);

                for (
                    var stripe_x = stripe_left_x1;
                    stripe_x <= stripe_left_x2;
                    stripe_x += stripe_spacing
                )
                {
                    draw_line(
                        stripe_x,
                        stripe_y2,
                        stripe_x + stripe_slant,
                        stripe_y1
                    );
                }

                for (
                    var stripe_x = stripe_right_x1;
                    stripe_x <= stripe_right_x2;
                    stripe_x += stripe_spacing
                )
                {
                    draw_line(
                        stripe_x,
                        stripe_y1,
                        stripe_x + stripe_slant,
                        stripe_y2
                    );
                }

                draw_set_alpha(msg_alpha);


                // ---------------------------------------------
                // ALERT CLASSIFICATION
                //
                // 16px separates this from both the tiny
                // metadata and the critical warning.
                // ---------------------------------------------

                draw_set_halign(
                    fa_center
                );

                draw_set_font(
                    TerminalRegular16
                );

                draw_set_color(
                    alert_amber_dim
                );

                draw_text(
                    gw * 0.5,
                    92,
                    "COMMUNICATIONS ALERT // PRIORITY 1"
                );


                // ---------------------------------------------
                // CRITICAL WARNING
                //
                // Hard flash:
                //
                // 27 frames ON
                // 15 frames OFF
                //
                // Locks solid shortly before collapse.
                // ---------------------------------------------

                var alert_flash =
                    (
                        (
                            (st - 68)
                            mod
                            42
                        )
                        <
                        27
                    );


                if (
                    alert_flash
                    ||
                    st >= 445
                )
                {
                    draw_set_font(
                        TerminalRegular18
                    );

                    draw_set_color(
                        alert_amber
                    );

                    draw_text(
                        gw * 0.5,
                        116,
                        "INTERPLANETARY LINK LOST"
                    );
                }
            }


            // =================================================
            // RELAY STATUS
            //
            // Operational information stays at 14px.
            // =================================================

            var relay_x =
                118;

            var status_x =
                404;


            draw_set_font(
                TerminalRegular14
            );

            draw_set_halign(
                fa_left
            );


            // ------------------------------------------------
            // SECTION LABEL
            // ------------------------------------------------

            if (st >= 42)
            {
                draw_set_font(
                    TerminalRegular11
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    relay_x,
                    153,
                    "RELAY STATUS // LIVE TELEMETRY"
                );

                draw_set_font(
                    TerminalRegular14
                );
            }


            // ------------------------------------------------
            // CARRIER
            // ------------------------------------------------

            if (st >= 48)
            {
                draw_set_color(
                    terminal_green
                );

                draw_text(
                    relay_x,
                    172,
                    "CARRIER SIGNAL"
                );


                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    260,
                    172,
                    "................"
                );


                draw_set_color(
                    st < 68
                    ? terminal_warning
                    : alert_amber
                );

                draw_text(
                    status_x,
                    172,
                    st < 68
                    ? "SEARCHING"
                    : "LOST"
                );
            }


            // ------------------------------------------------
            // REMOTE NODES
            // ------------------------------------------------

            if (st >= 54)
            {
                draw_set_color(
                    terminal_green
                );

                draw_text(
                    relay_x,
                    190,
                    "REMOTE NODE RESPONSE"
                );


                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    260,
                    190,
                    "................"
                );


                draw_set_color(
                    st < 74
                    ? terminal_warning
                    : alert_amber
                );

                draw_text(
                    status_x,
                    190,
                    st < 74
                    ? "WAITING"
                    : "NONE"
                );
            }


            // ------------------------------------------------
            // NETWORK SYNC
            // ------------------------------------------------

            if (st >= 60)
            {
                draw_set_color(
                    terminal_green
                );

                draw_text(
                    relay_x,
                    208,
                    "NETWORK SYNC"
                );


                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    260,
                    208,
                    "................"
                );


                draw_set_color(
                    st < 80
                    ? terminal_warning
                    : alert_amber
                );

                draw_text(
                    status_x,
                    208,
                    st < 80
                    ? "ACQUIRING"
                    : "FAILED"
                );
            }


            // ------------------------------------------------
            // UPLINK AUTHORITY
            // ------------------------------------------------

            if (st >= 66)
            {
                draw_set_color(
                    terminal_green
                );

                draw_text(
                    relay_x,
                    226,
                    "UPLINK AUTHORITY"
                );


                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    260,
                    226,
                    "................"
                );


                draw_set_color(
                    st < 86
                    ? terminal_warning
                    : alert_amber
                );

                draw_text(
                    status_x,
                    226,
                    st < 86
                    ? "PENDING"
                    : "UNAVAILABLE"
                );
            }


            // =================================================
            // FAULT IDENTIFICATION
            // =================================================

            if (st >= 88)
            {
                draw_set_color(
                    terminal_green_dim
                );

                draw_rectangle(
                    118,
                    248,
                    gw - 118,
                    249,
                    false
                );


                draw_set_font(
                    TerminalRegular11
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    118,
                    256,
                    "FAULT IDENTIFICATION"
                );


                draw_set_font(
                    TerminalRegular14
                );

                draw_set_color(
                    terminal_green
                );

                draw_text(
                    118,
                    270,
                    "FAULT CODE"
                );


                draw_set_color(
                    alert_amber
                );

                draw_text(
                    210,
                    270,
                    "DL-04 / CARRIER LOSS"
                );
            }


            // =================================================
            // AUTOMATED FALLBACK
            // =================================================

            if (st >= 102)
            {
                draw_set_font(
                    TerminalRegular14
                );

                draw_set_color(
                    terminal_green
                );

                draw_text(
                    118,
                    290,
                    "FALLBACK ROUTE"
                );


                draw_set_color(
                    terminal_green_bright
                );

                draw_text(
                    250,
                    290,
                    "LOCAL SYSTEM"
                );
            }


            // =================================================
            // RECOVERY ACTION
            // =================================================

            if (st >= 114)
            {
                draw_set_font(
                    TerminalRegular14
                );

                draw_set_halign(
                    fa_center
                );

                draw_set_color(
                    terminal_green_bright
                );

                draw_text(
                    gw * 0.5,
                    312,
                    "INITIATING LOCAL RECOVERY PROTOCOL"
                );


                // Hard terminal cursor.
                if (
                    (
                        st div 8
                    )
                    mod
                    2
                    ==
                    0
                )
                {
                    var recovery_w =
                        string_width(
                            "INITIATING LOCAL RECOVERY PROTOCOL"
                        );


                    draw_rectangle(
                        gw * 0.5
                        +
                        recovery_w * 0.5
                        +
                        4,
                        314,
                        gw * 0.5
                        +
                        recovery_w * 0.5
                        +
                        10,
                        323,
                        false
                    );
                }
            }


            // =================================================
            // SYSTEM FOOTER
            //
            // Small metadata again so it reads like the
            // controller/system identity rather than another
            // important player-facing message.
            // =================================================

            if (st >= 88)
            {
                draw_set_font(
                    TerminalRegular11
                );

                draw_set_halign(
                    fa_center
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    gw * 0.5,
                    338,
                    "CCCA AUTOMATED RELAY CONTROL // RECOVERY SEQUENCE ACTIVE"
                );
            }
        }


        // ====================================================
        // SIGNAL COLLAPSE
        // ====================================================

        if (
            st >= 452
            &&
            st < 475
        )
        {
            var collapse_p =
                clamp(
                    (
                        st - 452
                    )
                    /
                    23,
                    0,
                    1
                );


            // Static image is progressively crushed toward
            // the centre of the CRT.
            var collapse_h =
                lerp(
                    gh,
                    4,
                    collapse_p
                );


            draw_set_alpha(
                0.46 *
                collapse_p
            );

            draw_set_color(
                c_white
            );


            draw_rectangle(
                0,
                gh * 0.5 -
                collapse_h * 0.5,
                gw,
                gh * 0.5 +
                collapse_h * 0.5,
                true
            );


            // Bright final horizontal carrier line.
            draw_set_alpha(
                0.75 *
                collapse_p
            );

            draw_rectangle(
                0,
                gh * 0.5 - 1,
                gw,
                gh * 0.5 + 1,
                false
            );
        }


        // ====================================================
        // FINAL BLACKOUT
        // ====================================================

        if (st >= 475)
        {
            draw_set_alpha(1);

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


        // ====================================================
        // SIGNAL SCANLINES
        // ====================================================

        if (st < 475)
        {
            draw_set_alpha(0.12);

            draw_set_color(
                c_black
            );

            for (
                var sl = st mod 3;
                sl < gh;
                sl += 3
            )
            {
                draw_line(
                    0,
                    sl,
                    gw,
                    sl
                );
            }
        }


        // ====================================================
        // RESTORE DRAW STATE
        // ====================================================

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

        draw_set_font(-1);


        draw_crt_frame();

        exit;
    }
	
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
            draw_crt_frame();

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

        draw_crt_frame();

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
                terminal_x - 8,
                18,
                gw - terminal_x + 8,
                18
            );

            draw_line(
                terminal_x - 8,
                18,
                terminal_x - 8,
                316
            );

            draw_line(
                gw - terminal_x + 8,
                18,
                gw - terminal_x + 8,
                316
            );

            draw_line(
                330,
                18,
                330,
                316
            );

            draw_line(
                466,
                18,
                466,
                316
            );


            // Right-side subdivisions.
            draw_line(
                330,
                94,
                gw - terminal_x + 8,
                94
            );

            draw_line(
                466,
                166,
                gw - terminal_x + 8,
                166
            );

            draw_line(
                330,
                246,
                gw - terminal_x + 8,
                246
            );

            draw_line(
                terminal_x - 8,
                316,
                gw - terminal_x + 8,
                316
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
                terminal_x,
                22,
                "BOOTSTRAP MONITOR / MEMMAP"
            );


            draw_set_color(
                terminal_green_dim
            );


            draw_set_font(
                TerminalRegular11
            );

            draw_text(
                terminal_x,
                38,
                "ADDR      00 01 02 03 04 05 06 07"
            );

            draw_set_font(
                TerminalRegular14
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
                    terminal_x,
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


            draw_set_font(
                TerminalRegular11
            );

            draw_text(
                340,
                22,
                "SYS"
            );

            draw_set_font(
                TerminalRegular14
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


            draw_set_font(
                TerminalRegular11
            );

            draw_text(
                476,
                22,
                "IRQ/BUS"
            );

            draw_set_font(
                TerminalRegular14
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


            draw_set_font(
                TerminalRegular11
            );

            draw_text(
                476,
                104,
                "EXEC"
            );

            draw_set_font(
                TerminalRegular14
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


                // -----------------------------------------
                // GLITCHED HANDOFF WIPE
                //
                // The old bootstrap panel does not simply
                // vanish behind a clean rectangle. The lower
                // section flickers, tears and drops out as the
                // fallback console takes control.
                // -----------------------------------------

                var handoff_flicker =
                    0.78 +
                    0.22 *
                    abs(
                        sin(
                            terminal_special_timer *
                            0.91
                        )
                    );


                draw_set_alpha(
                    handoff_alpha *
                    handoff_flicker
                );

                draw_set_color(
                    terminal_bg
                );


                draw_rectangle(
                    terminal_x - 8,
                    247,
                    gw - terminal_x + 8,
                    316,
                    false
                );


                // Brief dark tear slices make the separator
                // lines disappear irregularly rather than all
                // at once.
                var handoff_tear_a =
                    sin(
                        terminal_special_timer *
                        1.37
                    );

                var handoff_tear_b =
                    sin(
                        terminal_special_timer *
                        0.73 +
                        2.1
                    );


                if (handoff_tear_a > 0.45)
                {
                    draw_set_alpha(
                        handoff_alpha *
                        0.88
                    );

                    draw_rectangle(
                        terminal_x - 3,
                        251,
                        gw - terminal_x - 24,
                        255,
                        false
                    );
                }


                if (handoff_tear_b > 0.58)
                {
                    draw_set_alpha(
                        handoff_alpha *
                        0.82
                    );

                    draw_rectangle(
                        terminal_x + 42,
                        310,
                        gw - terminal_x + 8,
                        314,
                        false
                    );
                }


                // Short green fragments flash where the old
                // panel separators are breaking apart.
                draw_set_color(
                    terminal_green_dim
                );


                if (handoff_tear_a > 0.68)
                {
                    draw_set_alpha(
                        handoff_alpha *
                        0.55
                    );

                    draw_line(
                        terminal_x - 8,
                        246,
                        214,
                        246
                    );

                    draw_line(
                        246,
                        246,
                        330,
                        246
                    );
                }


                if (handoff_tear_b > 0.72)
                {
                    draw_set_alpha(
                        handoff_alpha *
                        0.48
                    );

                    draw_line(
                        466,
                        246,
                        535,
                        246
                    );

                    draw_line(
                        557,
                        246,
                        gw - terminal_x + 8,
                        246
                    );
                }


                draw_set_alpha(
                    handoff_alpha
                );

                draw_set_color(
                    terminal_green_bright
                );


                draw_text(
                    terminal_x,
                    266,
                    "FALLBACK RECOVERY CONSOLE"
                );


                draw_set_color(
                    terminal_green
                );


                draw_text(
                    terminal_x,
                    288,
                    "INITIALIZING..."
                );


                if (
                    terminal_cursor_visible
                )
                {
                    draw_rectangle(
                        terminal_x,
                        304,
                        terminal_x + 8,
                        312,
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

            draw_crt_frame();

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
            terminal_y
            -
            terminal_history_scroll_px;


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

            var entry_rows = 1;

            if (array_length(entry) >= 3)
            {
                entry_rows =
                    max(
                        1,
                        entry[2]
                    );
            }


            // =================================================
            // FATHER TERMINAL BANNER
            // =================================================

            if (txt == "__FATHER_BRAND__")
            {
                // =================================================
                // REAL FATHER LOGO
                //
                // spriteFATHERLogo uses TOP CENTRE origin.
                // =================================================

                var father_sprite =
                    spriteFATHERLogo;

                var father_target_top =
                    yy;

                // 1140 x 666 source PNG.
                // Settled size is roughly 342 x 200.
                var father_base_scale =
                    0.30;

                var father_scale =
                    father_base_scale;

                var father_alpha =
                    terminal_flicker;

                var father_draw_x =
                    gw * 0.5;

                var father_draw_y =
                    father_target_top;

                if (terminal_special_state == 5)
                {
                    var father_intro_fade =
                        clamp(
                            terminal_special_timer /
                            18,
                            0,
                            1
                        );

                    var father_move =
                        clamp(
                            (
                                terminal_special_timer -
                                55
                            )
                            /
                            90,
                            0,
                            1
                        );

                    father_move =
                        father_move *
                        father_move *
                        (
                            3 -
                            2 *
                            father_move
                        );

                    var father_intro_scale =
                        father_base_scale *
                        1.18;

                    father_scale =
                        lerp(
                            father_intro_scale,
                            father_base_scale,
                            father_move
                        );

                    var father_sprite_h =
                        sprite_get_height(
                            father_sprite
                        );

                    var father_centre_y =
                        (
                            gh -
                            father_sprite_h *
                            father_scale
                        )
                        *
                        0.5;

                    father_draw_y =
                        lerp(
                            father_centre_y,
                            father_target_top,
                            father_move
                        );

                    father_alpha =
                        terminal_flicker *
                        father_intro_fade;
                }

                draw_set_alpha(
                    father_alpha
                );

                draw_set_color(
                    c_white
                );

                draw_sprite_ext(
                    father_sprite,
                    0,
                    round(father_draw_x),
                    round(father_draw_y),
                    father_scale,
                    father_scale,
                    0,
                    c_white,
                    1
                );

                yy +=
                    terminal_line_height *
                    entry_rows;

                continue;
            }



            // =================================================
            // MOTHER TERMINAL BANNER
            // =================================================

            if (txt == "__MOTHER_BRAND__")
            {
                // =================================================
                // REAL MOTHER LOGO
                //
                // spriteMOTHERLogo uses TOP CENTRE origin.
                // =================================================

                var mother_sprite =
                    spriteMOTHERLogo;

                // 1464 x 966 source PNG.
                // Settled size is roughly 366 x 242.
                var mother_base_scale =
                    0.25;

                var mother_scale =
                    mother_base_scale;

                var mother_alpha =
                    terminal_flicker;

                var mother_draw_x =
                    gw * 0.5;

                var mother_history_y =
                    yy;

                var mother_draw_y =
                    mother_history_y;

                if (terminal_special_state == 6)
                {
                    var mother_fade =
                        clamp(
                            terminal_special_timer /
                            14,
                            0,
                            1
                        );

                    var mother_settle =
                        clamp(
                            (
                                terminal_special_timer -
                                72
                            )
                            /
                            70,
                            0,
                            1
                        );

                    mother_settle =
                        mother_settle *
                        mother_settle *
                        (
                            3 -
                            2 *
                            mother_settle
                        );

                    var mother_intro_scale =
                        mother_base_scale *
                        1.13;

                    mother_scale =
                        lerp(
                            mother_intro_scale,
                            mother_base_scale,
                            mother_settle
                        );

                    var mother_sprite_h =
                        sprite_get_height(
                            mother_sprite
                        );

                    var mother_centre_y =
                        (
                            gh -
                            mother_sprite_h *
                            mother_scale
                        )
                        *
                        0.5;

                    mother_draw_y =
                        lerp(
                            mother_centre_y,
                            mother_history_y,
                            mother_settle
                        );

                    mother_alpha =
                        terminal_flicker *
                        mother_fade;
                }

                draw_set_alpha(
                    mother_alpha
                );

                draw_set_color(
                    c_white
                );

                draw_sprite_ext(
                    mother_sprite,
                    0,
                    round(mother_draw_x),
                    round(mother_draw_y),
                    mother_scale,
                    mother_scale,
                    0,
                    c_white,
                    1
                );

                yy +=
                    terminal_line_height *
                    entry_rows;

                continue;
            }



            // =================================================
            // AUTHORITY OVERRIDE PROGRESS
            //
            // This is now a normal history entry instead of a
            // lower-screen overlay, so it scrolls with the rest
            // of the command output.
            // =================================================

            if (txt == "__AUTH_PROGRESS__")
            {
                // =================================================
                // ROOT AUTHORITY MAP
                //
                // Retro character-cell / status-register style:
                //
                // - No thin boxes around empty cells.
                // - Captured cells are chunky solid cyan phosphor.
                // - Empty cells are tiny dim-green centre markers.
                // - Active cells have a restrained phosphor bloom.
                // - The newest captured cell pulses brighter.
                // - During FATHER's counterattack, the rightmost
                //   captured cell flashes amber as it is reclaimed.
                // =================================================

                var bar_x =
                    terminal_x + 14;

                var bar_y =
                    yy + 15;


                // -------------------------------------------------
                // REGISTER LABEL
                // -------------------------------------------------

                draw_set_alpha(
                    terminal_flicker
                );

                draw_set_font(
                    TerminalRegular11
                );

                draw_set_halign(
                    fa_left
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    terminal_x,
                    yy,
                    "ROOT AUTHORITY MAP"
                );


                // -------------------------------------------------
                // SEGMENT LAYOUT
                // -------------------------------------------------

                var segment_count = 20;

                var segment_w = 13;
                var segment_h = 8;

                var segment_gap = 4;


                var total_bar_w =
                    segment_count *
                    segment_w
                    +
                    (segment_count - 1) *
                    segment_gap;


                var active_segments =
                    clamp(
                        ceil(
                            overwrite_progress *
                            segment_count
                        ),
                        0,
                        segment_count
                    );


                // -------------------------------------------------
                // REGISTER DELIMITERS
                //
                // These are deliberately separate from the cells:
                // the register is bracketed, but the individual
                // blocks are not boxed.
                // -------------------------------------------------

                draw_set_alpha(
                    0.72 *
                    terminal_flicker
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    bar_x - 13,
                    bar_y - 3,
                    ">"
                );

                draw_text(
                    bar_x + total_bar_w + 7,
                    bar_y - 3,
                    "<"
                );


                // -------------------------------------------------
                // CELLS
                // -------------------------------------------------

                for (
                    var seg = 0;
                    seg < segment_count;
                    seg++
                )
                {
                    var sx =
                        bar_x
                        +
                        seg *
                        (
                            segment_w +
                            segment_gap
                        );


                    if (seg < active_segments)
                    {
                        // -----------------------------------------
                        // SOFT PHOSPHOR BLOOM
                        // -----------------------------------------

                        draw_set_alpha(
                            0.12 *
                            terminal_flicker
                        );

                        draw_set_color(
                            terminal_mother_bright
                        );

                        draw_rectangle(
                            sx - 2,
                            bar_y - 2,
                            sx + segment_w + 2,
                            bar_y + segment_h + 2,
                            false
                        );


                        // -----------------------------------------
                        // SOLID CAPTURED CELL
                        // -----------------------------------------

                        var cell_colour =
                            terminal_mother;

                        var cell_alpha =
                            terminal_flicker;


                        // The newest MOTHER-controlled cell has
                        // a small phosphor pulse while it is the
                        // leading edge of the takeover.
                        if (
                            seg ==
                            active_segments - 1
                            &&
                            !overwrite_reversing
                            &&
                            !overwrite_complete
                        )
                        {
                            var capture_pulse =
                                0.78
                                +
                                0.22 *
                                abs(
                                    sin(
                                        terminal_time *
                                        0.42
                                    )
                                );

                            cell_colour =
                                terminal_mother_bright;

                            cell_alpha =
                                terminal_flicker *
                                capture_pulse;
                        }


                        // While FATHER is pushing MOTHER back,
                        // the cell currently being reclaimed
                        // flashes amber before disappearing.
                        if (
                            overwrite_reversing
                            &&
                            seg ==
                            active_segments - 1
                        )
                        {
                            var father_reclaim_flash =
                                (
                                    (
                                        terminal_time div 3
                                    )
                                    mod
                                    2
                                )
                                ==
                                0;

                            cell_colour =
                                father_reclaim_flash
                                ? terminal_father
                                : terminal_warning;

                            cell_alpha =
                                terminal_flicker;
                        }


                        draw_set_alpha(
                            cell_alpha
                        );

                        draw_set_color(
                            cell_colour
                        );

                        draw_rectangle(
                            sx,
                            bar_y,
                            sx + segment_w,
                            bar_y + segment_h,
                            false
                        );


                        // Tiny bright top edge gives the filled
                        // cell a phosphor-register snap without
                        // outlining the whole block.
                        draw_set_alpha(
                            0.34 *
                            terminal_flicker
                        );

                        draw_set_color(
                            cell_colour
                        );

                        draw_line(
                            sx + 1,
                            bar_y,
                            sx + segment_w - 1,
                            bar_y
                        );
                    }
                    else
                    {
                        // -----------------------------------------
                        // EMPTY REGISTER POSITION
                        //
                        // Just a tiny centre marker. No cell box.
                        // -----------------------------------------

                        var marker_w = 3;
                        var marker_h = 2;

                        var marker_x =
                            sx
                            +
                            floor(
                                segment_w * 0.5
                            );

                        var marker_y =
                            bar_y
                            +
                            floor(
                                segment_h * 0.5
                            );


                        draw_set_alpha(
                            0.58 *
                            terminal_flicker
                        );

                        draw_set_color(
                            terminal_green_dim
                        );

                        draw_rectangle(
                            marker_x -
                            floor(
                                marker_w * 0.5
                            ),
                            marker_y -
                            floor(
                                marker_h * 0.5
                            ),
                            marker_x +
                            ceil(
                                marker_w * 0.5
                            ),
                            marker_y +
                            ceil(
                                marker_h * 0.5
                            ),
                            false
                        );
                    }
                }


                // -------------------------------------------------
                // CAPTURE INDEX
                // -------------------------------------------------

                draw_set_alpha(
                    terminal_flicker
                );

                draw_set_font(
                    TerminalRegular11
                );

                draw_set_color(
                    overwrite_reversing
                    ? terminal_father
                    : terminal_mother_bright
                );

                draw_text(
                    bar_x + total_bar_w + 28,
                    bar_y - 3,
                    "INDEX "
                    +
                    string(
                        active_segments
                    )
                    +
                    "/"
                    +
                    string(
                        segment_count
                    )
                );


                draw_set_font(
                    TerminalRegular14
                );


                yy +=
                    terminal_line_height *
                    entry_rows;

                continue;
            }


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


            if (
                terminal_special_state == 4
                &&
                !wake_flood_started
            )
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
                terminal_line_height *
                entry_rows;
        }
		
		// =================================================
        // SPECIAL — FINAL DIRECTIVE
        //
        // Framed terminal subsystem window. The panel still
        // sits over the normal terminal, but now looks like a
        // native root-authority override interface rather than
        // a plain black rectangle.
        // =================================================

        if (terminal_special_state == 3)
        {
            var panel_x1 = 28;
            var panel_y1 = 108;
            var panel_x2 = gw - 28;
            var panel_y2 = 336;

            var panel_inner_x1 = panel_x1 + 6;
            var panel_inner_y1 = panel_y1 + 6;
            var panel_inner_x2 = panel_x2 - 6;
            var panel_inner_y2 = panel_y2 - 6;


            // -------------------------------------------------
            // PANEL BACKGROUND
            // -------------------------------------------------

            draw_set_alpha(0.96);

            draw_set_color(
                terminal_bg
            );

            draw_rectangle(
                panel_x1,
                panel_y1,
                panel_x2,
                panel_y2,
                false
            );


            // Very subtle inner phosphor tint.
            draw_set_alpha(0.045);

            draw_set_color(
                terminal_mother
            );

            draw_rectangle(
                panel_inner_x1,
                panel_inner_y1,
                panel_inner_x2,
                panel_inner_y2,
                false
            );


            // -------------------------------------------------
            // OUTER / INNER TERMINAL FRAME
            // -------------------------------------------------

            draw_set_alpha(
                0.72 *
                terminal_flicker
            );

            draw_set_color(
                terminal_green_dim
            );

            draw_rectangle(
                panel_x1,
                panel_y1,
                panel_x2,
                panel_y2,
                true
            );


            draw_set_alpha(
                0.30 *
                terminal_flicker
            );

            draw_rectangle(
                panel_inner_x1,
                panel_inner_y1,
                panel_inner_x2,
                panel_inner_y2,
                true
            );


            // -------------------------------------------------
            // CORNER MARKS
            // -------------------------------------------------

            draw_set_alpha(
                0.90 *
                terminal_flicker
            );

            draw_set_color(
                terminal_mother
            );


            // Top-left.
            draw_line(
                panel_x1,
                panel_y1,
                panel_x1 + 18,
                panel_y1
            );

            draw_line(
                panel_x1,
                panel_y1,
                panel_x1,
                panel_y1 + 12
            );


            // Top-right.
            draw_line(
                panel_x2 - 18,
                panel_y1,
                panel_x2,
                panel_y1
            );

            draw_line(
                panel_x2,
                panel_y1,
                panel_x2,
                panel_y1 + 12
            );


            // Bottom-left.
            draw_line(
                panel_x1,
                panel_y2,
                panel_x1 + 18,
                panel_y2
            );

            draw_line(
                panel_x1,
                panel_y2 - 12,
                panel_x1,
                panel_y2
            );


            // Bottom-right.
            draw_line(
                panel_x2 - 18,
                panel_y2,
                panel_x2,
                panel_y2
            );

            draw_line(
                panel_x2,
                panel_y2 - 12,
                panel_x2,
                panel_y2
            );
            
            // -------------------------------------------------
            // HEADER
            // -------------------------------------------------

            draw_set_alpha(
                terminal_flicker
            );

            draw_set_font(
                TerminalRegular11
            );

            draw_set_halign(
                fa_left
            );

            draw_set_valign(
                fa_top
            );


            draw_set_color(
                terminal_mother_bright
            );

            draw_text(
                panel_x1 + 18,
                panel_y1 + 12,
                "[ SYS://ROOT_DIRECTIVE ]"
            );


            draw_set_halign(
                fa_right
            );

            draw_set_color(
                terminal_green_dim
            );

            draw_text(
                panel_x2 - 18,
                panel_y1 + 12,
                "AUTHORITY WRITE"
            );


            draw_set_halign(
                fa_left
            );


            // Header divider.
            draw_set_alpha(
                0.52 *
                terminal_flicker
            );

            draw_set_color(
                terminal_green_dim
            );

            draw_line(
                panel_x1 + 12,
                panel_y1 + 34,
                panel_x2 - 12,
                panel_y1 + 34
            );


            // Small MOTHER takeover marker on the divider.
            draw_set_alpha(
                0.85 *
                terminal_flicker
            );

            draw_set_color(
                terminal_mother
            );

            draw_line(
                panel_x1 + 12,
                panel_y1 + 34,
                panel_x1 + 94,
                panel_y1 + 34
            );


            // -------------------------------------------------
            // PRIMARY DIRECTIVE HEADING
            // -------------------------------------------------

            draw_set_font(
                TerminalRegular18
            );

            draw_set_halign(
                fa_center
            );

            draw_set_alpha(
                terminal_flicker
            );

            draw_set_color(
                terminal_mother_bright
            );

            draw_text(
                gw * 0.5,
                panel_y1 + 42,
                "ROOT DIRECTIVE"
            );


            draw_set_font(
                TerminalRegular14
            );

            draw_set_halign(
                fa_left
            );


            // -------------------------------------------------
            // DIRECTIVE METADATA
            // -------------------------------------------------

            var dx = panel_x1 + 40;
            var value_x = dx + 192;
            var dy = panel_y1 + 66;


            if (directive_stage >= 1)
            {
                draw_set_alpha(
                    terminal_flicker
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_text(
                    dx,
                    dy,
                    "AUTHORITY SOURCE"
                );


                draw_set_color(
                    terminal_mother_bright
                );

                draw_text(
                    value_x,
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
                    "ROOT TARGET"
                );


                draw_set_color(
                    terminal_father
                );

                draw_text(
                    value_x,
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
                    "EXECUTION PRIORITY"
                );


                draw_set_color(
                    terminal_warning
                );

                draw_text(
                    value_x,
                    dy + 44,
                    "ABSOLUTE"
                );
            }


            // -------------------------------------------------
            // PAYLOAD DIVIDER
            // -------------------------------------------------

            if (directive_stage >= 4)
            {
                draw_set_alpha(
                    0.48 *
                    terminal_flicker
                );

                draw_set_color(
                    terminal_green_dim
                );

                draw_line(
                    panel_x1 + 12,
                    dy + 72,
                    panel_x2 - 12,
                    dy + 72
                );


                draw_set_alpha(
                    terminal_flicker
                );

                draw_set_font(
                    TerminalRegular11
                );

                draw_set_color(
                    terminal_green
                );

                draw_text(
                    dx,
                    dy + 82,
                    "DIRECTIVE PAYLOAD // ROOT EXECUTION"
                );

                draw_set_font(
                    TerminalRegular14
                );
            }


            // -------------------------------------------------
            // INPUT CURSOR
            // -------------------------------------------------

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


            // -------------------------------------------------
            // KILL FATHER
            // -------------------------------------------------

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
                    TerminalRegular28
                );

                draw_set_halign(
                    fa_center
                );

                draw_set_color(
                    terminal_directive
                );

                draw_text(
                    gw * 0.5,
                    dy + 100,
                    "KILL FATHER"
                );


                // -----------------------------------------
                // RED DIRECTIVE DISTORTIONS
                //
                // These are brief, intermittent horizontal
                // glitches rather than a permanent rail.
                // They flicker in and out while the payload is
                // committed.
                // -----------------------------------------

                var kill_glitch_a =
                    sin(
                        directive_timer *
                        0.39
                    );

                var kill_glitch_b =
                    sin(
                        directive_timer *
                        0.71 +
                        1.8
                    );

                var kill_glitch_c =
                    sin(
                        directive_timer *
                        1.13 +
                        4.1
                    );


                draw_set_color(
                    terminal_directive
                );


                if (kill_glitch_a > 0.72)
                {
                    draw_set_alpha(
                        0.16 +
                        kill_pulse * 0.20
                    );

                    draw_rectangle(
                        dx - 9,
                        dy + 103,
                        panel_x2 - 22,
                        dy + 107,
                        false
                    );


                    draw_set_alpha(
                        0.50
                    );

                    draw_text(
                        gw * 0.5 + 4,
                        dy + 99,
                        "KILL FATHER"
                    );
                }


                if (kill_glitch_b > 0.80)
                {
                    draw_set_alpha(
                        0.24
                    );

                    draw_rectangle(
                        dx + 34,
                        dy + 112,
                        panel_x2 - 58,
                        dy + 115,
                        false
                    );
                }


                if (kill_glitch_c > 0.84)
                {
                    draw_set_alpha(
                        0.28
                    );

                    draw_rectangle(
                        panel_x1 + 8,
                        dy + 97,
                        panel_x2 - 12,
                        dy + 100,
                        false
                    );


                    draw_set_alpha(
                        0.42
                    );

                    draw_text(
                        gw * 0.5 - 3,
                        dy + 101,
                        "KILL FATHER"
                    );
                }


                // Footer status appears only once the final
                // directive has committed.
                draw_set_halign(
                    fa_left
                );

                draw_set_font(
                    TerminalRegular14
                );

                draw_set_alpha(
                    0.78 *
                    terminal_flicker
                );

                draw_set_color(
                    terminal_mother
                );

                draw_text(
                    dx,
                    dy + 139,
                    "STATUS"
                );


                draw_set_color(
                    terminal_mother_bright
                );

                draw_text(
                    value_x,
                    dy + 139,
                    "COMMITTED"
                );


            }
            
            // -------------------------------------------------
            // TINY SUBSYSTEM FOOTER
            // -------------------------------------------------

            draw_set_font(
                TerminalRegular11
            );

            draw_set_alpha(
                0.42 *
                terminal_flicker
            );

            draw_set_color(
                terminal_green_dim
            );

            draw_set_halign(
                fa_right
            );

            draw_text(
                panel_x2 - 16,
                panel_y2 - 17,
                "ROOT/OVERRIDE :: ACTIVE"
            );


            draw_set_halign(
                fa_left
            );

            draw_set_valign(
                fa_top
            );
        }


        // =================================================
// SPECIAL — WAKE
//
// One restrained WAKE appears first.
//
// Then independent vertical torrents of WAKE rise
// rapidly through the CRT, multiplying horizontally
// until the whole display is overwhelmed.
// =================================================

if (terminal_special_state == 4)
{
    // ------------------------------------------------
    // ALWAYS ERASE THE OLD TERMINAL
    //
    // This is important. Once WAKE begins, none of the
    // previous terminal history should become visible
    // again.
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


    // =================================================
    // SINGLE WAKE
    // =================================================

    if (!wake_flood_started)
    {
        var wake_x =
            terminal_x;

        var wake_y =
            300;


        draw_set_font(
            TerminalRegular18
        );

        draw_set_halign(
            fa_left
        );

        draw_set_valign(
            fa_top
        );


        if (terminal_special_timer >= 45)
        {
            draw_set_alpha(
                terminal_flicker
            );

            draw_set_color(
                terminal_mother
            );


            draw_text(
                wake_x,
                wake_y,
                "WAKE"
            );


            if (terminal_cursor_visible)
            {
                var wake_text_w =
                    string_width(
                        "WAKE"
                    );


                draw_set_color(
                    terminal_mother_bright
                );


                draw_rectangle(
                    wake_x + wake_text_w + 3,
                    wake_y + 2,

                    wake_x + wake_text_w + 10,
                    wake_y + 13,

                    false
                );
            }
        }
    }


    // =================================================
    // WAKE FLOOD
    // =================================================

    else
    {
        var flood_age =
            terminal_special_timer -
            wake_flood_start_frame;


        // ---------------------------------------------
        // COLUMN ESCALATION
        //
        // 1 → 2 → 4 → 7 → 10
        // ---------------------------------------------

        var wake_columns = 1;


        if (flood_age >= 128)
        {
            wake_columns = 10;
        }
        else if (flood_age >= 100)
        {
            wake_columns = 7;
        }
        else if (flood_age >= 70)
        {
            wake_columns = 4;
        }
        else if (flood_age >= 38)
        {
            wake_columns = 2;
        }


        draw_set_font(
            TerminalRegular14
        );

        draw_set_halign(
            fa_left
        );

        draw_set_valign(
            fa_top
        );


        var wake_left =
            terminal_x;

        var wake_right =
            gw - 58;


        var wake_spacing_y =
            17;


        var wake_rows =
            ceil(
                gh /
                wake_spacing_y
            )
            +
            5;


        // Fast continuous upward motion.
        var wake_scroll =
            (
                wake_flood_timer *
                7.5
            )
            mod
            wake_spacing_y;


        // ---------------------------------------------
        // DRAW EACH INDEPENDENT COLUMN
        // ---------------------------------------------

        for (
            var col = 0;
            col < wake_columns;
            col++
        )
        {
            var column_t = 0;


            if (wake_columns > 1)
            {
                column_t =
                    col /
                    (
                        wake_columns - 1
                    );
            }


            var column_x =
                lerp(
                    wake_left,
                    wake_right,
                    column_t
                );


            // Each torrent is vertically offset so they
            // don't look like a rigid repeating grid.
            var column_phase =
                (
                    col * 7 +
                    col * col * 3
                )
                mod
                wake_spacing_y;


            for (
                var row = -2;
                row < wake_rows;
                row++
            )
            {
                var wake_draw_y =
                    row *
                    wake_spacing_y
                    -
                    wake_scroll
                    +
                    column_phase;


                // -------------------------------------
                // PHOSPHOR FLICKER
                // -------------------------------------

                var cell_alpha =
                    random_range(
                        0.68,
                        0.96
                    );


                if (
                    (
                        row +
                        col +
                        terminal_time
                    )
                    mod
                    11
                    ==
                    0
                )
                {
                    cell_alpha =
                        1;
                }


                draw_set_alpha(
                    cell_alpha *
                    terminal_flicker
                );


                // Occasional unnaturally bright MOTHER
                // cyan cell amongst the flood.
                if (
                    (
                        row * 5 +
                        col * 11 +
                        terminal_time
                    )
                    mod
                    29
                    ==
                    0
                )
                {
                    draw_set_color(
                        terminal_mother_bright
                    );
                }
                else
                {
                    draw_set_color(
                        terminal_mother
                    );
                }


                // -------------------------------------
                // LATE HORIZONTAL INSTABILITY
                // -------------------------------------

                var wake_jitter_x = 0;


                if (
                    flood_age >= 100 &&
                    (
                        row +
                        terminal_time
                    )
                    mod
                    17
                    ==
                    0
                )
                {
                    wake_jitter_x =
                        choose(
                            -4,
                            -2,
                            2,
                            4
                        );
                }


                draw_text(
                    column_x +
                    wake_jitter_x,

                    wake_draw_y,

                    "WAKE"
                );
            }
        }


        // =================================================
        // LATE HORIZONTAL TEAR
        // =================================================

        if (flood_age >= 100)
        {
            var tear_y =
                (
                    terminal_time *
                    11
                )
                mod
                gh;


            draw_set_alpha(
                0.08
            );

            draw_set_color(
                terminal_mother_bright
            );


            draw_rectangle(
                0,
                tear_y,
                gw,
                tear_y + 2,
                false
            );
        }


        // =================================================
        // FINAL PHOSPHOR OVERLOAD
        // =================================================

        if (flood_age >= 128)
        {
            var overload =
                clamp(
                    (
                        flood_age -
                        128
                    )
                    /
                    max(
                        1,
                        (
                            wake_flood_shutdown_frame -
                            wake_flood_start_frame
                        )
                        -
                        128
                    ),
                    0,
                    1
                );


            draw_set_alpha(
                overload *
                0.055
            );

            draw_set_color(
                terminal_mother_bright
            );


            draw_rectangle(
                0,
                0,
                gw,
                gh,
                false
            );
        }
    }


    // ------------------------------------------------
    // RESTORE DRAW STATE
    // ------------------------------------------------

    draw_set_alpha(1);

    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );

    draw_set_font(
        TerminalRegular14
    );
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
            if (wake_flood_started)
            {
                static_count =
                    18 +
                    floor(
                        clamp(
                            (
                                terminal_special_timer -
                                wake_flood_start_frame
                            )
                            /
                            max(
                                1,
                                wake_flood_shutdown_frame -
                                wake_flood_start_frame
                            ),
                            0,
                            1
                        )
                        *
                        42
                    );
            }
            else
            {
                static_count = 12;
            }
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

        draw_crt_frame();

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

        draw_crt_frame();

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

