/// oPauseMenu — Create

depth = -100000;
persistent = false;
visible = true;

menu_items = [
    "Resume",
    "Settings",
    "Controls",
    "Quit to Menu",
    "Quit to Desktop"
];

selected_index = 0;

global.game_phase = "paused";

// Logo
pause_logo_sprite = asset_get_index("spriteJumpBotLogo");
pause_logo_scale  = 0.22; // tweak this