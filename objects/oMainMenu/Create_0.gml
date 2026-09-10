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
    "atmosphere_volume",
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
// PHOSPHOR / CONTENT INSTABILITY
//
// Unlike the physical scanlines/glitches below, these
// values affect the actual logo and UI content.
//
// The result should be subtle: the menu looks like it
// is being emitted by an ageing CRT rather than having
// a CRT filter simply placed over clean UI.
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_phosphor_min"))
{
    crt_phosphor_min = 0.93;
}


// The large logo is allowed to breathe a little more
// strongly than the smaller menu text.
if (!variable_instance_exists(id, "crt_phosphor_logo_min"))
{
    crt_phosphor_logo_min = 0.89;
}


crt_phosphor_level = 1;
crt_phosphor_logo_level = 1;
crt_selection_level = 1;


// Very occasional one-frame intensity loss.
//
// 360–600 frames = roughly every 6–10 seconds at 60 FPS.
crt_dropout_timer =
    irandom_range(
        360,
        600
    );

crt_dropout_frames = 0;


// 0.13 means the content briefly falls to 87% of its
// already-calculated phosphor brightness.
crt_dropout_strength = 0.13;


// Extremely light cyan/green cast over the glass.
// Keep this low so it never becomes a coloured filter.
crt_glass_tint_alpha = 0.018;

crt_glass_tint_color =
    make_color_rgb(
        70,
        150,
        145
    );


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

// ====================================================
// MAIN MENU SIGNAL ACQUISITION INTRO
//
// Quick "channel change" rather than another full CRT
// power-on:
//
//   0–4    black
//   5–22   strong analogue static
//   23–34  static rapidly clears to reveal menu
//   35–40  tiny final sync-lock disturbance
//
// Total: ~0.67 seconds at 60 FPS.
//
// The physical bezel is drawn later in Draw GUI End,
// so this effect stays inside the CRT glass.
// ====================================================

menu_signal_intro_active =
    true;

menu_signal_intro_timer =
    0;

menu_signal_intro_duration =
    40;


// Initial completely black hold.
menu_signal_black_frames =
    4;


// End of full-strength static.
menu_signal_static_full_end =
    22;


// End of fading static.
menu_signal_static_fade_end =
    34;


// Static pattern changes every frame. This is kept as
// a separate phase so the pattern can be deterministic
// without affecting GameMaker's random state.
menu_signal_noise_phase =
    0;


// Chunk sizes for the analogue/digital TV noise.
menu_signal_coarse_w =
    16;

menu_signal_coarse_h =
    5;

menu_signal_fine_w =
    7;

menu_signal_fine_h =
    3;


// Slight dark line density over the noise.
menu_signal_scan_gap =
    4;


// Final channel-lock tear.
menu_signal_lock_y =
    88;

menu_signal_lock_h =
    3;


// ====================================================
// SIGNAL INTRO AUDIO
// ====================================================

menu_signal_static_sound =
    asset_get_index(
        "StaticSound"
    );


menu_signal_static_voice =
    noone;


// Very short fade so the six-second source clip stops
// cleanly when the visible static ends.
menu_signal_static_fade_ms =
    50;


// Start immediately with the signal-acquisition intro.
if (menu_signal_static_sound != -1)
{
    menu_signal_static_voice =
        audio_play_sound(
            menu_signal_static_sound,
            10,
            false
        );
}

