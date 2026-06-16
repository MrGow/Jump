/// oConveyorVerticalUp — Draw

draw_self();

if (debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_aqua);

    draw_rectangle(
        bbox_left - attach_pad_x,
        bbox_top,
        bbox_right + attach_pad_x,
        bbox_bottom,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}