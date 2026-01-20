/// oHazardBox - Draw
draw_self();

draw_set_alpha(alpha);
draw_set_color(color);
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
draw_set_alpha(1);
draw_set_color(c_white);

