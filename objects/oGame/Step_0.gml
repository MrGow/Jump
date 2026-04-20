/// oGame — Step (Fullscreen toggle + Pause)

if (keyboard_check_pressed(vk_f11)) {
    apply_fullscreen(!global.fullscreen);
}

var alt_down = keyboard_check(vk_alt);
if (alt_down && keyboard_check_pressed(vk_enter)) {
    apply_fullscreen(!global.fullscreen);
}

var pause_pressed = false;
if (variable_global_exists("inp_pause_press")) {
    pause_pressed = global.inp_pause_press;
} else {
    pause_pressed = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
}

if (pause_pressed) {
    if (!variable_global_exists("game_phase")) global.game_phase = "playing";

    if (global.game_phase == "playing") {
        if (!instance_exists(oPauseMenu)) {
            instance_create_depth(0, 0, -1000000, oPauseMenu);
        }
    }
    else if (global.game_phase == "paused") {
        if (instance_exists(oPauseMenu)) {
            with (oPauseMenu) instance_destroy();
        }
        global.game_phase = "playing";
    }
}