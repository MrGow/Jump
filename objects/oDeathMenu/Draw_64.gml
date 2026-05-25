//// oDeathMenu — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Darken background
draw_set_alpha(0.6 * alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Panel
var pw = 300;
var ph = 120;
var px = gw * 0.5 - pw * 0.5;
var py = gh * 0.5 - ph * 0.5;

draw_set_alpha(alpha);
draw_set_color(make_color_rgb(30, 30, 40));
draw_rectangle(px, py, px + pw, py + ph, false);

// Title
draw_set_color(c_white);
draw_text(px + 16, py + 16, "You Died!");

// Prompt
draw_text(px + 16, py + 52, "Press Jump to try again");