/// oPauseMenu — Step

scr_settings_init();


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_ui_navigation"))
{
    snd_ui_navigation =
        asset_get_index("UIMenuNavigation1");
}

if (!variable_instance_exists(id, "snd_ui_dial"))
{
    snd_ui_dial =
        asset_get_index("UIDialMovement1");
}

if (!variable_instance_exists(id, "snd_ui_confirm"))
{
    snd_ui_confirm =
        asset_get_index("UIConfirmation1");
}

if (!variable_instance_exists(id, "snd_ui_settings_cycle"))
{
    snd_ui_settings_cycle =
        asset_get_index("UISettingsCycle");
}

if (!variable_instance_exists(id, "ui_navigation_gain"))
{
    ui_navigation_gain = 1.0;
}

if (!variable_instance_exists(id, "ui_dial_gain"))
{
    ui_dial_gain = 1.0;
}

if (!variable_instance_exists(id, "ui_confirm_gain"))
{
    ui_confirm_gain = 1.0;
}

if (!variable_instance_exists(id, "ui_settings_cycle_gain"))
{
    ui_settings_cycle_gain = 1.0;
}

if (!variable_instance_exists(id, "ui_navigation_pitch_low"))
{
    ui_navigation_pitch_low = 0.97;
}

if (!variable_instance_exists(id, "ui_navigation_pitch_high"))
{
    ui_navigation_pitch_high = 1.03;
}

if (!variable_instance_exists(id, "controls_row"))
{
    controls_row = 0;
}

if (!variable_instance_exists(id, "controls_column"))
{
    controls_column = 0;
}

if (!variable_instance_exists(id, "controls_rebinding"))
{
    controls_rebinding = false;
}

if (!variable_instance_exists(id, "controls_rebind_device"))
{
    controls_rebind_device = "";
}

if (!variable_instance_exists(id, "controls_rebind_action"))
{
    controls_rebind_action = "";
}

if (!variable_instance_exists(id, "controls_rebind_ignore_frames"))
{
    controls_rebind_ignore_frames = 0;
}

if (!variable_instance_exists(id, "controls_message"))
{
    controls_message = "";
}

if (!variable_instance_exists(id, "controls_message_timer"))
{
    controls_message_timer = 0;
}

scr_controls_ensure_defaults();


// ====================================================
// KEEP TRANSIENT PLAYER ANIMATIONS CANCELLED WHILE PAUSED
// ====================================================

if (instance_exists(oPlayer))
{
    with (oPlayer)
    {
        prev_jump_h = true;

        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;

        if (
            variable_instance_exists(
                id,
                "jump_charge_sfx_last"
            )
        )
        {
            jump_charge_sfx_last = 0;
        }

        if (
            variable_instance_exists(
                id,
                "charge_grace"
            )
        )
        {
            charge_grace = 0;
        }

        if (
            variable_instance_exists(
                id,
                "support_grace"
            )
        )
        {
            support_grace = 0;
        }

        if (
            variable_instance_exists(
                id,
                "charge_start_lock"
            )
        )
        {
            charge_start_lock = 0;
        }

        if (
            variable_instance_exists(
                id,
                "edge_charge_fail"
            )
        )
        {
            edge_charge_fail = 0;
        }

        if (
            state == "jump_charge" ||
            state == "landing"
        )
        {
            state = "idle";

            if (
                variable_instance_exists(
                    id,
                    "jump_pose_timer"
                )
            )
            {
                jump_pose_timer = 0;
            }
        }
    }
}


// ====================================================
// MENU INPUT
//
// Input comes from oInput.
// Keyboard:
// - Up/Down/W/S = navigate
// - Left/Right/A/D = adjust
// - Space/Enter = confirm
// - Escape/Backspace = back
//
// Controller:
// - D-pad = navigate/adjust
// - A / gp_face1 = confirm
// - B / gp_face2 = back
// ====================================================

var up =
    variable_global_exists("inp_menu_up_press") &&
    global.inp_menu_up_press;

var down =
    variable_global_exists("inp_menu_down_press") &&
    global.inp_menu_down_press;

var left =
    variable_global_exists("inp_menu_left_press") &&
    global.inp_menu_left_press;

var right =
    variable_global_exists("inp_menu_right_press") &&
    global.inp_menu_right_press;

