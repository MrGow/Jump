///==========================================================================
///oGunShipArenaTrigger — Draw GUI (FULL NEW EVENT)
///==========================================================================

if (!completed || scr_game_frozen()) exit;

var p = instance_find(oPlayer, 0);
if (!instance_exists(p) || p.state == "dead") exit;
if (p.x > arena_camera_x + scan_width + 80) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var alpha = 0.55 + 0.45 * abs(sin(go_flash));
var ax = gw - 65;
var ay = gh * 0.49;

draw_set_alpha(alpha);
draw_set_color(make_color_rgb(255, 190, 55));
draw_triangle(ax, ay - 13, ax, ay + 13, ax + 19, ay, false);
draw_rectangle(ax - 23, ay - 6, ax, ay + 6, false);
draw_set_halign(fa_center);
draw_text(ax - 6, ay + 20, "GO!");
draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_alpha(1);
