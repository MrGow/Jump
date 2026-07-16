/// oMillipedeSpawner — Draw

if (!debug_draw)
{
    exit;
}

draw_set_alpha(0.5);
draw_set_color(c_yellow);

draw_rectangle(
    x - 8,
    y - 8,
    x + 8,
    y + 8,
    true
);

draw_text(
    x + 12,
    y - 8,
    "Millipede Spawner " +
    string(route_id)
);

draw_set_alpha(1);
draw_set_color(c_white);