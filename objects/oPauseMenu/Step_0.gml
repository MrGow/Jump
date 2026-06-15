/// oPauseMenu — Step

var up    = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

var kb_confirm = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
var inp_confirm = variable_global_exists("inp_jump_press") && global.inp_jump_press;
var confirm = kb_confirm || inp_confirm;

var count = array_length(menu_items);

if (up)   selected_index = (selected_index - 1 + count) mod count;
if (down) selected_index = (selected_index + 1) mod count;

if (confirm) {
    switch (selected_index) {
        case 0:
            if (instance_exists(oPlayer)) {
                with (oPlayer) {
                    respawn_input_lock = 12;
                    prev_jump_h = true;
                }
            }

            global.game_phase = "playing";
            instance_destroy();
        break;

        case 3: // Quit to Menu
            global.game_phase = "menu";
            instance_destroy();
            room_goto(MainMenuBackground);
        break;

        case 4:
            game_end();
        break;
    }
}