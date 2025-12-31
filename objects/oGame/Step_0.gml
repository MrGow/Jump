/// oGame — Step (Fullscreen toggle)

if (keyboard_check_pressed(vk_f11)) {
    apply_fullscreen(!global.fullscreen);
}

var alt_down = keyboard_check(vk_alt);
if (alt_down && keyboard_check_pressed(vk_enter)) {
    apply_fullscreen(!global.fullscreen);
}
