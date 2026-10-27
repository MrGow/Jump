/// oFirstSpawn — Draw GUI
// 38 GUI pixels matches the intro cutscene's letterbox exactly.
if (!started || bars_amount <= 0) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var bh = round(bars_height * bars_amount);

draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, bh, false);
draw_rectangle(0, gh - bh, gw, gh, false);
draw_set_color(c_white);
