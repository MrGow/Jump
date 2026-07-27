/// oAdministratorTalkScreen — Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// READ MODE DIRECTLY FROM EDITOR VARIABLE
//
// We deliberately read this every frame instead of
// caching it in Create.
//
// So:
//
// typewriter
// TYPEWRITER
// Typewriter
//
// all work.
//
// Same for scroll.
// ====================================================

var mode =
    string_lower(
        string(
            screen_mode
        )
    );


// ====================================================
// FIND PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


if (p == noone)
{
    exit;
}


// ====================================================
// PLAYER DETECTION
// ====================================================

if (!activated)
{
    var dist =
        point_distance(
            x,
            y,
            p.x,
            p.y
        );


    if (
        dist <=
        trigger_distance
    )
    {
        activated = true;

        screen_state = 1;

        boot_line_timer =
            boot_line_frames;

        boot_line_progress = 0;

        target_screen_alpha = 1;


        // --------------------------------------------
        // Reset internal behaviours
        // --------------------------------------------

        scroll_x = 0;

        display_text = "";

        char_index = 0;

        finished = false;


        // --------------------------------------------
        // Optional boot sound
        // --------------------------------------------

        if (
            snd_boot != -1 &&
            audio_group_is_loaded(
                audiogroupsfx
            )
        )
        {
            scr_play_sfx(
                snd_boot,
                boot_sfx_gain,
                random_range(
                    0.98,
                    1.02
                )
            );
        }
    }
}


// ====================================================
// SCREEN WAKE BRIGHTNESS
// ====================================================

screen_alpha =
    lerp(
        screen_alpha,
        target_screen_alpha,
        0.14
    );


if (!activated)
{
    exit;
}


// ====================================================
// STATE MACHINE
// ====================================================

switch (screen_state)
{
    // =================================================
    // 1 — BOOT LINE
    // =================================================

    case 1:
    {
        boot_line_timer--;


        boot_line_progress =
            1 -
            (
                boot_line_timer /
                max(
                    1,
                    boot_line_frames
                )
            );


        boot_line_progress =
            clamp(
                boot_line_progress,
                0,
                1
            );


        if (
            boot_line_timer <= 0
        )
        {
            screen_state = 2;

            boot_data_timer =
                boot_data_frames;

            boot_data_refresh_timer = 0;

            boot_data_text =
                make_boot_data();
        }
    }
    break;


    // =================================================
    // 2 — BOOT DATA
    // =================================================

    case 2:
    {
        boot_data_timer--;

        boot_data_refresh_timer--;


        if (
            boot_data_refresh_timer <= 0
        )
        {
            boot_data_refresh_timer =
                boot_data_refresh;

            boot_data_text =
                make_boot_data();
        }


        if (
            boot_data_timer <= 0
        )
        {
            screen_state = 3;

            boot_clear_timer =
                boot_clear_frames;

            boot_data_text = "";
        }
    }
    break;


    // =================================================
    // 3 — BLANK PAUSE
    // =================================================

    case 3:
    {
        boot_clear_timer--;


        if (
            boot_clear_timer <= 0
        )
        {
            screen_state = 4;


            // ----------------------------------------
            // TYPEWRITER START
            // ----------------------------------------

            if (
                mode ==
                "typewriter"
            )
            {
                display_text = "";

                char_index = 0;
                type_timer = 0;

                cursor_timer = 0;
                cursor_visible = true;

                finished = false;
            }


            // ----------------------------------------
            // SCROLL START
            // ----------------------------------------

            else if (
                mode ==
                "scroll"
            )
            {
                scroll_x = 0;
            }
        }
    }
    break;


    // =================================================
    // 4 — ACTIVE
    // =================================================

    case 4:
    {
        // =============================================
        // TYPEWRITER
        // =============================================

        if (
            mode ==
            "typewriter"
        )
        {
            if (!finished)
            {
                type_timer--;


                if (
                    type_timer <= 0
                )
                {
                    type_timer =
                        type_delay;

                    char_index++;


                    if (
                        char_index >=
                        string_length(
                            message
                        )
                    )
                    {
                        char_index =
                            string_length(
                                message
                            );

                        finished = true;

                        screen_state = 5;
                    }


                    display_text =
                        string_copy(
                            message,
                            1,
                            char_index
                        );


                    // --------------------------------
                    // Optional typing sound
                    // --------------------------------

                    if (
                        snd_type != -1 &&
                        audio_group_is_loaded(
                            audiogroupsfx
                        )
                    )
                    {
                        var current_char =
                            string_char_at(
                                message,
                                char_index
                            );


                        if (
                            current_char != " " &&
                            current_char != "#"
                        )
                        {
                            scr_play_sfx(
                                snd_type,
                                type_sfx_gain,
                                random_range(
                                    0.98,
                                    1.03
                                )
                            );
                        }
                    }
                }
            }
        }


        // =============================================
        // SCROLL
        //
        // Extremely simple:
        //
        // every frame:
        //
        // 0
        // -1
        // -2
        // -3
        //
        // etc.
        // =============================================

        else if (
            mode ==
            "scroll"
        )
        {
            scroll_x -=
                scroll_speed;


            // ----------------------------------------
            // Wrap after one complete spacing interval
            // ----------------------------------------

            var spacing =
                max(
                    8,
                    scroll_spacing
                );


            while (
                scroll_x <=
                -spacing
            )
            {
                scroll_x +=
                    spacing;
            }
        }
    }
    break;


    // =================================================
    // 5 — FINISHED TYPEWRITER
    // =================================================

    case 5:
    {
        // Cursor continues below.
    }
    break;
}


// ====================================================
// CURSOR
// ====================================================

if (
    mode ==
    "typewriter"
    &&
    (
        screen_state == 4 ||
        screen_state == 5
    )
)
{
    cursor_timer++;


    if (
        cursor_timer >=
        cursor_speed
    )
    {
        cursor_timer = 0;

        cursor_visible =
            !cursor_visible;
    }
}