var confirm =
    variable_global_exists("inp_menu_confirm_press") &&
    global.inp_menu_confirm_press;

// ====================================================
// BACK / PAUSE BUTTON
//
// Read both oInput's exposed actions and the physical
// inputs directly. The direct checks prevent one-frame
// actions being missed because of instance Step order.
//
// In a submenu:
//     Return to the main pause menu.
//
// In the main pause menu:
//     Resume the game.
// ====================================================

var menu_back_pressed =
    (
        variable_global_exists(
            "inp_menu_back_press"
        ) &&
        global.inp_menu_back_press
    )
    ||
    keyboard_check_pressed(
        vk_escape
    )
    ||
    keyboard_check_pressed(
        vk_backspace
    );


var pause_button_pressed =
    (
        variable_global_exists(
            "inp_pause_press"
        ) &&
        global.inp_pause_press
    )
    ||
    keyboard_check_pressed(
        vk_escape
    )
    ||
    keyboard_check_pressed(
        ord("P")
    );


// ----------------------------------------------------
// DIRECT CONTROLLER FALLBACK
// ----------------------------------------------------

var controller_back_pressed =
    false;

var input_controller =
    instance_find(
        oInput,
        0
    );


if (
    input_controller != noone &&
    variable_instance_exists(
        input_controller,
        "gamepad_index"
    )
)
{
    var active_pad =
        input_controller.gamepad_index;


    if (
        active_pad != -1 &&
        gamepad_is_connected(
            active_pad
        )
    )
    {
        controller_back_pressed =
            gamepad_button_check_pressed(
                active_pad,
                gp_face2
            )
            ||
            gamepad_button_check_pressed(
                active_pad,
                gp_start
            );
    }
}


var back =
    menu_back_pressed ||
    pause_button_pressed ||
    controller_back_pressed;


// ----------------------------------------------------
// DIRECT CONTROLLER FALLBACK
// ----------------------------------------------------

var controller_back_pressed =
    false;

var input_controller =
    instance_find(
        oInput,
        0
    );


if (
    input_controller != noone &&
    variable_instance_exists(
        input_controller,
        "gamepad_index"
    )
)
{
    var active_pad =
        input_controller.gamepad_index;


    if (
        active_pad != -1 &&
        gamepad_is_connected(
            active_pad
        )
    )
    {
        controller_back_pressed =
            gamepad_button_check_pressed(
                active_pad,
                gp_face2
            )
            ||
            gamepad_button_check_pressed(
                active_pad,
                gp_start
            );
    }
}


var back =
    menu_back_pressed ||
    pause_button_pressed ||
    controller_back_pressed;

// ====================================================
// LOCAL SOUND HELPERS
// ====================================================

var play_navigation = function()
{
    if (
        snd_ui_navigation != -1 &&
        audio_group_is_loaded(audiogroupui)
    )
    {
        var voice =
            audio_play_sound(
                snd_ui_navigation,
                100,
                false
            );

        audio_sound_gain(
            voice,
            ui_navigation_gain,
            0
        );

        audio_sound_pitch(
            voice,
            random_range(
                ui_navigation_pitch_low,
                ui_navigation_pitch_high
            )
        );
    }
};


var play_dial = function()
{
    if (
        snd_ui_dial != -1 &&
        audio_group_is_loaded(audiogroupui)
    )
    {
        var voice =
            audio_play_sound(
                snd_ui_dial,
                101,
                false
            );

        audio_sound_gain(
            voice,
            ui_dial_gain,
            0
        );
    }
};


var play_confirm = function()
{
    if (
        snd_ui_confirm != -1 &&
        audio_group_is_loaded(audiogroupui)
    )
    {
        var voice =
            audio_play_sound(
                snd_ui_confirm,
                102,
                false
            );

        audio_sound_gain(
            voice,
            ui_confirm_gain,
            0
        );
    }
};


var play_settings_cycle = function()
{
    if (
        snd_ui_settings_cycle != -1 &&
        audio_group_is_loaded(audiogroupui)
    )
    {
        var voice =
            audio_play_sound(
                snd_ui_settings_cycle,
                103,
                false
            );

        audio_sound_gain(
            voice,
            ui_settings_cycle_gain,
            0
        );
    }
};


// ====================================================
// LOCAL RESUME HELPER
// ====================================================

