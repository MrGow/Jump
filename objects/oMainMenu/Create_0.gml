/// oMainMenu — Create

depth = -1000;
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


// ====================================================
// MAIN MENU MONITOR BORDER
//
// spriteMainMenuBorder:
//     640 x 360
//     Top Centre origin
//
// Drawn AFTER the CRT effects so the physical bezel
// remains clean and unaffected by scanlines/flicker.
// ====================================================

main_menu_border_sprite =
    asset_get_index(
        "spriteMainMenuBorder"
    );


if (!variable_instance_exists(id, "main_menu_border_enabled"))
{
    main_menu_border_enabled = true;
}


// ====================================================
// CRT MAIN MENU EFFECT
// ====================================================

// Master switch.
if (!variable_instance_exists(id, "crt_enabled"))
{
    crt_enabled = true;
}


// ----------------------------------------------------
// CRT clock
//
// Incremented once per Draw GUI.
// ----------------------------------------------------

crt_time = 0;


// ----------------------------------------------------
// ACTUAL SCREEN / GLASS BOUNDS
//
// These keep CRT effects inside the monitor opening.
//
// Because the bezel is not the same thickness on every
// side, use separate values instead of one crt_inset.
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_inset_left"))
{
    crt_inset_left = 22;
}

if (!variable_instance_exists(id, "crt_inset_right"))
{
    crt_inset_right = 22;
}

if (!variable_instance_exists(id, "crt_inset_top"))
{
    crt_inset_top = 14;
}

if (!variable_instance_exists(id, "crt_inset_bottom"))
{
    crt_inset_bottom = 15;
}


// ----------------------------------------------------
// SCANLINES
// ----------------------------------------------------

// One scanline every N pixels.
if (!variable_instance_exists(id, "crt_scan_gap"))
{
    crt_scan_gap = 4;
}


// Darkness of scanlines.
if (!variable_instance_exists(id, "crt_scan_alpha"))
{
    crt_scan_alpha = 0.13;
}


// Tiny movement prevents the effect looking completely
// static / painted onto the screen.
if (!variable_instance_exists(id, "crt_scan_drift"))
{
    crt_scan_drift = 0.12;
}


// ----------------------------------------------------
// SCREEN FLICKER
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_flicker_alpha"))
{
    crt_flicker_alpha = 0.018;
}


// ----------------------------------------------------
// ROLLING INTERFERENCE BAND
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_roll_enabled"))
{
    crt_roll_enabled = true;
}

if (!variable_instance_exists(id, "crt_roll_speed"))
{
    crt_roll_speed = 0.42;
}

if (!variable_instance_exists(id, "crt_roll_height"))
{
    crt_roll_height = 12;
}

if (!variable_instance_exists(id, "crt_roll_alpha"))
{
    crt_roll_alpha = 0.035;
}


// ----------------------------------------------------
// OCCASIONAL HORIZONTAL SYNC GLITCH
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_glitch_enabled"))
{
    crt_glitch_enabled = true;
}


// Roughly every 7 seconds at 60 FPS.
if (!variable_instance_exists(id, "crt_glitch_interval"))
{
    crt_glitch_interval = 420;
}


// How many frames the disturbance lasts.
if (!variable_instance_exists(id, "crt_glitch_frames"))
{
    crt_glitch_frames = 7;
}

if (!variable_instance_exists(id, "crt_glitch_alpha"))
{
    crt_glitch_alpha = 0.12;
}


// ----------------------------------------------------
// EDGE DARKENING
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_edge_alpha"))
{
    crt_edge_alpha = 0.10;
}

if (!variable_instance_exists(id, "crt_edge_size"))
{
    crt_edge_size = 5;
}