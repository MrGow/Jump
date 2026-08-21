// ============================================================================
// oSawPatrolPoint — Draw
// ============================================================================

/// oSawPatrolPoint — Draw

if (!debug_draw)
{
    exit;
}

draw_set_alpha(0.8);
draw_set_color(c_aqua);

draw_circle(x, y, 5, false);
draw_line(x - 8, y, x + 8, y);
draw_line(x, y - 8, x, y + 8);

draw_set_alpha(1);
draw_set_color(c_white);

draw_text(
    x + 8,
    y - 16,
    "Saw " + string(patrol_id)
);