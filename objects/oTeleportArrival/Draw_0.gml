/// oTeleportArrival — Draw

if (!debug_draw)
{
    exit;
}


draw_set_alpha(0.35);
draw_set_color(c_lime);

draw_circle(
    x,
    y,
    10,
    false
);

draw_line(
    x - 12,
    y,
    x + 12,
    y
);

draw_line(
    x,
    y - 12,
    x,
    y + 12
);


draw_set_alpha(1);
draw_set_color(c_white);

draw_text(
    x + 14,
    y + 14,
    "ARRIVAL "
    +
    arrival_id
);

draw_set_color(c_white);