/// oStartupController — Step

// ====================================================
// KEEP GUI SIZE FIXED
// ====================================================

if (
    display_get_gui_width() != global.GUI_W ||
    display_get_gui_height() != global.GUI_H
)
{
    display_set_gui_size(
        global.GUI_W,
        global.GUI_H
    );
}


// ====================================================
// PLACEHOLDER SAVE ICON ANIMATION
// ====================================================

save_icon_rotation =
    (
        save_icon_rotation +
        save_icon_speed
    )
    mod 360;


// ====================================================
// READ CONFIRM INPUT
// ====================================================

var keyboard_confirm_held =
    keyboard_check(vk_space) ||
    keyboard_check(vk_enter);

var keyboard_confirm_pressed =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);

var gamepad_confirm_held = false;
var gamepad_confirm_pressed = false;

for (var pad = 0; pad < 4; pad++)
{
    if (!gamepad_is_connected(pad))
    {
        continue;
    }

    if (gamepad_button_check(pad, gp_face1))
    {
        gamepad_confirm_held = true;
    }

    if (gamepad_button_check_pressed(pad, gp_face1))
    {
        gamepad_confirm_pressed = true;
    }
}

// Support the project's central input struct as well.
var project_confirm_held = false;
var project_confirm_pressed = false;

if (
    variable_global_exists("input") &&
    is_struct(global.input)
)
{
    if (variable_struct_exists(global.input, "confirm"))
    {
        project_confirm_held =
            global.input.confirm;
    }

    if (variable_struct_exists(global.input, "confirm_pressed"))
    {
        project_confirm_pressed =
            global.input.confirm_pressed;
    }
}

var confirm_held =
    keyboard_confirm_held ||
    gamepad_confirm_held ||
    project_confirm_held;

var confirm_pressed =
    keyboard_confirm_pressed ||
    gamepad_confirm_pressed ||
    project_confirm_pressed;


// ====================================================
// REQUIRE AN INITIAL RELEASE
// ====================================================

if (waiting_for_release)
{
    if (!confirm_held)
    {
        waiting_for_release = false;
        input_armed = true;
    }

    confirm_pressed = false;
}


// ====================================================
// FADE STATE
// ====================================================

switch (fade_state)
{
    // ------------------------------------------------
    // Fade current screen in
    // ------------------------------------------------
    case 0:
    {
        fade_alpha += fade_speed;

        if (fade_alpha >= 1)
        {
            fade_alpha = 1;
            fade_state = 1;
            screen_timer = screen_hold_frames;
        }

        break;
    }


    // ------------------------------------------------
    // Hold current screen
    // ------------------------------------------------
    case 1:
    {
        if (screen_timer > 0)
        {
            screen_timer--;
        }

        // Pressing confirm skips only the current screen.
        if (
            input_armed &&
            confirm_pressed
        )
        {
            screen_timer = 0;
        }

        if (screen_timer <= 0)
        {
            fade_state = 2;
        }

        break;
    }


    // ------------------------------------------------
    // Fade current screen out
    // ------------------------------------------------
    case 2:
    {
        fade_alpha -= fade_speed;

        if (fade_alpha <= 0)
        {
            fade_alpha = 0;

            // Company logo completed.
            if (startup_screen == 0)
            {
                startup_screen = 1;

                fade_state = 0;
                screen_timer = screen_hold_frames;

                // Require release before the second
                // screen can be skipped.
                waiting_for_release = true;
                input_armed = false;
            }
            // Save warning completed.
            else if (startup_screen == 1)
            {
                startup_screen = 2;

                // Briefly protect the main menu from
                // receiving this same confirm press.
                global.startup_menu_input_lock = 12;

                if (main_menu_room != -1)
                {
                    room_goto(main_menu_room);
                }
                else
                {
                    show_debug_message(
                        "STARTUP ERROR: MainMenuBackground was not found."
                    );
                }
            }
        }

        break;
    }
}