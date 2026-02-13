/// oScrapCrusher — Draw (optional)

draw_self();

if (debug_draw) {
    draw_set_alpha(0.35);
    draw_set_color(c_red);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_top + kill_band_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
