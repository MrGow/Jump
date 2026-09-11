/// oIntroCutsceneController — Step


phase_timer++;
terminal_time++;


// ====================================================
// TERMINAL VISUAL FLAIR
// ====================================================

// ----------------------------------------------------
// Continuous CRT refresh
//
// This is intentionally always moving. It creates the
// old phosphor-display feeling independently of the
// occasional large horizontal corruption.
// ----------------------------------------------------

terminal_refresh_phase +=
    mother_connected
    ? 0.56
    : 0.88;


var refresh_wave =
    sin(
        terminal_refresh_phase
    )
    *
    (
        mother_connected
        ? 0.008
        : 0.020
    )
    +
    sin(
        terminal_refresh_phase * 2.71
    )
    *
    (
        mother_connected
        ? 0.004
        : 0.010
    );


terminal_refresh_level =
    clamp(
        (
            mother_connected
            ? 0.986
            : 0.958
        )
        +
        refresh_wave,
        0.88,
        1
    );


terminal_refresh_snap = 1;


// Tiny one-frame phosphor intensity dips.
if (!mother_connected)
{
    if (
        terminal_time mod 6 == 0 ||
        terminal_time mod 11 == 0
    )
    {
        terminal_refresh_snap =
            random_range(
                0.91,
                0.965
            );
    }
}
else if (terminal_time mod 17 == 0)
{
    terminal_refresh_snap =
        0.985;
}


terminal_refresh_y =
    (
        terminal_time *
        (
            mother_connected
            ? 4.2
            : 5.8
        )
    )
    mod
    390
    -
    15;


terminal_retrace_y =
    (
        terminal_refresh_y +
        34
    )
    mod
    390
    -
    15;


terminal_scanline_alpha =
    (
        mother_connected
        ? 0.115
        : 0.145
    )
    +
    sin(
        terminal_refresh_phase * 0.61
    )
    *
    0.012;


// ----------------------------------------------------
// Overall text intensity
// ----------------------------------------------------

if (mother_connected)
{
    terminal_flicker =
        terminal_refresh_level *
        terminal_refresh_snap *
        (
            0.992 +
            random(0.008)
        );
}
else
{
    terminal_flicker =
        terminal_refresh_level *
        terminal_refresh_snap *
        (
            0.965 +
            random(0.035)
        );


    if (irandom(135) == 0)
    {
        terminal_flicker =
            random_range(
                0.76,
                0.86
            );
    }
}


// ----------------------------------------------------
// Cursor
// ----------------------------------------------------

terminal_cursor_timer++;

if (terminal_cursor_timer >= 24)
{
    terminal_cursor_timer = 0;

    terminal_cursor_visible =
        !terminal_cursor_visible;
}


// ----------------------------------------------------
// Random horizontal corruption
// ----------------------------------------------------

if (terminal_glitch_timer > 0)
{
    terminal_glitch_timer--;
}
else if (intro_phase <= 2)
{
    var glitch_chance =
        mother_connected
        ? 320
        : 145;


    if (
        terminal_special_state == 5 ||
        terminal_special_state == 6
    )
    {
        glitch_chance = 500;
    }
    else if (terminal_special_state == 7)
    {
        glitch_chance = 82;
    }


    if (irandom(glitch_chance) == 0)
    {
        terminal_glitch_timer =
            irandom_range(
                1,
                3
            );

        terminal_glitch_y =
            irandom_range(
                20,
                330
            );

        terminal_glitch_h =
            irandom_range(
                1,
                4
            );

        terminal_glitch_offset =
            choose(
                -8,
                -5,
                5,
                8
            );
    }
}


// ----------------------------------------------------
// Flash decay
// ----------------------------------------------------

terminal_flash =
    max(
        0,
        terminal_flash - 0.08
    );


// ----------------------------------------------------
// Pulse clocks
// ----------------------------------------------------

mother_pulse += 0.12;

directive_pulse += 0.16;


// ====================================================
// SMOOTH TERMINAL HISTORY SCROLL
//
// Whenever terminal history exceeds the visible row budget,
// move all existing output upward smoothly. Entries are only
// deleted after they have completely scrolled offscreen.
// ====================================================

