/// oZeroGravityZone — Draw

if (!debug_draw)
{
    exit;
}


// ====================================================
// DEBUG ZONE
// ====================================================

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
    bbox_left + 4,
    bbox_top + 4,
    "ZERO-G"
);


draw_set_alpha(1);
draw_set_color(c_white);