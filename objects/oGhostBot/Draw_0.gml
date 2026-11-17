/// oGhostBot — Draw

// ========================================
// TEMPORARY BOT RECTANGLE
// ========================================

draw_set_alpha(1);

// Main body
draw_set_color(bot_colour);

draw_rectangle(
    x - bot_width * 0.5,
    y - bot_height * 0.5,
    x + bot_width * 0.5,
    y + bot_height * 0.5,
    false
);

// CRT screen
draw_set_color(c_black);

draw_rectangle(
    x - 10,
    y - 14,
    x + 10,
    y + 3,
    false
);

// Two amber eyes
draw_set_color(make_color_rgb(255, 185, 70));

draw_rectangle(x - 6, y - 9, x - 3, y - 3, false);
draw_rectangle(x + 3, y - 9, x + 6, y - 3, false);

// Reset
draw_set_color(c_white);
draw_set_alpha(1);