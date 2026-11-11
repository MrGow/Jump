/// oSmasher — Draw

draw_self();

if (debug_draw)
{
    // Current measured plate underside.
    draw_set_alpha(0.9);
    draw_set_color(c_red);

    draw_line(
        bbox_left,
        plate_y_current,
        bbox_right,
        plate_y_current
    );

    // Raised plate position.
    draw_set_color(c_aqua);

    draw_line(
        bbox_left,
        plate_retracted_y,
        bbox_right,
        plate_retracted_y
    );

    // Current collision bounding box.
    draw_set_alpha(0.20);
    draw_set_color(active ? c_red : c_lime);

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
        x + 8,
        y + 8,
        "frame: " + string(floor(image_index)) +
        "\nplate now: " + string(plate_y_current) +
        "\nplate prev: " + string(plate_y_previous) +
        "\nmovement: " + string(plate_move_y) +
        "\nextension: " + string(plate_extension) +
        "\ndirection: " + string(plate_direction) +
        "\nactive: " + string(active)
    );
}