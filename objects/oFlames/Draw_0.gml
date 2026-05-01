draw_self();

draw_set_alpha(0.2);
draw_set_color(c_red);
draw_rectangle(bbox_left + kill_inset_x, bbox_top + kill_inset_top,
               bbox_right - kill_inset_x, bbox_bottom - kill_inset_bottom, false);
draw_set_alpha(1);
draw_set_color(c_white);