/// oDeathZone — Draw

// Usually invisible in-game.
// Leave debug_draw = true while placing/testing.

if (debug_draw) {
    draw_set_alpha(0.18);
    draw_set_color(c_red);
    draw_rectangle(left, top, right, bottom, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
}