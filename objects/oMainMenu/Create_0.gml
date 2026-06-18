/// oMainMenu — Create

depth = -100;
visible = true;

menu_mode = "main";

logo_sprite = asset_get_index("spriteJumpBotLogo");
logo_scale  = 0.18;

menu_items = [
    "New Game",
    "Continue",
    "Settings",
    "Quit Game"
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

start_room = Scrapyard1;

scr_settings_init();