/// oVentField - Draw
draw_self();

if (debug_draw)
{
    draw_set_alpha(0.20);
    draw_set_color(c_aqua);
    draw_circle(x, y, radius, false);

    draw_set_alpha(0.65);
    var lx = x + wind_dir_x * radius * 0.70;
    var ly = y + wind_dir_y * radius * 0.70;
    draw_line(x, y, lx, ly);

    draw_set_alpha(1);
    draw_set_color(c_white);
}
