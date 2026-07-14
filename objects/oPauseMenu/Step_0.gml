/// oPauseMenu — Step

scr_settings_init();


// ----------------------------------------------------
// Keep charge input safely cancelled while paused
// ----------------------------------------------------
if (instance_exists(oPlayer))
{
    with (oPlayer)
    {
        prev_jump_h = true;

        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;

        if (variable_instance_exists(id, "jump_charge_sfx_last"))
        {
            jump_charge_sfx_last = 0;
        }

        if (variable_instance_exists(id, "charge_grace"))
        {
            charge_grace = 0;
        }

        if (variable_instance_exists(id, "support_grace"))
        {
            support_grace = 0;
        }

        if (variable_instance_exists(id, "charge_start_lock"))
        {
            charge_start_lock = 0;
        }

        if (variable_instance_exists(id, "edge_charge_fail"))
        {
            edge_charge_fail = 0;
        }

        if (state == "jump_charge")
        {
            state = "idle";
        }
    }
}


// ----------------------------------------------------
// Menu input
// ----------------------------------------------------
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

var kb_confirm =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);

var inp_confirm =
    variable_global_exists("inp_jump_press") &&
    global.inp_jump_press;

var confirm = kb_confirm || inp_confirm;


// ====================================================
// MAIN MENU
// ====================================================
if (menu_mode == "main")
{
    var count = array_length(menu_items);

    if (up)
    {
        selected_index =
            (selected_index - 1 + count) mod count;
    }

    if (down)
    {
        selected_index =
            (selected_index + 1) mod count;
    }

    if (confirm)
    {
        switch (selected_index)
        {
            // ------------------------------------------------
            // Resume
            // ------------------------------------------------
            case 0:
            {
                if (instance_exists(oPlayer))
                {
                    with (oPlayer)
                    {
                        respawn_input_lock = 12;
                        prev_jump_h = true;

                        // Completely cancel any interrupted charge.
                        jump_charging     = false;
                        jump_charge       = 0;
                        jump_charge_level = 0;

                        if (variable_instance_exists(id, "jump_charge_sfx_last"))
                        {
                            jump_charge_sfx_last = 0;
                        }

                        if (variable_instance_exists(id, "charge_grace"))
                        {
                            charge_grace = 0;
                        }

                        if (variable_instance_exists(id, "support_grace"))
                        {
                            support_grace = 0;
                        }

                        if (variable_instance_exists(id, "charge_start_lock"))
                        {
                            charge_start_lock = 0;
                        }

                        if (variable_instance_exists(id, "edge_charge_fail"))
                        {
                            edge_charge_fail = 0;
                        }

                        // Repair any stale charge state or sprite.
                        var charge_sprite =
                            asset_get_index("spriteBotJumpCharge");

                        var idle_sprite =
                            asset_get_index("spriteBotIdle");

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
                        else
                        {
                            // Restore any animation that was frozen
                            // by the pause state.
                            if (image_speed <= 0)
                            {
                                image_speed = 1;
                            }
                        }
                    }
                }

                // Clear stale confirm/jump input.
                if (variable_global_exists("inp_jump_press"))
                {
                    global.inp_jump_press = false;
                }

                global.game_phase = "playing";

                scr_settings_apply_audio_gains();

                instance_destroy();
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
                // Controls later
            }
            break;


            // ------------------------------------------------
            // Quit to Menu
            // ------------------------------------------------
            case 3:
            {
                global.game_phase = "menu";

                scr_settings_apply_audio_gains();

                instance_destroy();
                room_goto(MainMenuBackground);
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
    var scount = array_length(settings_items);

    if (up)
    {
        settings_index =
            (settings_index - 1 + scount) mod scount;
    }

    if (down)
    {
        settings_index =
            (settings_index + 1) mod scount;
    }

    var item = settings_items[settings_index];

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
        scr_settings_adjust(item, change);
    }

    if (confirm)
    {
        if (item == "back")
        {
            menu_mode = "main";
            selected_index = 1;
        }
    }
}