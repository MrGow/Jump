/// oPauseMenu — Create

depth = -100000;
persistent = false;
visible = true;

menu_mode = "main";

menu_items = [
    "Resume",
    "Settings",
    "Controls",
    "Quit to Menu",
    "Quit to Desktop"
];

settings_items = [
    "master_volume",
    "music_volume",
    "sfx_volume",
    "brightness",
    "contrast",
    "display_mode",
    "resolution",
    "back"
];

selected_index = 0;
settings_index = 0;

global.game_phase = "paused";

scr_settings_init();

if (instance_exists(oPlayer)) {
    with (oPlayer) {
        respawn_input_lock = 12;
        prev_jump_h = true;
        jump_charging = false;
        jump_charge = 0;
        jump_charge_level = 0;
    }
}