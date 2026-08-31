/// oMainMenuBorder — Draw GUI End


// ====================================================
// MAIN MENU MONITOR BORDER
//
// spriteMainMenuBorder is authored specifically for:
//
//     640 x 360 GUI
//
// Origin:
//
//     Top Centre
//
// Therefore its correct draw position is ALWAYS:
//
//     x = 320
//     y = 0
//
// Do not use display_get_gui_width() here because the
// physical window/display size may differ from the
// fixed internal GUI size.
// ====================================================

if (border_sprite == -1)
{
    exit;
}


// ====================================================
// RESET DRAW STATE
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
// ====================================================

draw_sprite(
    border_sprite,
    0,
    320,
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