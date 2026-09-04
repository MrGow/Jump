/// oIntroCutsceneController — Step


phase_timer++;
terminal_time++;


// ====================================================
// TERMINAL VISUAL FLAIR
// ====================================================

// Before MOTHER connects, the dying local system has
// more unstable brightness.
//
// Once MOTHER is connected, the image becomes noticeably
// more stable.
if (mother_connected)
{
    terminal_flicker =
        0.985 +
        random(0.015);
}
else
{
    terminal_flicker =
        0.94 +
        random(0.06);


    if (irandom(110) == 0)
    {
        terminal_flicker =
            random_range(
                0.68,
                0.82
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
//
// Less frequent while MOTHER has control.
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
    }

    exit;
}


// ====================================================
// PHASE 1 — TERMINAL
// ====================================================

if (intro_phase == 1)
{
    // =================================================
    // SPECIAL STATE 1 — MOTHER CONNECTED
    // =================================================

    if (terminal_special_state == 1)
    {
        terminal_special_timer++;


        // First moment of connection.
        if (terminal_special_timer == 1)
        {
            mother_connected = true;

            terminal_flash = 0.75;

            terminal_glitch_timer = 5;
            terminal_glitch_y = 120;
            terminal_glitch_h = 5;
            terminal_glitch_offset = 10;
        }


        // A second small cyan pulse.
        if (terminal_special_timer == 24)
        {
            terminal_flash = 0.30;
        }


        // And another subtle pulse.
        if (terminal_special_timer == 48)
        {
            terminal_flash = 0.20;
        }


        // Hold MOTHER CONNECTED on screen long enough
        // that the player definitely registers it.
        if (terminal_special_timer >= 72)
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            terminal_timer = 1;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 2 — DIRECTIVE OVERWRITE
    // =================================================

    if (terminal_special_state == 2)
    {
        terminal_special_timer++;


        // ---------------------------------------------
        // Irregular progress movement
        // ---------------------------------------------

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
        // Small deliberate stalls
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


        if (
            overwrite_progress >= 0.58 &&
            !overwrite_conflict_shown
        )
        {
            overwrite_progress = 0.58;

            overwrite_pause_timer = 35;

            overwrite_conflict_shown = true;

            terminal_flash = 0.35;

            terminal_glitch_timer = 5;
            terminal_glitch_y = 205;
            terminal_glitch_h = 4;
            terminal_glitch_offset = -9;
        }


        // ---------------------------------------------
        // Displayed percentage
        // ---------------------------------------------

        overwrite_display_progress =
            floor(
                overwrite_progress *
                100
            );


        // ---------------------------------------------
        // Completion
        // ---------------------------------------------

        if (
            overwrite_progress >= 1 &&
            !overwrite_complete
        )
        {
            overwrite_progress = 1;

            overwrite_display_progress = 100;

            overwrite_complete = true;

            overwrite_pause_timer = 35;

            terminal_flash = 0.65;

            terminal_glitch_timer = 7;
            terminal_glitch_y = 145;
            terminal_glitch_h = 6;
            terminal_glitch_offset = 12;
        }


        if (
            overwrite_complete &&
            overwrite_pause_timer <= 0
        )
        {
            terminal_special_state = 0;
            terminal_special_timer = 0;

            terminal_timer = 1;
        }

        exit;
    }


    // =================================================
    // SPECIAL STATE 3 — FINAL DIRECTIVE
    // =================================================

    if (terminal_special_state == 3)
    {
        directive_timer++;


        // ---------------------------------------------
        // SOURCE: MOTHER
        // ---------------------------------------------

        if (
            directive_stage == 1 &&
            directive_timer >= 34
        )
        {
            directive_stage = 2;
            directive_timer = 0;
        }


        // ---------------------------------------------
        // TARGET: FATHER
        // ---------------------------------------------

        else if (
            directive_stage == 2 &&
            directive_timer >= 48
        )
        {
            directive_stage = 3;
            directive_timer = 0;

            terminal_flash = 0.16;
        }


        // ---------------------------------------------
        // PRIORITY: ABSOLUTE
        // ---------------------------------------------

        else if (
            directive_stage == 3 &&
            directive_timer >= 38
        )
        {
            directive_stage = 4;
            directive_timer = 0;
        }


        // ---------------------------------------------
        // DIRECTIVE:
        // ---------------------------------------------

        else if (
            directive_stage == 4 &&
            directive_timer >= 30
        )
        {
            directive_stage = 5;
            directive_timer = 0;
        }


        // ---------------------------------------------
        // Blank / cursor suspense
        // ---------------------------------------------

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


        // ---------------------------------------------
        // KILL FATHER
        //
        // Hold for around 1.6 seconds at 60 FPS.
        // ---------------------------------------------

        else if (
            directive_stage == 6 &&
            directive_timer >= 96
        )
        {
            directive_stage = 7;
            directive_timer = 0;
        }


        // ---------------------------------------------
        // Finish special block
        // ---------------------------------------------

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
                // Add visible line
                // -------------------------------------

                array_push(
                    terminal_visible_lines,
                    [
                        txt,
                        style
                    ]
                );


                // Keep only recent lines.
                while (
                    array_length(
                        terminal_visible_lines
                    )
                    >
                    terminal_max_visible_lines
                )
                {
                    array_delete(
                        terminal_visible_lines,
                        0,
                        1
                    );
                }


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
                // DIRECTIVE OVERWRITE
                // -------------------------------------

                if (
                    command ==
                    "overwrite_start"
                )
                {
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


                // -------------------------------------
                // WAKE / END
                // -------------------------------------

                if (
                    command ==
                    "shutdown_ready"
                )
                {
                    terminal_finished = true;

                    phase_timer = 0;
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
    // Fade in / out
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


    // Keyboard.
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


    // Controller.
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
    }


    if (phase_timer >= 8)
    {
        global.game_phase =
            "playing";


        global.inp_jump_press =
            false;

        global.inp_jump_held =
            false;


        if (
            intro_target_room != -1
        )
        {
            room_goto(
                intro_target_room
            );
        }
    }
}