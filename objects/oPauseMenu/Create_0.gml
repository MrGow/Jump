/// oPauseMenu — Create

depth = -1500;
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
    "atmosphere_volume",
    "music_volume",
    "sfx_volume",
    "brightness",
    "contrast",
    "display_mode",
    "resolution"
];

selected_index = 0;
settings_index = 0;

// ====================================================
// CONTROLS MENU
// ====================================================

controls_row = 0;
controls_column = 0;

controls_rebinding = false;
controls_rebind_device = "";
controls_rebind_action = "";
controls_rebind_ignore_frames = 0;

controls_message = "";
controls_message_timer = 0;

// Freeze gameplay without altering player physics or animation.
global.game_phase = "paused";

scr_settings_init();
scr_controls_ensure_defaults();
scr_settings_apply_audio_gains();

// ====================================================
// UI SOUNDS
// ====================================================

snd_ui_navigation = asset_get_index("UIMenuNavigation1");
snd_ui_dial = asset_get_index("UIDialMovement1");
snd_ui_confirm = asset_get_index("UIConfirmation1");
snd_ui_settings_cycle = asset_get_index("UISettingsCycle");

ui_navigation_gain = 1.0;
ui_dial_gain = 1.0;
ui_confirm_gain = 1.0;
ui_settings_cycle_gain = 1.0;

ui_navigation_pitch_low  = 0.97;
ui_navigation_pitch_high = 1.03;
