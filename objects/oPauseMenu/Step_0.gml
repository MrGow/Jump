/// oPauseMenu — Step

var up    = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

var confirm = false;
if (variable_global_exists("inp_jump_press")) {
    confirm = global.inp_jump_press;
} else {
    confirm = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
}

var count = array_length(menu_items);

if (up)   selected_index = (selected_index - 1 + count) mod count;
if (down) selected_index = (selected_index + 1) mod count;

if (confirm) {
    switch (selected_index) {
        case 0: // Resume
            global.game_phase = "playing";
            instance_destroy();
        break;

        case 4: // Quit to Desktop
            game_end();
        break;
    }
}