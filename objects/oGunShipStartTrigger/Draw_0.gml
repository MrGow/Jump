/// oGunShipStartTrigger — Draw

if (!debug_draw)
{
    exit;
}


draw_set_alpha(0.25);

draw_set_color(
    activated
    ? c_red
    : c_lime
);


draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    false
);


draw_set_alpha(1);
draw_set_color(c_white);


draw_text(
    bbox_left,
    bbox_top - 14,
    activated
    ? "GUNSHIP ACTIVE"
    : "GUNSHIP START"
);