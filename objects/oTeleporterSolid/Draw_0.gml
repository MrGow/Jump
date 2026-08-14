/// oTeleporterSolid — Draw

if (!debug_draw)
{
    exit;
}


// ====================================================
// MASK VISUAL
// ====================================================

draw_set_alpha(
    0.45
);

draw_set_color(
    c_white
);

draw_sprite(
    spriteTeleporterMaskSolid,
    0,
    x,
    y
);


// ====================================================
// COLLISION BBOX
// ====================================================

draw_set_alpha(
    1
);

draw_set_color(
    c_lime
);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    true
);


// Origin
draw_set_color(
    c_yellow
);

draw_circle(
    x,
    y,
    2,
    false
);


draw_set_alpha(1);
draw_set_color(c_white);