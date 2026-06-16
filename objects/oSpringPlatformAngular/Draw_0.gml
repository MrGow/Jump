/// oSpringPlatformAngular — Draw

draw_self();

if (debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(bbox_left, bbox_top + 3, bbox_right, bbox_bottom - 3, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}