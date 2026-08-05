/// oMainMenu — Step

scr_settings_init();


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_ui_navigation"))
{
    snd_ui_navigation =
        asset_get_index(
            "UIMenuNavigation1"
        );
}

if (!variable_instance_exists(id, "snd_ui_dial"))
{
    snd_ui_dial =
        asset_get_index(
            "UIDialMovement1"
        );
}

if (!variable_instance_exists(id, "snd_ui_confirm"))
{
    snd_ui_confirm =
        asset_get_index(
            "UIConfirmation1"
        );
}

if (!variable_instance_exists(id, "snd_ui_settings_cycle"))
{
    snd_ui_settings_cycle =
        asset_get_index(
            "UISettingsCycle"
        );
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


// ====================================================
// INPUT
// ====================================================

var up =
    keyboard_check_pressed(vk_up) ||
    keyboard_check_pressed(ord("W"));

var down =
    keyboard_check_pressed(vk_down) ||
    keyboard_check_pressed(ord("S"));

var left =
    keyboard_check_pressed(vk_left) ||
    keyboard_check_pressed(ord("A"));

var right =
    keyboard_check_pressed(vk_right) ||
    keyboard_check_pressed(ord("D"));

var confirm =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);

var back =
    keyboard_check_pressed(vk_escape) ||
    keyboard_check_pressed(vk_backspace);


// ----------------------------------------------------
// Gamepad input
// ----------------------------------------------------

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

    up =
        up ||
        gamepad_button_check_pressed(
            pad,
            gp_padu
        );

    down =
        down ||
        gamepad_button_check_pressed(
            pad,
            gp_padd
        );

    left =
        left ||
        gamepad_button_check_pressed(
            pad,
            gp_padl
        );

    right =
        right ||
        gamepad_button_check_pressed(
            pad,
            gp_padr
        );

    confirm =
        confirm ||
        gamepad_button_check_pressed(
            pad,
            gp_face1
        );

    back =
        back ||
        gamepad_button_check_pressed(
            pad,
            gp_face2
        );
}


// ====================================================
// STARTUP INPUT GUARD
//
// Prevents Space/A used to leave the startup sequence
// from also selecting New Game on the main menu.
// ====================================================

if (!variable_global_exists("startup_menu_input_lock"))
{
    global.startup_menu_input_lock = 0;
}

if (global.startup_menu_input_lock > 0)
{
    global.startup_menu_input_lock--;

    // Block only menu input. The rest of this Step still
    // runs, including settings and audio safety.
    up      = false;
    down    = false;
    left    = false;
    right   = false;
    confirm = false;
    back    = false;

    if (variable_global_exists("inp_jump_press"))
    {
        global.inp_jump_press = false;
    }
}


// ====================================================
// LOCAL SOUND HELPERS
// ====================================================

