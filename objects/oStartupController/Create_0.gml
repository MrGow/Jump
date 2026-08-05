/// oStartupController — Create

// ====================================================
// DISPLAY
// ====================================================

visible = true;
depth   = -1000000;

// Keep startup GUI consistent with the rest of JumpBot.
if (!variable_global_exists("GUI_W")) global.GUI_W = 800;
if (!variable_global_exists("GUI_H")) global.GUI_H = 450;

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
// 1 = Save warning
// 2 = leaving startup room
// ====================================================

startup_screen = 0;


// ====================================================
// TIMING
// ====================================================

// Each screen remains fully visible for this long.
// Change to 3.0 or 4.0 if preferred.
screen_hold_seconds = 3.5;

screen_hold_frames =
    max(
        1,
        round(room_speed * screen_hold_seconds)
    );

screen_timer = screen_hold_frames;


// ====================================================
// FADING
//
// 0 = fading in
// 1 = holding
// 2 = fading out
// ====================================================

fade_state = 0;
fade_alpha = 0;

// Around 0.5 seconds at 60 FPS.
fade_speed = 0.06;


// ====================================================
// INPUT
// ====================================================

// Prevent an input already held when the game launches
// from immediately skipping the first splash.
input_armed = false;

// This becomes true once all confirm inputs have been
// released at least once.
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
    asset_get_index("PIXELOPERATORBOLD48");

font_logo_small =
    asset_get_index("PIXELOPERATORBOLD18");

font_warning_title =
    asset_get_index("PIXELOPERATORBOLD32");

font_warning_body =
    asset_get_index("PIXELOPERATORREGULAR16");

font_continue =
    asset_get_index("PIXELOPERATORREGULAR10");


// ====================================================
// MENU INPUT RELEASE GUARD
// ====================================================

// Main-menu code can read this global to avoid accepting
// the final splash-screen skip press.
global.startup_menu_input_lock = 0;