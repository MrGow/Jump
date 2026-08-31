/// oMainMenu — Draw GUI End


// ============================================================================
// MAIN MENU MONITOR BORDER
//
// Draw GUI End guarantees this is rendered AFTER:
//
// - gameplay demo
// - menu/logo
// - save/settings UI
// - scanlines
// - CRT flicker
// - rolling interference
// - CRT glitches
//
// Therefore the physical metal bezel stays completely
// clean and sits in front of the CRT display.
// ============================================================================

var gw =
    display_get_gui_width();


// ====================================================
// GET BORDER SPRITE
// ====================================================

var border_sprite =
    asset_get_index(
        "spriteMainMenuBorder"
    );


if (border_sprite == -1)
{
    exit;
}


// ====================================================
// RESET DRAW STATE
//
// Important because the previous Draw GUI event uses
// alpha/colour changes for the CRT effects.
// ====================================================

draw_set_alpha(
    1
);

draw_set_color(
    c_white
);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);


// ====================================================
// DRAW BORDER
//
// spriteMainMenuBorder:
//
// Origin = Top Centre
// Size   = 640 x 360
//
// Therefore:
//     X = centre of GUI
//     Y = 0
// ====================================================

draw_sprite(
    border_sprite,
    0,
    round(gw * 0.5),
    0
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(
    1
);

draw_set_color(
    c_white
);