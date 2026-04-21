/// oGame — Step (Fullscreen toggle + Pause)

if (keyboard_check_pressed(vk_f11)) {
    apply_fullscreen(!global.fullscreen);
}

var alt_down = keyboard_check(vk_alt);
if (alt_down && keyboard_check_pressed(vk_enter)) {
    apply_fullscreen(!global.fullscreen);
}

var kb_pause_pressed = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
var inp_pause_pressed = variable_global_exists("inp_pause_press") && global.inp_pause_press;
var pause_pressed = kb_pause_pressed || inp_pause_pressed;

if (pause_toggle_cooldown > 0) pause_toggle_cooldown--;

if (pause_pressed && pause_toggle_cooldown <= 0) {
    if (!variable_global_exists("game_phase")) global.game_phase = "playing";

    if (global.game_phase == "playing") {
        if (!instance_exists(oPauseMenu)) {
            instance_create_depth(0, 0, -1000000, oPauseMenu);
            pause_toggle_cooldown = 15;
        }
    }
    else if (global.game_phase == "paused") {
        if (instance_exists(oPauseMenu)) {
            with (oPauseMenu) instance_destroy();
        }
        global.game_phase = "playing";
        pause_toggle_cooldown = 15;
    }
}