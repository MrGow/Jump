/// oChipBankPopup — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_alpha(alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(PIXELOPERATORBOLD18);

var txt = string(display_count) + " / " + string(global.chips_total);

// dark backing
draw_set_color(c_black);
draw_text_transformed(round(gw * 0.5) + 2, round(gh * 0.5) + 2, txt, scale * 1.8, scale * 1.8, 0);

// gold count
draw_set_color(make_color_rgb(255, 220, 80));
draw_text_transformed(round(gw * 0.5), round(gh * 0.5), txt, scale * 1.8, scale * 1.8, 0);

draw_set_font(PIXELOPERATORBOLD14);
draw_set_color(make_color_rgb(200, 200, 200));
draw_text(round(gw * 0.5), round(gh * 0.5) + 42, "CHIP BANKED");

draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);