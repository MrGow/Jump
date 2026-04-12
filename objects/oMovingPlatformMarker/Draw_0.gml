/// oMovingPlatformMarker — Draw
// Editor / debug style marker

var s = debug_size;

draw_set_alpha(0.75);
draw_set_color(debug_color);

// crosshair
draw_line(x - s, y, x + s, y);
draw_line(x, y - s, x, y + s);

// small box
draw_rectangle(x - 3, y - 3, x + 3, y + 3, false);

draw_set_alpha(1);
draw_set_color(c_white);

// Label
draw_text(x + 8, y - 8, "M" + string(move_id));