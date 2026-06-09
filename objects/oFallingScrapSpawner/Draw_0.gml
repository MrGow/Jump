/// oFallingScrapSpawner — Draw

if (debug_draw)
{
    draw_set_alpha(0.2);
    draw_set_color(c_red);
    draw_rectangle(
        x - spawn_width * 0.5,
        y + spawn_y_offset,
        x + spawn_width * 0.5,
        y + spawn_y_offset + 16,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}