var resume_game = function()
{
    if (instance_exists(oPlayer))
    {
        with (oPlayer)
        {
            respawn_input_lock = 12;
            prev_jump_h = true;

            jump_charging     = false;
            jump_charge       = 0;
            jump_charge_level = 0;

            if (
                variable_instance_exists(
                    id,
                    "jump_charge_sfx_last"
                )
            )
            {
                jump_charge_sfx_last = 0;
            }

            if (
                variable_instance_exists(
                    id,
                    "charge_grace"
                )
            )
            {
                charge_grace = 0;
            }

            if (
                variable_instance_exists(
                    id,
                    "support_grace"
                )
            )
            {
                support_grace = 0;
            }

            if (
                variable_instance_exists(
                    id,
                    "charge_start_lock"
                )
            )
            {
                charge_start_lock = 0;
            }

            if (
                variable_instance_exists(
                    id,
                    "edge_charge_fail"
                )
            )
            {
                edge_charge_fail = 0;
            }

            var charge_sprite =
                asset_get_index(
                    "spriteBotJumpCharge"
                );

            var idle_sprite =
                asset_get_index(
                    "spriteBotIdle"
                );

            if (
                state == "jump_charge" ||
                (
                    charge_sprite != -1 &&
                    sprite_index == charge_sprite
                )
            )
            {
                state = "idle";

                if (idle_sprite != -1)
                {
                    sprite_index = idle_sprite;
                    image_index  = 0;
                    image_speed  = 1;
                }
            }
            else if (image_speed <= 0)
            {
                image_speed = 1;
            }
        }
    }

    // Clear exposed jump input immediately.
    if (variable_global_exists("inp_jump_press"))
    {
        global.inp_jump_press = false;
    }

    if (variable_global_exists("inp_jump_held"))
    {
        global.inp_jump_held = false;
    }

    // Prevent the button used to resume from beginning
    // a jump charge until Space/A has been released.
    if (
        !variable_global_exists(
            "inp_jump_block_until_release"
        )
    )
    {
        global.inp_jump_block_until_release = true;
    }
    else
    {
        global.inp_jump_block_until_release = true;
    }

    // ====================================================
// PREVENT SAME-FRAME PAUSE REOPEN
//
// oGame may run after this menu during the same Step.
// Give it a cooldown before changing back to playing,
// otherwise it sees the same Escape/Start press and
// immediately creates another pause menu.
// ====================================================

if (instance_exists(oGame))
{
    with (oGame)
    {
        if (
            !variable_instance_exists(
                id,
                "pause_toggle_cooldown"
            )
        )
        {
            pause_toggle_cooldown = 0;
        }


        pause_toggle_cooldown =
            max(
                pause_toggle_cooldown,
                15
            );
    }
}


// Clear the exposed one-frame menu actions as well.
if (variable_global_exists("inp_pause_press"))
{
    global.inp_pause_press = false;
}

if (variable_global_exists("inp_menu_back_press"))
{
    global.inp_menu_back_press = false;
}


global.game_phase =
    "playing";

scr_settings_apply_audio_gains();

instance_destroy();
};


// ====================================================
// CONTROLS STATUS MESSAGE
// ====================================================

if (controls_message_timer > 0)
{
    controls_message_timer--;

    if (controls_message_timer <= 0)
    {
        controls_message = "";
    }
}


// ====================================================
// ACTIVE CONTROL REBIND
//
// While listening for a new binding, ordinary menu
// navigation is completely ignored.
// ====================================================

