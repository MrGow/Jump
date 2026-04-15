/// oMovingPlatform — Draw
draw_self();

if (debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_aqua);

    draw_line(start_x, start_y, target_x, target_y);
    draw_circle(start_x, start_y, 4, false);
    draw_circle(target_x, target_y, 4, false);

    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_text(x + 8, y - 8, "P" + string(move_id));
}