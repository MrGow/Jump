/// oScrapChiefBossStartTrigger — Draw

if (!debug_draw)
{
    exit;
}

if (activated)
{
    draw_set_color(c_lime);
}
else
{
    draw_set_color(c_red);
}

draw_set_alpha(0.20);

draw_rectangle(
    x,
    y,
    x + trigger_width,
    y + trigger_height,
    false
);

draw_set_alpha(1);

draw_rectangle(
    x,
    y,
    x + trigger_width,
    y + trigger_height,
    true
);

draw_text(
    x + 4,
    y + 4,
    "BOSS START"
);

draw_set_color(c_white);