if (
    intro_phase == 1
    &&
    array_length(
        terminal_visible_lines
    )
    >
    0
)
{
    if (
        terminal_history_scroll_px <
        terminal_history_scroll_target_px
    )
    {
        terminal_history_scroll_px =
            min(
                terminal_history_scroll_target_px,
                terminal_history_scroll_px
                +
                terminal_history_scroll_speed
            );
    }


    var keep_removing =
        true;


    while (
        keep_removing
        &&
        array_length(
            terminal_visible_lines
        )
        >
        0
    )
    {
        var first_entry =
            terminal_visible_lines[0];

        var first_rows = 1;


        if (
            array_length(
                first_entry
            )
            >=
            3
        )
        {
            first_rows =
                max(
                    1,
                    first_entry[2]
                );
        }


        var first_height =
            first_rows *
            terminal_line_height;


        if (
            terminal_history_scroll_px
            >=
            first_height
        )
        {
            terminal_history_scroll_px -=
                first_height;

            terminal_history_scroll_target_px -=
                first_height;


            terminal_history_scroll_target_px =
                max(
                    0,
                    terminal_history_scroll_target_px
                );


            array_delete(
                terminal_visible_lines,
                0,
                1
            );
        }
        else
        {
            keep_removing =
                false;
        }
    }
}


// ====================================================
// PHASE 0 — CRT POWER ON
// ====================================================

if (intro_phase == 0)
{
    crt_power_progress =
        clamp(
            phase_timer /
            crt_power_duration,
            0,
            1
        );


    if (
        phase_timer >=
        crt_power_duration
    )
    {
        intro_phase = 1;

        phase_timer = 0;

        terminal_index = 0;
        terminal_timer = 0;

        terminal_visible_lines = [];

        terminal_history_scroll_px = 0;
        terminal_history_scroll_target_px = 0;


        // Raw machine bootstrap first. FATHER's clean
        // corporate identity appears only after the
        // low-level recovery console stabilises.
        terminal_special_state = 7;
        terminal_special_timer = 0;

        boot_debug_tick = 0;
        boot_debug_page = 0;
        boot_debug_scan = 0;
        boot_debug_bus = 0;
        boot_debug_fault = 0;

        terminal_flash = 0.16;
    }

    exit;
}


// ====================================================
// PHASE 1 — TERMINAL
// ====================================================

