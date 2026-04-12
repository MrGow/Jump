/// oMovingPlatform — Draw
draw_self();

if (debug_draw) {
    draw_set_alpha(0.25);
    draw_set_color(c_aqua);

    if (move_axis == "horizontal") {
        draw_rectangle(start_x - move_range, bbox_top, start_x + move_range + sprite_width, bbox_bottom, false);
    } else {
        draw_rectangle(bbox_left, start_y - move_range, bbox_right, start_y + move_range + sprite_height, false);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}