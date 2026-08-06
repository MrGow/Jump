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
    asset_get_index("MainMenuBackground");


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

screen_hold_seconds = 4.5;

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
// ANIMATED SAVE ICON
// ====================================================

save_icon_sprite =
    asset_get_index("spriteSaveIcon");

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