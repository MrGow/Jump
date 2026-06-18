/// oMainMenu — Step

scr_settings_init();

var up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

var confirm =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);

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
                global.menu_demo_active = false;
                global.game_phase = "playing";

                global.checkpoint_set  = false;
                global.checkpoint_room = -1;
                global.checkpoint_x    = 0;
                global.checkpoint_y    = 0;
                global.checkpoint_id   = "";

                global.pending_respawn      = false;
                global.pending_respawn_room = -1;
                global.pending_respawn_x    = 0;
                global.pending_respawn_y    = 0;

                global.room_teleport_active  = false;
                global.intra_teleport_active = false;

                global.inp_jump_press = false;
                global.inp_jump_held  = false;

                room_goto(start_room);
            break;

            case 1:
                // Continue later
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
            selected_index = 2;
        }
    }
}