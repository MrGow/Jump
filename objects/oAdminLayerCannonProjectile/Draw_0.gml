/// oAdminLayerCannonProjectile — Draw

draw_self();


if (debug_draw)
{
    // ------------------------------------------------
    // Collision
    // ------------------------------------------------
    draw_set_alpha(0.30);
    draw_set_color(c_red);

    draw_circle(
        x,
        y,
        collision_radius,
        false
    );


    // ------------------------------------------------
    // Velocity
    // ------------------------------------------------
    draw_set_alpha(1);
    draw_set_color(c_aqua);

    draw_line(
        x,
        y,
        x + hsp * 6,
        y + vsp * 6
    );


    // ------------------------------------------------
    // Debug values
    // ------------------------------------------------
    draw_set_color(c_white);

    draw_text(
        x + 8,
        y + 8,

        "angle: " +
        string(move_angle) +

        "\nhsp: " +
        string_format(
            hsp,
            1,
            3
        ) +

        "\nvsp: " +
        string_format(
            vsp,
            1,
            3
        ) +

        "\ntrail accum: " +
        string_format(
            trail_distance_accum,
            1,
            2
        ) +

        "\nlife: " +
        string(life_timer)
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}