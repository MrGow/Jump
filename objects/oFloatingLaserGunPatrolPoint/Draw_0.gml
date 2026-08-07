/// oFloatingLaserGunPatrolPoint — Draw

if (!debug_draw)
{
    exit;
}

draw_set_alpha(0.30);
draw_set_color(c_aqua);

draw_circle(
    x,
    y,
    8,
    false
);

draw_set_alpha(1);
draw_set_color(c_aqua);

draw_circle(
    x,
    y,
    8,
    true
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

draw_text(
    x + 12,
    y + 12,
    "PATROL ID: " +
    string(patrol_id)
);

draw_set_alpha(1);
draw_set_color(c_white);