var play_navigation = function()
{
    if (
        snd_ui_navigation != -1 &&
        audio_group_is_loaded(
            audiogroupui
        )
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
        audio_group_is_loaded(
            audiogroupui
        )
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
        audio_group_is_loaded(
            audiogroupui
        )
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
        audio_group_is_loaded(
            audiogroupui
        )
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
// MAIN MENU
// ====================================================

if (menu_mode == "main")
{
    var count =
        array_length(menu_items);

    if (up)
    {
        selected_index =
            (
                selected_index -
                1 +
                count
            )
            mod count;

        play_navigation();
    }

    if (down)
    {
        selected_index =
            (
                selected_index +
                1
            )
            mod count;

        play_navigation();
    }

    if (confirm)
    {
        play_confirm();

        switch (selected_index)
        {
            // New Game
            case 0:
            {
                menu_mode =
                    "new_slot_select";

                slot_index = 0;
            }
            break;


            // Continue
            case 1:
            {
                menu_mode =
                    "continue_slot_select";

                continue_slot_index = 0;
            }
            break;


            // Settings
            case 2:
            {
                menu_mode =
                    "settings";

                settings_index = 0;
            }
            break;


            // Quit Game
            case 3:
            {
                game_end();
            }
            break;
        }
    }
}


// ====================================================
// NEW SAVE SLOT
// ====================================================

else if (menu_mode == "new_slot_select")
{
    var slot_count =
        array_length(slot_items);

    if (up)
    {
        slot_index =
            (
                slot_index -
                1 +
                slot_count
            )
            mod slot_count;

        play_navigation();
    }

    if (down)
    {
        slot_index =
            (
                slot_index +
                1
            )
            mod slot_count;

        play_navigation();
    }

    if (back)
    {
        play_confirm();

        menu_mode = "main";
        selected_index = 0;
    }
    else if (confirm)
    {
        if (slot_index == 3)
        {
            play_confirm();

            menu_mode = "main";
            selected_index = 0;
        }
        else
        {
            var chosen_slot =
                slot_index + 1;

            if (
                scr_save_exists(
                    chosen_slot
                )
            )
            {
                play_confirm();

                pending_new_slot =
                    chosen_slot;

                overwrite_index = 0;

                menu_mode =
                    "overwrite_confirm";
            }
            else
            {
                play_confirm();

                global.menu_demo_active =
                    false;

                global.game_phase =
                    "playing";

                scr_settings_apply_audio_gains();

                scr_save_begin_new(
                    chosen_slot
                );

                global.room_teleport_active =
                    false;

                global.intra_teleport_active =
                    false;

                global.inp_jump_press =
                    false;

                global.inp_jump_held =
                    false;

                room_goto(
                    start_room
                );
            }
        }
    }
}


// ====================================================
// CONTINUE SLOT
// ====================================================

else if (menu_mode == "continue_slot_select")
{
    var cont_count =
        array_length(slot_items);

    if (up)
    {
        continue_slot_index =
            (
                continue_slot_index -
                1 +
                cont_count
            )
            mod cont_count;

        play_navigation();
    }

    if (down)
    {
        continue_slot_index =
            (
                continue_slot_index +
                1
            )
            mod cont_count;

        play_navigation();
    }

    if (back)
    {
        play_confirm();

        menu_mode = "main";
        selected_index = 1;
    }
    else if (confirm)
    {
        if (continue_slot_index == 3)
        {
            play_confirm();

            menu_mode = "main";
            selected_index = 1;
        }
        else
        {
            var chosen_continue_slot =
                continue_slot_index + 1;

            if (
                scr_save_exists(
                    chosen_continue_slot
                )
            )
            {
                play_confirm();

                global.menu_demo_active =
                    false;

                scr_load_game(
                    chosen_continue_slot
                );
            }
        }
    }
}


// ====================================================
// OVERWRITE CONFIRMATION
// ====================================================

else if (menu_mode == "overwrite_confirm")
{
    if (
        up ||
        down ||
        left ||
        right
    )
    {
        overwrite_index =
            1 -
            overwrite_index;

        play_navigation();
    }

    if (back)
    {
        play_confirm();

        menu_mode =
            "new_slot_select";

        slot_index =
            pending_new_slot -
            1;
    }
    else if (confirm)
    {
        play_confirm();

        if (overwrite_index == 0)
        {
            menu_mode =
                "new_slot_select";

            slot_index =
                pending_new_slot -
                1;
        }
        else
        {
            global.menu_demo_active =
                false;

            global.game_phase =
                "playing";

            scr_settings_apply_audio_gains();

            scr_save_begin_new(
                pending_new_slot
            );

            global.room_teleport_active =
                false;

            global.intra_teleport_active =
                false;

            global.inp_jump_press =
                false;

            global.inp_jump_held =
                false;

            room_goto(
                start_room
            );
        }
    }
}


// ====================================================
// SETTINGS
// ====================================================

else if (menu_mode == "settings")
{
    var scount =
        array_length(
            settings_items
        );

    if (up)
    {
        settings_index =
            (
                settings_index -
                1 +
                scount
            )
            mod scount;

        play_navigation();
    }

    if (down)
    {
        settings_index =
            (
                settings_index +
                1
            )
            mod scount;

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

        // --------------------------------------------
        // Dials
        // --------------------------------------------
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
                new_value !=
                old_value;

            if (value_changed)
            {
                play_dial();
            }
        }

        // --------------------------------------------
        // Display mode
        // --------------------------------------------
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

        // --------------------------------------------
        // Window size
        // --------------------------------------------
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

    if (back)
    {
        play_confirm();

        menu_mode = "main";
        selected_index = 2;
    }
    else if (confirm)
    {
        if (item == "back")
        {
            play_confirm();

            menu_mode = "main";
            selected_index = 2;
        }
    }
}