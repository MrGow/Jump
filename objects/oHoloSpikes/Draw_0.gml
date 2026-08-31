/// oHoloSpike — Draw

draw_self();


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.25);


    draw_set_color(
        active
        ? c_red
        : c_aqua
    );


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
        x + 12,
        y + 12,

        "state: " +
        string(state) +

        "\nactive: " +
        string(active) +

        "\ndir: " +
        string(spike_direction) +

        "\nimage_index: " +
        string_format(
            image_index,
            1,
            2
        ) +

        "\ndrawn frame: " +
        string(
            floor(image_index)
        ) +

        "\nretract timer: " +
        string(retracted_timer) +

        "\nup timer: " +
        string(up_timer)
    );


    draw_set_alpha(1);

    draw_set_color(c_white);
}