/// oMainMenu — Create

depth = -100;
visible = true;

menu_mode = "main";

logo_sprite = asset_get_index("spriteJumpBotLogo");
logo_scale  = 0.15;

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

// ====================================================
// UI SOUNDS
// ====================================================

snd_ui_navigation =
    asset_get_index("UIMenuNavigation1");

snd_ui_dial =
    asset_get_index("UIDialMovement1");

snd_ui_confirm =
    asset_get_index("UIConfirmation1");

snd_ui_settings_cycle =
    asset_get_index("UISettingsCycle");

// Local gain before Master/SFX group gain.
ui_navigation_gain = 1.0;
ui_dial_gain = 1.0;
ui_confirm_gain = 1.0;
ui_settings_cycle_gain = 1.0;

// Slight pitch variation can make repeated movement
// sounds feel less mechanically identical.
ui_navigation_pitch_low  = 0.97;
ui_navigation_pitch_high = 1.03;