if (controls_rebinding)
{
    if (controls_rebind_ignore_frames > 0)
    {
        controls_rebind_ignore_frames--;
        exit;
    }

    // Escape can always cancel, including when the menu
    // is waiting for a controller that was disconnected.
    if (keyboard_check_pressed(vk_escape))
    {
        controls_rebinding = false;
        controls_message = "Binding Cancelled";
        controls_message_timer = 75;
        play_navigation();
        exit;
    }


    // ------------------------------------------------
    // Keyboard binding
    // ------------------------------------------------

    if (controls_rebind_device == "keyboard")
    {
        if (keyboard_check_pressed(vk_anykey))
        {
            var new_key = keyboard_lastkey;

            // Escape/P/Menu are permanent pause inputs.
            // The horizontal arrow keys are also reserved
            // because they must always control direction.
            var key_reserved =
                new_key == vk_escape ||
                new_key == ord("P") ||
                new_key == vk_left ||
                new_key == vk_right;

            if (key_reserved)
            {
                controls_message = "That Key Is Always Active";
                controls_message_timer = 90;
                play_navigation();
                exit;
            }

            scr_controls_set_keyboard(
                controls_rebind_action,
                new_key
            );

            controls_rebinding = false;
            controls_message = "Control Saved";
            controls_message_timer = 90;
            play_confirm();
            exit;
        }
    }


    // ------------------------------------------------
    // Controller binding
    // ------------------------------------------------

    else if (controls_rebind_device == "controller")
    {
        var input_controller =
            instance_find(oInput, 0);

        var pad = -1;

        if (
            input_controller != noone &&
            variable_instance_exists(
                input_controller,
                "gamepad_index"
            )
        )
        {
            pad = input_controller.gamepad_index;
        }

        if (
            pad != -1 &&
            gamepad_is_connected(pad)
        )
        {
            // B cancels. Menu/Start remains permanently
            // reserved for pausing and cannot be rebound.
            if (
                gamepad_button_check_pressed(
                    pad,
                    gp_face2
                )
            )
            {
                controls_rebinding = false;
                controls_message = "Binding Cancelled";
                controls_message_timer = 75;
                play_navigation();
                exit;
            }

            var allowed_buttons = [
                gp_face1,
                gp_face3,
                gp_face4,
                gp_shoulderl,
                gp_shoulderr,
                gp_shoulderlb,
                gp_shoulderrb,
                gp_padl,
                gp_padr,
                gp_padu,
                gp_padd,
                gp_stickl,
                gp_stickr,
                gp_select
            ];

            for (
                var bi = 0;
                bi < array_length(allowed_buttons);
                bi++
            )
            {
                var new_button = allowed_buttons[bi];

                if (
                    gamepad_button_check_pressed(
                        pad,
                        new_button
                    )
                )
                {
                    scr_controls_set_gamepad(
                        controls_rebind_action,
                        new_button
                    );

                    controls_rebinding = false;
                    controls_message = "Control Saved";
                    controls_message_timer = 90;
                    play_confirm();
                    exit;
                }
            }
        }
    }

    exit;
}


// ====================================================
// MAIN PAUSE MENU
// ====================================================

if (menu_mode == "main")
{
    var count =
        array_length(menu_items);

    if (up)
    {
        selected_index =
            (selected_index - 1 + count)
            mod
            count;

        play_navigation();
    }

    if (down)
    {
        selected_index =
            (selected_index + 1)
            mod
            count;

        play_navigation();
    }


    // ------------------------------------------------
    // Controller B / Escape resumes from main pause
    // menu as a conventional "back" action.
    // ------------------------------------------------

    if (back)
    {
        play_confirm();
        resume_game();
        exit;
    }


    if (confirm)
    {
        play_confirm();

        switch (selected_index)
        {
            // ------------------------------------------------
            // Resume
            // ------------------------------------------------
            case 0:
            {
                resume_game();
                exit;
            }
            break;


            // ------------------------------------------------
            // Settings
            // ------------------------------------------------
            case 1:
            {
                menu_mode = "settings";
                settings_index = 0;
            }
            break;


            // ------------------------------------------------
            // Controls
            // ------------------------------------------------
            case 2:
            {
                menu_mode = "controls";
                controls_row = 0;
                controls_column = 0;
                controls_message = "";
                controls_message_timer = 0;
            }
            break;


            // ------------------------------------------------
            // Quit to Menu
            // ------------------------------------------------
            case 3:
            {
                global.game_phase = "main_menu";

                scr_settings_apply_audio_gains();

                instance_destroy();

                room_goto(
                    MainMenuBackground
                );

                exit;
            }
            break;


            // ------------------------------------------------
            // Quit to Desktop
            // ------------------------------------------------
            case 4:
            {
                game_end();
            }
            break;
        }
    }
}


// ====================================================
// SETTINGS MENU
// ====================================================

