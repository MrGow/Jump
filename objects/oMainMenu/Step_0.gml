/// oMainMenu — Step

var up    = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

var confirm =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);

var count = array_length(menu_items);

if (up)   selected_index = (selected_index - 1 + count) mod count;
if (down) selected_index = (selected_index + 1) mod count;

if (confirm)
{
    switch (selected_index)
    {
        case 0: // New Game
            if (instance_exists(oDeathMenu)) {
                with (oDeathMenu) instance_destroy();
            }

            // Full new-run reset
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

        case 1: // Continue
        break;

        case 2: // Settings
        break;

        case 3: // Quit Game
            game_end();
        break;
    }
}