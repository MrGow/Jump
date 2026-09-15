/// oSavePopup — Draw GUI

if (save_icon_sprite == -1)
{
    exit;
}


var gw =
    display_get_gui_width();

var gh =
    display_get_gui_height();


// ====================================================
// POSITION
//
// MAIN MENU:
// Pull the popup inward so it sits inside the visible
// CRT screen rather than underneath the monitor bezel.
//
// EVERYWHERE ELSE:
// Use the original bottom-right position.
// ====================================================

var _main_menu_room =
    asset_get_index(
        "MainMenuBackground"
    );


var _on_main_menu =
    (
        room == _main_menu_room
    );


// Default gameplay / pause / checkpoint position.
var icon_margin_x = 14;
var icon_margin_y = 14;


// Main menu CRT-safe position.
if (_on_main_menu)
{
    icon_margin_x = 34;
    icon_margin_y = 30;
}


// ====================================================
// ICON SIZE
// ====================================================

var source_w =
    sprite_get_width(
        save_icon_sprite
    );

var source_h =
    sprite_get_height(
        save_icon_sprite
    );


var icon_w =
    source_w *
    save_icon_scale;

var icon_h =
    source_h *
    save_icon_scale;


// ====================================================
// ICON POSITION
// ====================================================

var icon_x =
    round(
        gw -
        icon_margin_x -
        icon_w * 0.5
    );

var icon_y =
    round(
        gh -
        icon_margin_y -
        icon_h * 0.5
    );

// ====================================================
// ANIMATED SAVE ICON
// ====================================================

draw_set_alpha(
    alpha
);

draw_set_color(
    c_white
);


draw_sprite_ext(
    save_icon_sprite,
    floor(
        save_icon_frame
    ),
    icon_x,
    icon_y,
    save_icon_scale,
    save_icon_scale,
    0,
    c_white,
    alpha
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);

draw_set_color(
    c_white
);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);