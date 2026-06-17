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
    "fullscreen",
    "screen_shake",
    "button_prompts",
    "resolution",
    "back"
];

selected_index = 0;
settings_index = 0;

global.game_phase = "paused";

// ----------------------------------------------------
// Settings defaults
// ----------------------------------------------------
if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
if (!variable_global_exists("vol_music"))  global.vol_music  = 0.8;
if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;

if (!variable_global_exists("fullscreen"))          global.fullscreen = false;
if (!variable_global_exists("screen_shake_enabled")) global.screen_shake_enabled = true;
if (!variable_global_exists("button_prompts"))       global.button_prompts = true;

resolution_labels = ["640x360", "1280x720", "1920x1080"];
resolution_scales = [1, 2, 3];

if (!variable_global_exists("resolution_index")) global.resolution_index = 1;
global.resolution_index = clamp(global.resolution_index, 0, array_length(resolution_labels) - 1);