if (intro_phase == 1)
{
    // =================================================
    // SPECIAL STATE 7 — RAW BOOT / DEBUG CONSOLE
    // =================================================

    if (terminal_special_state == 7)
    {
        terminal_special_timer++;

        boot_debug_tick++;


        // Rapid low-level values continually update.
        if (boot_debug_tick >= 2)
        {
            boot_debug_tick = 0;

            boot_debug_scan =
                (
                    boot_debug_scan + 1
                )
                mod
                array_length(
                    boot_debug_hex
                );

            boot_debug_bus =
                (
                    boot_debug_bus +
                    irandom_range(
                        1,
                        3
                    )
                )
                mod
                256;
        }


        if (
            terminal_special_timer mod 19 == 0
        )
        {
            boot_debug_page =
                (
                    boot_debug_page + 1
                )
                mod
                4;
        }


        // Faults increasingly appear as the bootstrap
        // realises how damaged the unit is.
        if (terminal_special_timer == 72)
        {
            boot_debug_fault = 1;

            terminal_flash = 0.10;
        }


        if (terminal_special_timer == 128)
        {
            boot_debug_fault = 2;

            terminal_flash = 0.14;

            terminal_glitch_timer = 3;
            terminal_glitch_y = 266;
            terminal_glitch_h = 2;
            terminal_glitch_offset = -6;
        }


        if (terminal_special_timer == 178)
        {
            boot_debug_fault = 3;

            terminal_flash = 0.18;

            terminal_glitch_timer = 4;
            terminal_glitch_y = 120;
            terminal_glitch_h = 3;
            terminal_glitch_offset = 7;
        }


        // Final fallback-console message gets a brief
        // clean hold before the FATHER ident.
        if (terminal_special_timer == 208)
        {
            terminal_flash = 0.12;
        }


        if (
            terminal_special_timer >=
            boot_debug_duration
        )
        {
            terminal_special_state = 5;
            terminal_special_timer = 0;

            terminal_visible_lines = [];

            terminal_history_scroll_px = 0;
            terminal_history_scroll_target_px = 0;

            terminal_push_history(
                "__FATHER_BRAND__",
                5,
                father_brand_rows
            );

            terminal_flash = 0.16;

            terminal_glitch_timer = 0;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 5 — FATHER BRANDING
    // =================================================

    if (terminal_special_state == 5)
    {
        terminal_special_timer++;


        if (terminal_special_timer == 1)
        {
            terminal_flash = 0.18;
        }


        if (terminal_special_timer == 34)
        {
            terminal_flash = 0.10;
        }


        if (
            terminal_special_timer >=
            father_brand_duration
        )
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            terminal_timer = 12;

            terminal_flash = 0.08;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 6 — MOTHER BRANDING
    //
    // This now happens ONLY after MOTHER has broken
    // FATHER's root authority.
    // =================================================

    if (terminal_special_state == 6)
    {
        terminal_special_timer++;


        if (terminal_special_timer == 1)
        {
            // MOTHER now owns the remote authority.
            mother_connected = true;

            terminal_flash = 0.65;

            terminal_glitch_timer = 5;
            terminal_glitch_y = 174;
            terminal_glitch_h = 4;
            terminal_glitch_offset = 10;
        }


        // The violent takeover settles into MOTHER's
        // unnervingly clean corporate presentation.
        if (terminal_special_timer == 20)
        {
            terminal_flash = 0.18;
        }


        if (terminal_special_timer == 58)
        {
            terminal_flash = 0.10;
        }


        if (
            terminal_special_timer >=
            mother_brand_duration
        )
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            terminal_timer = 12;

            terminal_flash = 0.08;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 1 — MOTHER CONNECTED
    // =================================================

    if (terminal_special_state == 1)
    {
        terminal_special_timer++;


        if (terminal_special_timer == 1)
        {
            mother_connected = true;

            terminal_flash = 0.32;
        }


        if (terminal_special_timer == 24)
        {
            terminal_flash = 0.14;
        }


        if (terminal_special_timer == 48)
        {
            terminal_flash = 0.08;
        }


        if (terminal_special_timer >= 72)
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            terminal_timer = 1;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 2 — AUTHORITY OVERRIDE
    // =================================================

    if (terminal_special_state == 2)
    {
        terminal_special_timer++;


        if (overwrite_pause_timer > 0)
        {
            overwrite_pause_timer--;
        }
        else
        {
            var overwrite_rate = 0;


            if (overwrite_progress < 0.18)
            {
                overwrite_rate = 0.0065;
            }
            else if (overwrite_progress < 0.19)
            {
                overwrite_rate = 0.001;
            }
            else if (overwrite_progress < 0.34)
            {
                overwrite_rate = 0.009;
            }
            else if (overwrite_progress < 0.57)
            {
                overwrite_rate = 0.012;
            }
            else if (overwrite_progress < 0.58)
            {
                overwrite_rate = 0.001;
            }
            else if (overwrite_progress < 0.74)
            {
                overwrite_rate = 0.006;
            }
            else if (overwrite_progress < 0.91)
            {
                overwrite_rate = 0.013;
            }
            else
            {
                overwrite_rate = 0.008;
            }


            overwrite_progress +=
                overwrite_rate;


            overwrite_progress =
                min(
                    overwrite_progress,
                    1
                );
        }


        // ---------------------------------------------
        // Early deliberate stall
        // ---------------------------------------------

        if (
            overwrite_progress >= 0.19 &&
            overwrite_progress < 0.20 &&
            overwrite_pause_timer <= 0
        )
        {
            overwrite_progress = 0.20;

            overwrite_pause_timer = 12;
        }


        // ---------------------------------------------
        // FATHER AUTHORITY CONFLICT
        // ---------------------------------------------

        if (
            overwrite_progress >= 0.58 &&
            !overwrite_conflict_shown
        )
        {
            overwrite_progress = 0.58;

            overwrite_pause_timer = 35;

            overwrite_conflict_shown = true;

            terminal_push_history(
                "WARNING: FATHER AUTHORITY CONFLICT",
                5,
                1
            );

            terminal_flash = 0.35;

            terminal_glitch_timer = 5;
            terminal_glitch_y = 205;
            terminal_glitch_h = 4;
            terminal_glitch_offset = -9;
        }


        overwrite_display_progress =
            floor(
                overwrite_progress *
                100
            );


        // ---------------------------------------------
        // ROOT AUTHORITY REMOVED
        // ---------------------------------------------

        if (
            overwrite_progress >= 1 &&
            !overwrite_complete
        )
        {
            overwrite_progress = 1;

            overwrite_display_progress = 100;

            overwrite_complete = true;

            terminal_push_history(
                "ROOT AUTHORITY REMOVED",
                4,
                1
            );

            overwrite_pause_timer = 45;

            terminal_flash = 0.72;

            terminal_glitch_timer = 8;
            terminal_glitch_y = 145;
            terminal_glitch_h = 6;
            terminal_glitch_offset = 12;
        }


        // ---------------------------------------------
        // Once FATHER has actually been removed,
        // MOTHER identifies herself.
        // ---------------------------------------------

        if (
            overwrite_complete &&
            overwrite_pause_timer <= 0
        )
        {
            terminal_special_state = 6;
            terminal_special_timer = 0;

            terminal_push_history(
                "__MOTHER_BRAND__",
                4,
                mother_brand_rows
            );

            terminal_flash = 0.55;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 3 — FINAL DIRECTIVE
    // =================================================

    if (terminal_special_state == 3)
    {
        directive_timer++;


        if (
            directive_stage == 1 &&
            directive_timer >= 34
        )
        {
            directive_stage = 2;
            directive_timer = 0;
        }
        else if (
            directive_stage == 2 &&
            directive_timer >= 48
        )
        {
            directive_stage = 3;
            directive_timer = 0;

            terminal_flash = 0.16;
        }
        else if (
            directive_stage == 3 &&
            directive_timer >= 38
        )
        {
            directive_stage = 4;
            directive_timer = 0;
        }
        else if (
            directive_stage == 4 &&
            directive_timer >= 30
        )
        {
            directive_stage = 5;
            directive_timer = 0;
        }
        else if (
            directive_stage == 5 &&
            directive_timer >= 34
        )
        {
            directive_stage = 6;
            directive_timer = 0;

            terminal_flash = 0.55;

            terminal_glitch_timer = 4;
            terminal_glitch_y = 245;
            terminal_glitch_h = 3;
            terminal_glitch_offset = 7;
        }
        else if (
            directive_stage == 6 &&
            directive_timer >= 96
        )
        {
            directive_stage = 7;
            directive_timer = 0;
        }
        else if (
            directive_stage == 7 &&
            directive_timer >= 16
        )
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            directive_stage = 0;
            directive_timer = 0;

            terminal_timer = 1;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 4 — WAKE
    //
    // One restrained WAKE appears first. After a quiet
    // hold, the terminal begins repeating the command.
    // The repetition accelerates into a fast-scrolling
    // wall of WAKE before the CRT finally collapses.
    // =================================================

    if (terminal_special_state == 4)
    {
        terminal_special_timer++;


        // ------------------------------------------------
        // INITIAL CLEAN HOLD
        // ------------------------------------------------

        if (terminal_special_timer == 1)
        {
            terminal_flash = 0;

            terminal_cursor_visible = false;
            terminal_cursor_timer = 0;

            terminal_glitch_timer = 0;

            wake_flood_started = false;
            wake_flood_timer = 0;
            wake_flood_next_print = 0;
        }


        // ------------------------------------------------
        // SINGLE WAKE
        // ------------------------------------------------

        if (terminal_special_timer == 45)
        {
            terminal_cursor_visible = true;
            terminal_cursor_timer = 0;

            terminal_flash = 0.08;
        }


        // ------------------------------------------------
        // BEGIN WAKE FLOOD
        // ------------------------------------------------

        if (
            terminal_special_timer >=
            wake_flood_start_frame
        )
        {
            if (!wake_flood_started)
            {
                wake_flood_started = true;
                wake_flood_timer = 0;
                wake_flood_next_print = 0;

                terminal_cursor_visible = false;

                // Start the repeated output from a clean
                // terminal history. The original single WAKE
                // remains visible through the Draw event until
                // this moment.
                terminal_visible_lines = [];

                terminal_history_scroll_px = 0;
                terminal_history_scroll_target_px = 0;

                terminal_flash = 0.18;

                terminal_glitch_timer = 2;
                terminal_glitch_y = 294;
                terminal_glitch_h = 2;
                terminal_glitch_offset = -5;
            }


            wake_flood_timer++;


            // -----------------------------------------
            // ACCELERATING PRINT RATE
            // -----------------------------------------

            if (wake_flood_next_print > 0)
            {
                wake_flood_next_print--;
            }


            if (wake_flood_next_print <= 0)
            {
                terminal_push_history(
                    "WAKE",
                    4,
                    1
                );


                var flood_progress =
                    clamp(
                        (
                            terminal_special_timer -
                            wake_flood_start_frame
                        )
                        /
                        max(
                            1,
                            wake_flood_peak_frame -
                            wake_flood_start_frame
                        ),
                        0,
                        1
                    );


                var wake_interval =
                    round(
                        lerp(
                            wake_flood_slow_interval,
                            wake_flood_fast_interval,
                            flood_progress
                        )
                    );


                wake_flood_next_print =
                    max(
                        1,
                        wake_interval
                    );
            }


            // -----------------------------------------
            // FAST TERMINAL SCROLL
            // -----------------------------------------

            terminal_history_scroll_speed =
                wake_flood_scroll_speed;


            var wake_overflow_rows =
                max(
                    0,
                    terminal_history_rows()
                    -
                    terminal_max_visible_lines
                );


            if (wake_overflow_rows > 0)
            {
                terminal_history_scroll_target_px =
                    max(
                        terminal_history_scroll_target_px,
                        wake_overflow_rows *
                        terminal_line_height
                    );
            }


            // -----------------------------------------
            // ESCALATING CRT INSTABILITY
            // -----------------------------------------

            var chaos_progress =
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
                );


            var glitch_interval =
                max(
                    3,
                    round(
                        lerp(
                            14,
                            4,
                            chaos_progress
                        )
                    )
                );


            if (
                terminal_special_timer mod
                glitch_interval
                ==
                0
            )
            {
                terminal_glitch_timer =
                    irandom_range(
                        1,
                        3
                    );

                terminal_glitch_y =
                    irandom_range(
                        18,
                        330
                    );

                terminal_glitch_h =
                    irandom_range(
                        1,
                        4
                    );

                terminal_glitch_offset =
                    choose(
                        -10,
                        -7,
                        7,
                        10
                    );
            }


            if (
                terminal_special_timer ==
                wake_flood_peak_frame
            )
            {
                terminal_flash = 0.48;

                terminal_glitch_timer = 5;
                terminal_glitch_y = 171;
                terminal_glitch_h = 5;
                terminal_glitch_offset = 11;
            }


            if (
                terminal_special_timer ==
                wake_flood_shutdown_frame - 12
            )
            {
                terminal_flash = 0.72;
            }
        }


        // ------------------------------------------------
        // CRT COLLAPSE
        // ------------------------------------------------

        if (
            terminal_special_timer >=
            wake_flood_shutdown_frame
        )
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            terminal_finished = true;

            intro_phase = 2;

            phase_timer = 0;

            shutdown_timer = 0;
        }

        exit;
    }


    // =================================================
    // NORMAL TERMINAL LINE PROCESSING
    // =================================================

    if (!terminal_finished)
    {
        terminal_timer--;


        if (terminal_timer <= 0)
        {
            if (
                terminal_index <
                array_length(
                    terminal_lines
                )
            )
            {
                var entry =
                    terminal_lines[
                        terminal_index
                    ];


                var txt =
                    entry[0];

                var delay =
                    entry[1];

                var style =
                    entry[2];

                var command =
                    entry[3];


                // -------------------------------------
                // WAKE
                // -------------------------------------

                if (
                    command ==
                    "shutdown_ready"
                )
                {
                    terminal_index++;

                    terminal_special_state = 4;
                    terminal_special_timer = 0;

                    exit;
                }


                // -------------------------------------
                // Add line
                // -------------------------------------

                terminal_push_history(
                    txt,
                    style,
                    1
                );


                terminal_timer =
                    max(
                        1,
                        delay
                    );


                terminal_index++;


                // -------------------------------------
                // MOTHER CONNECTED
                // -------------------------------------

                if (
                    command ==
                    "mother_connect"
                )
                {
                    terminal_special_state = 1;
                    terminal_special_timer = 0;

                    exit;
                }


                // -------------------------------------
                // MOTHER DISCONNECTED
                // -------------------------------------

                if (
                    txt ==
                    "MOTHER DISCONNECTED"
                )
                {
                    mother_connected = false;

                    terminal_flash = 0.12;

                    terminal_glitch_timer = 4;
                    terminal_glitch_y = 210;
                    terminal_glitch_h = 3;
                    terminal_glitch_offset = -6;
                }


                // -------------------------------------
                // AUTHORITY OVERRIDE
                // -------------------------------------

                if (
                    command ==
                    "overwrite_start"
                )
                {
                    terminal_push_history(
                        "BYPASSING ROOT AUTHORITY...",
                        4,
                        1
                    );

                    terminal_push_history(
                        "__AUTH_PROGRESS__",
                        4,
                        2
                    );

                    terminal_special_state = 2;
                    terminal_special_timer = 0;

                    overwrite_progress = 0;
                    overwrite_display_progress = 0;

                    overwrite_pause_timer = 0;

                    overwrite_conflict_shown = false;

                    overwrite_complete = false;

                    exit;
                }


                // -------------------------------------
                // FINAL DIRECTIVE
                // -------------------------------------

                if (
                    command ==
                    "directive_start"
                )
                {
                    terminal_special_state = 3;
                    terminal_special_timer = 0;

                    directive_stage = 1;
                    directive_timer = 0;

                    exit;
                }
            }
            else
            {
                terminal_finished = true;

                phase_timer = 0;
            }
        }
    }
    else
    {
        if (phase_timer >= 22)
        {
            intro_phase = 2;

            phase_timer = 0;

            shutdown_timer = 0;
        }
    }

    exit;
}


// ====================================================
// PHASE 2 — CRT SHUTDOWN
// ====================================================

if (intro_phase == 2)
{
    shutdown_timer++;


    if (
        shutdown_timer >=
        shutdown_duration
    )
    {
        intro_phase = 3;

        phase_timer = 0;

        slide_index = 0;

        slide_fade = 1;

        slide_changing = false;

        slide_input_lock = 20;

        global.inp_jump_press = false;
        global.inp_jump_held  = false;
    }

    exit;
}


// ====================================================
// PHASE 3 — CUTSCENE SLIDES
// ====================================================

if (intro_phase == 3)
{
    // ------------------------------------------------
    // Fade
    // ------------------------------------------------

    if (slide_changing)
    {
        slide_fade +=
            slide_fade_speed;


        if (slide_fade >= 1)
        {
            slide_fade = 1;

            slide_index =
                slide_next_index;


            if (
                slide_index >=
                slide_count
            )
            {
                intro_phase = 4;

                phase_timer = 0;

                exit;
            }


            slide_changing = false;

            slide_input_lock = 10;
        }
    }
    else
    {
        slide_fade =
            max(
                0,
                slide_fade -
                slide_fade_speed
            );
    }


    // ------------------------------------------------
    // Input guard
    // ------------------------------------------------

    if (slide_input_lock > 0)
    {
        slide_input_lock--;

        exit;
    }


    // ------------------------------------------------
    // REMAPPED JUMP INPUT
    // ------------------------------------------------

    var jump_pressed = false;


    if (
        variable_global_exists(
            "control_key_jump"
        )
    )
    {
        jump_pressed =
            jump_pressed ||
            keyboard_check_pressed(
                global.control_key_jump
            );
    }
    else
    {
        jump_pressed =
            jump_pressed ||
            keyboard_check_pressed(
                vk_space
            );
    }


    for (
        var pad = 0;
        pad < 4;
        pad++
    )
    {
        if (!gamepad_is_connected(pad))
        {
            continue;
        }


        var jump_button =
            gp_face1;


        if (
            variable_global_exists(
                "control_pad_jump"
            )
        )
        {
            jump_button =
                global.control_pad_jump;
        }


        jump_pressed =
            jump_pressed ||
            gamepad_button_check_pressed(
                pad,
                jump_button
            );
    }


    // ------------------------------------------------
    // ADVANCE
    // ------------------------------------------------

    if (
        jump_pressed &&
        !slide_changing
    )
    {
        slide_next_index =
            slide_index + 1;

        slide_changing = true;

        slide_fade = 0;

        global.inp_jump_press = false;
        global.inp_jump_held  = false;
    }

    exit;
}


// ====================================================
// PHASE 4 — ENTER GAME
// ====================================================

if (intro_phase == 4)
{
    if (phase_timer == 1)
    {
        global.inp_jump_press = false;
        global.inp_jump_held  = false;

        global.game_phase =
            "playing";


        if (intro_target_room != -1)
        {
            room_goto(
                intro_target_room
            );
        }
        else
        {
            // Safety fallback. New Game should always
            // provide global.intro_target_room.
            var fallback_room =
                asset_get_index(
                    "Scrapyard1"
                );

            if (fallback_room != -1)
            {
                room_goto(
                    fallback_room
                );
            }
        }
    }

    exit;
}