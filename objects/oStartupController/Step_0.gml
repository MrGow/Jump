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

    if (
        gamepad_button_check(
            pad,
            gp_face1
        )
    )
    {
        gamepad_confirm_held = true;
    }

    if (
        gamepad_button_check_pressed(
            pad,
            gp_face1
        )
    )
    {
        gamepad_confirm_pressed = true;
    }
}


// ----------------------------------------------------
// Support current global input flags
// ----------------------------------------------------

var project_confirm_held = false;
var project_confirm_pressed = false;

if (variable_global_exists("inp_jump_held"))
{
    project_confirm_held =
        global.inp_jump_held;
}

if (variable_global_exists("inp_jump_press"))
{
    project_confirm_pressed =
        global.inp_jump_press;
}


// ----------------------------------------------------
// Support newer global.input struct if present
// ----------------------------------------------------

if (
    variable_global_exists("input") &&
    is_struct(global.input)
)
{
    if (
        variable_struct_exists(
            global.input,
            "confirm"
        )
    )
    {
        project_confirm_held =
            project_confirm_held ||
            global.input.confirm;
    }

    if (
        variable_struct_exists(
            global.input,
            "confirm_pressed"
        )
    )
    {
        project_confirm_pressed =
            project_confirm_pressed ||
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
// REQUIRE RELEASE BEFORE ACCEPTING INPUT
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
// FADE STATE MACHINE
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

            screen_timer =
                screen_hold_frames;
        }
    }
    break;


    // ------------------------------------------------
    // Hold current screen
    // ------------------------------------------------
    case 1:
    {
        if (screen_timer > 0)
        {
            screen_timer--;
        }

        // A press skips only the current splash.
        if (
            input_armed &&
            confirm_pressed
        )
        {
            screen_timer = 0;

            // Do not let this held press instantly skip
            // the following screen too.
            input_armed = false;
            waiting_for_release = true;
        }

        if (screen_timer <= 0)
        {
            fade_state = 2;
        }
    }
    break;


    // ------------------------------------------------
    // Fade current screen out
    // ------------------------------------------------
    case 2:
    {
        fade_alpha -= fade_speed;

        if (fade_alpha <= 0)
        {
            fade_alpha = 0;

            // ----------------------------------------
            // Company logo finished
            // ----------------------------------------
            if (startup_screen == 0)
            {
                startup_screen = 1;

                fade_state = 0;

                screen_timer =
                    screen_hold_frames;

                input_armed = false;
                waiting_for_release = true;
            }

            // ----------------------------------------
            // Save warning finished
            // ----------------------------------------
            else if (startup_screen == 1)
            {
                startup_screen = 2;

                // Clear all known confirm states before
                // entering the menu.
                if (
                    variable_global_exists(
                        "inp_jump_press"
                    )
                )
                {
                    global.inp_jump_press = false;
                }

                if (
                    variable_global_exists(
                        "inp_jump_held"
                    )
                )
                {
                    global.inp_jump_held = false;
                }

                if (
                    variable_global_exists("input") &&
                    is_struct(global.input)
                )
                {
                    if (
                        variable_struct_exists(
                            global.input,
                            "confirm"
                        )
                    )
                    {
                        global.input.confirm = false;
                    }

                    if (
                        variable_struct_exists(
                            global.input,
                            "confirm_pressed"
                        )
                    )
                    {
                        global.input.confirm_pressed = false;
                    }
                }

                // Protect the main menu for 12 frames.
                global.startup_menu_input_lock = 12;

                if (main_menu_room != -1)
                {
                    room_goto(
                        main_menu_room
                    );
                }
                else
                {
                    show_debug_message(
                        "STARTUP ERROR: MainMenuBackground was not found."
                    );
                }
            }
        }
    }
    break;
}