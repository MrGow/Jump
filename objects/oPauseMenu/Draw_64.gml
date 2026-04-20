/// oPauseMenu — Draw GUI

// Force fixed GUI space
var gw = global.GAME_W;
var gh = global.GAME_H;
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Absolute screen center in GUI space
var cx = gw * 0.5;
var cy = gh * 0.5;

// Dark overlay
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Panel
var pw = 220;
var ph = 150;
var px = floor(cx - pw * 0.5);
var py = floor(cy - ph * 0.5);

draw_set_alpha(1);
draw_set_color(make_color_rgb(40, 40, 55));
draw_rectangle(px, py, px + pw, py + ph, false);

draw_set_color(c_white);
draw_rectangle(px, py, px + pw, py + ph, true);

// Title
draw_text(px + 12, py + 10, "Paused");