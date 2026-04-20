/// oConveyor - Draw
draw_self();

if (debug_draw)
{
    draw_set_alpha(0.6);
    draw_set_color(c_yellow);
    draw_line(x, y, x + belt_dir * 16, y);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
