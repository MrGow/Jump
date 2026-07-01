var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_alpha(alpha);

// Background panel
var w = 170;
var h = 42;

var x1 = gw - w - 16;
var y1 = gh - h - 16;

draw_set_color(make_color_rgb(22,22,28));
draw_roundrect(x1, y1, x1+w, y1+h, false);

// Border
draw_set_color(make_color_rgb(90,120,170));
draw_roundrect(x1, y1, x1+w, y1+h, true);

// Build dot string
var dots = "";

for (var i = 0; i < dot_state; i++)
    dots += ".";

// Text
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x1 + w/2, y1 + h/2, "Saving" + dots);

draw_set_alpha(1);