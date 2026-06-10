/// oAreaTitleTrigger — Draw

draw_set_alpha(0.25);
draw_set_color(c_lime);

draw_rectangle(
    x - trigger_half_width,
    y - trigger_half_height,
    x + trigger_half_width,
    y + trigger_half_height,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);