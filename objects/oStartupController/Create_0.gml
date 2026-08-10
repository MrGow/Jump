/// oStartupController — Create


// ====================================================
// DISPLAY
// ====================================================

visible = true;
depth   = -100;

if (!variable_global_exists("GUI_W"))
{
    global.GUI_W = 800;
}

if (!variable_global_exists("GUI_H"))
{
    global.GUI_H = 450;
}

display_set_gui_size(
    global.GUI_W,
    global.GUI_H
);


// ====================================================
// DESTINATION ROOM
// ====================================================

main_menu_room =
    asset_get_index(
        "MainMenuBackground"
    );


// ====================================================
// STARTUP SCREENS
//
// 0 = Full Send Games
// 1 = Saving warning
// 2 = Leaving startup
// ====================================================

startup_screen = 0;


// ====================================================
// TIMING
// ====================================================

company_hold_seconds = 2.75;
save_warning_hold_seconds = 4.5;

company_hold_frames =
    max(
        1,
        round(
            room_speed *
            company_hold_seconds
        )
    );

save_warning_hold_frames =
    max(
        1,
        round(
            room_speed *
            save_warning_hold_seconds
        )
    );

screen_timer =
    company_hold_frames;


// ====================================================
// FADING
//
// 0 = Fade in
// 1 = Hold
// 2 = Fade out
// ====================================================

fade_state = 0;
fade_alpha = 0;

fade_speed = 0.035;


// ====================================================
// INPUT
// ====================================================

input_armed = false;
waiting_for_release = true;


// ====================================================
// FULL SEND GAMES LOGO
// ====================================================

fsg_logo_sprite =
    asset_get_index(
        "spriteFSGLogo"
    );

fsg_logo_max_width = 300;
fsg_logo_y_offset  = 0;


// ====================================================
// FSG LOGO POWER-ON EFFECT
//
// A short industrial/CRT-style flicker used only while
// the company logo is appearing.
// ====================================================

fsg_power_timer = 0;

// Total power-up effect duration.
fsg_power_duration = 84;

// Used so the optional sound only fires once.
fsg_power_sound_played = false;

// Optional future sound.
// Example asset name:
// FSGLogoPowerOn1
snd_fsg_power =
    asset_get_index(
        "FSGLogoPowerOn1"
    );

fsg_power_sound_gain = 0.85;


// ====================================================
// ANIMATED SAVE ICON
// ====================================================

save_icon_sprite =
    asset_get_index(
        "spriteSaveIcon"
    );

save_icon_loop_first = 0;
save_icon_loop_last  = 13;

save_icon_complete_1 = 14;
save_icon_complete_2 = 15;

save_icon_frame =
    save_icon_loop_first;

save_icon_anim_speed = 0.35;
save_icon_scale      = 0.75;


// ====================================================
// FONT REFERENCES
// ====================================================

font_warning_title =
    asset_get_index(
        "PIXELOPERATORBOLD32"
    );

font_warning_body =
    asset_get_index(
        "PIXELOPERATORREGULAR16"
    );

font_continue =
    asset_get_index(
        "PIXELOPERATORREGULAR10"
    );


// ====================================================
// MAIN-MENU INPUT GUARD
// ====================================================

global.startup_menu_input_lock = 0;