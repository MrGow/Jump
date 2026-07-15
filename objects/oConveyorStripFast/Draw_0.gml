/// oConveyorStripFast — Draw

draw_self();

if (debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_lime);

    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );

    draw_set_alpha(1);

    var dir =
        ((round(flow_direction) mod 8) + 8) mod 8;

    var angle = dir * 45;

    var cx = (bbox_left + bbox_right) * 0.5;
    var cy = (bbox_top + bbox_bottom) * 0.5;

    draw_line(
        cx,
        cy,
        cx + lengthdir_x(24, angle),
        cy + lengthdir_y(24, angle)
    );

    draw_set_color(c_white);
}