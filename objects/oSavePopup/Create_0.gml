/// oSavePopup — Create

depth = -1000000;
visible = true;

// ====================================================
// SAVE ICON
// ====================================================

save_icon_sprite =
    asset_get_index("spriteSaveIcon");

// The source frames are 64x64.
// Scale to roughly 42x42 at the 640x360 GUI size.
save_icon_scale = 0.65;

// Frames 0-13 contain the saving animation.
// Frames 14-15 contain the completion/check animation.
save_loop_first_frame = 0;
save_loop_last_frame  = 13;

save_complete_frame_1 = 14;
save_complete_frame_2 = 15;

// Manual animation position.
save_icon_frame = save_loop_first_frame;

// Approximately 21 source frames per second at 60 FPS.
save_icon_anim_speed = 0.35;


// ====================================================
// POPUP TIMING
// ====================================================

// Total popup lifetime.
popup_total_frames =
    round(room_speed * 2.0);

// Saving animation duration.
saving_frames =
    round(room_speed * 1.35);

// First completion frame duration.
complete_frame_1_frames =
    round(room_speed * 0.18);

// Second completion/check frame occupies the remaining
// time before and during the fade.
fade_frames =
    round(room_speed * 0.40);

popup_timer = 0;


// ====================================================
// VISUAL STATE
// ====================================================

alpha = 1;

// Small panel behind the icon.
panel_enabled = true;

panel_padding = 6;
panel_alpha   = 0.82;

panel_colour =
    make_color_rgb(
        18,
        21,
        28
    );

panel_border_colour =
    make_color_rgb(
        90,
        120,
        170
    );