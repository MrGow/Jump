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

// Company logo should be short and clean.
company_hold_seconds = 3.5;

// Save warning needs longer because the player has to read it.
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

fade_speed = 0.06;


// ====================================================
// INPUT
// ====================================================

// Prevent an input already held when entering the room
// from immediately skipping a splash.
input_armed = false;
waiting_for_release = true;


// ====================================================
// FULL SEND GAMES LOGO
// ====================================================

fsg_logo_sprite =
    asset_get_index(
        "spriteFSGLogo"
    );

// Slightly larger than before.
fsg_logo_max_width = 200;

// Keep it properly centred.
fsg_logo_y_offset = 0;


// ====================================================
// ANIMATED SAVE ICON
// ====================================================

save_icon_sprite =
    asset_get_index(
        "spriteSaveIcon"
    );

// The imported sprite contains 16 frames:
// 0–13 = saving animation
// 14–15 = completion/check frames
save_icon_loop_first = 0;
save_icon_loop_last  = 13;

save_icon_complete_1 = 14;
save_icon_complete_2 = 15;

save_icon_frame =
    save_icon_loop_first;

// Approximately 21 animation frames per second at 60 FPS.
save_icon_anim_speed = 0.35;

// Original frame size is 64×64.
// This draws it at approximately 48×48.
save_icon_scale = 0.75;


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