/// oStartupController — Create


// ====================================================
// STARTUP PHASE
// ====================================================

global.game_phase =
    "startup";


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
// SCREEN TIMING
// ====================================================

company_hold_seconds = 1.65;
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
// SCREEN FADING
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

fsg_logo_max_width = 200;
fsg_logo_y_offset  = 0;


// ====================================================
// FSG PIECE-BY-PIECE BURN-IN
// ====================================================

fsg_burn_timer = 0;


// Logo remains completely invisible for this brief
// period before the first pieces begin appearing.
fsg_burn_delay_seconds = 0.08;

fsg_burn_delay_frames =
    max(
        0,
        round(
            room_speed *
            fsg_burn_delay_seconds
        )
    );


// Time taken for the complete logo to appear after the
// initial invisible delay.
fsg_burn_duration_seconds = 0.80;

fsg_burn_duration_frames =
    max(
        1,
        round(
            room_speed *
            fsg_burn_duration_seconds
        )
    );


// Size of each independently revealed logo section.
fsg_burn_cell_size = 16;


// Amount of normalized progress used to fade each
// individual section into view.
fsg_burn_cell_fade = 0.12;


// Temporary hot colour used by newly appearing pieces.
fsg_burn_colour =
    make_color_rgb(
        255,
        145,
        55
    );


// Strength of the additive glow around newly appearing
// sections.
fsg_burn_glow_strength = 0.42;


// ====================================================
// FSG BURN SOUND
// ====================================================

fsg_burn_sound_played = false;

snd_fsg_burn =
    asset_get_index(
        "FSGLogoPowerOn1"
    );

fsg_burn_sound_gain = 0.70;


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