/// oHoloPlatformTrigger — Draw

if (!debug_draw)
{
    exit;
}

draw_set_alpha(0.20);
draw_set_color(c_aqua);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    false
);

draw_set_alpha(1);
draw_set_color(c_aqua);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    true
);

draw_text(
    bbox_left,
    bbox_top - 18,
    used
        ? "HOLO TRIGGER: USED"
        : "HOLO TRIGGER: READY"
);

draw_set_alpha(1);
draw_set_color(c_white);