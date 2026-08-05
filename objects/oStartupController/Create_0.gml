/// oStartupController — Create

// ====================================================
// DISPLAY
// ====================================================

visible = true;
depth   = -1000000;

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
    asset_get_index("MainMenuBackground");


// ====================================================
// STARTUP SCREENS
//
// 0 = Full Send Games
// 1 = Saving warning
// 2 = leaving startup
// ====================================================

startup_screen = 0;


// ====================================================
// TIMING
// ====================================================

screen_hold_seconds = 3.5;

screen_hold_frames =
    max(
        1,
        round(
            room_speed *
            screen_hold_seconds
        )
    );

screen_timer =
    screen_hold_frames;


// ====================================================
// FADING
//
// 0 = fade in
// 1 = hold
// 2 = fade out
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
// PLACEHOLDER SAVE ICON
// ====================================================

save_icon_rotation = 0;
save_icon_speed    = 5;


// ====================================================
// FONT REFERENCES
// ====================================================

font_logo_large =
    asset_get_index(
        "PIXELOPERATORBOLD48"
    );

font_logo_small =
    asset_get_index(
        "PIXELOPERATORBOLD18"
    );

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

// This will be set to a short delay immediately before
// entering MainMenuBackground.
global.startup_menu_input_lock = 0;