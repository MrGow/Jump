/// oChipCounterPopup — Draw GUI

if (global.chips_carried <= 0) exit;

var gw = display_get_gui_width();

draw_set_font(PIXELOPERATORBOLD14);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

var txt = "CHIP CARRY  " + string(global.chips_carried);

draw_set_alpha(alpha);

draw_set_color(c_black);
draw_text(gw - 23, 17, txt);

draw_set_color(make_color_rgb(255, 220, 80));
draw_text(gw - 24, 16, txt);

draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);