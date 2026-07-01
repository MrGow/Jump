/// oMainMenu — Step

scr_settings_init();

var up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

var confirm =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);

var back =
    keyboard_check_pressed(vk_escape) ||
    keyboard_check_pressed(vk_backspace);

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
                menu_mode = "new_slot_select";
                slot_index = 0;
            break;

            case 1:
                menu_mode = "continue_slot_select";
                continue_slot_index = 0;
            break;

            case 2:
                menu_mode = "settings";
                settings_index = 0;
            break;

            case 3:
                game_end();
            break;
        }
    }
}
else if (menu_mode == "new_slot_select")
{
    var slot_count = array_length(slot_items);

    if (up)   slot_index = (slot_index - 1 + slot_count) mod slot_count;
    if (down) slot_index = (slot_index + 1) mod slot_count;

    if (back) {
        menu_mode = "main";
        selected_index = 0;
    }

    if (confirm)
    {
        if (slot_index == 3) {
            menu_mode = "main";
            selected_index = 0;
        }
        else
        {
            var chosen_slot = slot_index + 1;

            if (scr_save_exists(chosen_slot))
            {
                pending_new_slot = chosen_slot;
                overwrite_index = 0;
                menu_mode = "overwrite_confirm";
            }
            else
            {
                global.menu_demo_active = false;
                global.game_phase = "playing";

                scr_save_begin_new(chosen_slot);

                global.room_teleport_active  = false;
                global.intra_teleport_active = false;

                global.inp_jump_press = false;
                global.inp_jump_held  = false;

                room_goto(start_room);
            }
        }
    }
}
else if (menu_mode == "continue_slot_select")
{
    var cont_count = array_length(slot_items);

    if (up)   continue_slot_index = (continue_slot_index - 1 + cont_count) mod cont_count;
    if (down) continue_slot_index = (continue_slot_index + 1) mod cont_count;

    if (back) {
        menu_mode = "main";
        selected_index = 1;
    }

    if (confirm)
    {
        if (continue_slot_index == 3) {
            menu_mode = "main";
            selected_index = 1;
        }
        else
        {
            var chosen_continue_slot = continue_slot_index + 1;

            if (scr_save_exists(chosen_continue_slot))
            {
                global.menu_demo_active = false;
                scr_load_game(chosen_continue_slot);
            }
        }
    }
}
else if (menu_mode == "overwrite_confirm")
{
    if (up || down || left || right) {
        overwrite_index = 1 - overwrite_index;
    }

    if (back) {
        menu_mode = "new_slot_select";
        slot_index = pending_new_slot - 1;
    }

    if (confirm)
    {
        if (overwrite_index == 0) {
            menu_mode = "new_slot_select";
            slot_index = pending_new_slot - 1;
        }
        else
        {
            global.menu_demo_active = false;
            global.game_phase = "playing";

            scr_save_begin_new(pending_new_slot);

            global.room_teleport_active  = false;
            global.intra_teleport_active = false;

            global.inp_jump_press = false;
            global.inp_jump_held  = false;

            room_goto(start_room);
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

    if (back) {
        menu_mode = "main";
        selected_index = 2;
    }

    if (confirm)
    {
        if (item == "back")
        {
            menu_mode = "main";
            selected_index = 2;
        }
    }
}