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

slot_items = [
    "Slot 1",
    "Slot 2",
    "Slot 3",
    "Back"
];

overwrite_items = [
    "No",
    "Yes"
];

selected_index = 0;
settings_index = 0;
slot_index = 0;
continue_slot_index = 0;
overwrite_index = 0;
pending_new_slot = 1;

start_room = Scrapyard1;

scr_settings_init();