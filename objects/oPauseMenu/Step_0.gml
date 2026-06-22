/// oPauseMenu — Step

scr_settings_init();

if (instance_exists(oPlayer)) {
    with (oPlayer) {
        prev_jump_h = true;
        jump_charging = false;
        jump_charge = 0;
        jump_charge_level = 0;
    }
}

var up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

var kb_confirm  = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
var inp_confirm = variable_global_exists("inp_jump_press") && global.inp_jump_press;
var confirm = kb_confirm || inp_confirm;

if (menu_mode == "main")
{
    var count = array_length(menu_items);

    if (up)   selected_index = (selected_index - 1 + count) mod count;
    if (down) selected_index = (selected_index + 1) mod count;

    if (confirm)
    {
        switch (selected_index)
        {
            case 0:
                if (instance_exists(oPlayer)) {
                    with (oPlayer) {
                        respawn_input_lock = 12;
                        prev_jump_h = true;
                    }
                }

                global.game_phase = "playing";
                scr_settings_apply_audio_gains();
                instance_destroy();
            break;

            case 1:
                menu_mode = "settings";
                settings_index = 0;
            break;

            case 2:
                // Controls later
            break;

            case 3:
                global.game_phase = "menu";
                scr_settings_apply_audio_gains();
                instance_destroy();
                room_goto(MainMenuBackground);
            break;

            case 4:
                game_end();
            break;
        }
    }
}
else if (menu_mode == "settings")
{
    var scount = array_length(settings_items);

    if (up)   settings_index = (settings_index - 1 + scount) mod scount;
    if (down) settings_index = (settings_index + 1) mod scount;

    var item = settings_items[settings_index];

    var change = 0;
    if (left)  change = -1;
    if (right) change =  1;

    if (change != 0) {
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