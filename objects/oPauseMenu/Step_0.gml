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

var back =
    variable_global_exists("inp_menu_back_press") &&
    global.inp_menu_back_press;


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

    global.game_phase = "playing";

    scr_settings_apply_audio_gains();

    instance_destroy();
};


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
                // Controls screen can be added later.
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