else if (menu_mode == "settings")
{
    var scount =
        array_length(settings_items);

    if (up)
    {
        settings_index =
            (settings_index - 1 + scount)
            mod
            scount;

        play_navigation();
}



    if (down)
    {
        settings_index =
            (settings_index + 1)
            mod
            scount;

        play_navigation();
    }


    var item =
        settings_items[
            settings_index
        ];


    var change = 0;

    if (left)
    {
        change = -1;
    }

    if (right)
    {
        change = 1;
    }


    if (change != 0)
    {
        var value_changed = false;


        // ------------------------------------------------
        // Dials
        // ------------------------------------------------

        if (
            item == "master_volume" ||
            item == "music_volume" ||
            item == "sfx_volume" ||
            item == "brightness" ||
            item == "contrast"
        )
        {
            var old_value =
                scr_settings_value01(
                    item
                );

            scr_settings_adjust(
                item,
                change
            );

            var new_value =
                scr_settings_value01(
                    item
                );

            value_changed =
                new_value != old_value;

            if (value_changed)
            {
                play_dial();
            }
        }


        // ------------------------------------------------
        // Display mode
        // ------------------------------------------------

        else if (item == "display_mode")
        {
            var old_display_mode =
                global.display_mode_index;

            scr_settings_adjust(
                item,
                change
            );

            value_changed =
                global.display_mode_index !=
                old_display_mode;

            if (value_changed)
            {
                play_settings_cycle();
            }
        }


        // ------------------------------------------------
        // Window size
        // ------------------------------------------------

        else if (item == "resolution")
        {
            var old_resolution =
                global.resolution_index;

            scr_settings_adjust(
                item,
                change
            );

            value_changed =
                global.resolution_index !=
                old_resolution;

            if (value_changed)
            {
                play_settings_cycle();
            }
        }
    }


    // ------------------------------------------------
    // Escape / Backspace / controller B
    // ------------------------------------------------

    if (back)
    {
        play_confirm();

        menu_mode = "main";
        selected_index = 1;
    }


    // ------------------------------------------------
    // Confirm the visible Back item
    // ------------------------------------------------

    else if (confirm)
    {
        if (item == "back")
        {
            play_confirm();

            menu_mode = "main";
            selected_index = 1;
        }
    }
}


// ====================================================
// CONTROLS MENU
// ====================================================

else if (menu_mode == "controls")
{
    var controls_count = 5;

    if (up)
    {
        controls_row =
            (controls_row - 1 + controls_count)
            mod
            controls_count;

        play_navigation();
    }

    if (down)
    {
        controls_row =
            (controls_row + 1)
            mod
            controls_count;

        play_navigation();
    }


    // Left/right selects Keyboard or Controller for the
    // three remappable gameplay action rows.
    if (controls_row <= 2)
    {
        if (left && controls_column != 0)
        {
            controls_column = 0;
            play_navigation();
        }

        if (right && controls_column != 1)
        {
            controls_column = 1;
            play_navigation();
        }
    }


    if (back)
    {
        play_confirm();

        menu_mode = "main";
        selected_index = 2;
    }


    else if (confirm)
    {
        // --------------------------------------------
        // Jump / Left / Right binding
        // --------------------------------------------

        if (controls_row <= 2)
        {
            switch (controls_row)
            {
                case 0: controls_rebind_action = "jump";  break;
                case 1: controls_rebind_action = "left";  break;
                case 2: controls_rebind_action = "right"; break;
            }

            controls_rebind_device =
                controls_column == 0
                ? "keyboard"
                : "controller";

            var can_begin_rebind = true;

            if (controls_rebind_device == "controller")
            {
                var current_input =
                    instance_find(oInput, 0);

                can_begin_rebind =
                    current_input != noone &&
                    variable_instance_exists(
                        current_input,
                        "gamepad_index"
                    ) &&
                    current_input.gamepad_index != -1 &&
                    gamepad_is_connected(
                        current_input.gamepad_index
                    );
            }

            if (!can_begin_rebind)
            {
                controls_message = "No Controller Connected";
                controls_message_timer = 120;
                play_navigation();
                exit;
            }

            controls_rebinding = true;
            controls_rebind_ignore_frames = 1;
            controls_message = "";
            controls_message_timer = 0;

            play_confirm();
        }


        // --------------------------------------------
        // Restore Defaults
        // --------------------------------------------

        else if (controls_row == 3)
        {
            scr_controls_restore_defaults();

            controls_message = "Defaults Restored";
            controls_message_timer = 120;

            play_confirm();
        }


        // --------------------------------------------
        // Back
        // --------------------------------------------

        else if (controls_row == 4)
        {
            play_confirm();

            menu_mode = "main";
            selected_index = 2;
        }
    }
}

