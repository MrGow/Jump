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


// ====================================================
// CRT MAIN MENU EFFECT
// ====================================================

// Master switch.
// You can make this an editor variable if desired.
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
// Screen inset
//
// Leave at 0 for now.
//
// Once you add the physical JumpBot monitor bezel,
// increase this so the CRT effect only appears inside
// the actual glass area.
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_inset"))
{
    crt_inset = 0;
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
// Keep this subtle.
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

// Very slight overall brightness fluctuation.
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