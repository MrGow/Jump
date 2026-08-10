/// oDoubleJumper — Draw

draw_self();


if (debug_draw)
{
    // ------------------------------------------------
    // Collision area
    // ------------------------------------------------
    draw_set_alpha(0.25);
    draw_set_color(c_fuchsia);

    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );


    draw_set_alpha(1);
    draw_set_color(c_white);


    // ------------------------------------------------
    // Debug info
    // ------------------------------------------------
    draw_text(
        x + 12,
        y + 12,

        "DOUBLE JUMPER" +

        "\npower: " +
        string(double_jump_power) +

        "\nused: " +
        string(used_this_contact) +

        "\nanim: " +
        string(use_anim_playing) +

        "\nframe: " +
        string_format(
            image_index,
            1,
            2
        )
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}