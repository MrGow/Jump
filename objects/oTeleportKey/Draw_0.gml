/// oTeleportKey — Draw

if (visible)
{
    draw_self();
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.35);
    draw_set_color(c_aqua);

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
        x + 10,
        y + 10,

        "KEY "
        +
        link_id
        +
        "\n"
        +
        key_state
    );

    draw_set_color(c_white);
}