/// oAdminLayerCannon — Draw

draw_self();


if (debug_draw)
{
    // =================================================
    // EXACT MUZZLE POINT
    // =================================================

    var debug_muzzle_x =
        x +
        muzzle_x_offset +
        muzzle_nudge_x;

    var debug_muzzle_y =
        y +
        muzzle_y_offset +
        muzzle_nudge_y;


    // ------------------------------------------------
    // Projectile direction
    // ------------------------------------------------
    draw_set_alpha(1);
    draw_set_color(c_aqua);

    draw_line(
        debug_muzzle_x,
        debug_muzzle_y,

        debug_muzzle_x +
        lengthdir_x(
            48,
            shot_angle
        ),

        debug_muzzle_y +
        lengthdir_y(
            48,
            shot_angle
        )
    );


    // ------------------------------------------------
    // Exact projectile spawn point
    // ------------------------------------------------
    draw_set_color(c_lime);

    draw_circle(
        debug_muzzle_x,
        debug_muzzle_y,
        3,
        false
    );


    // ------------------------------------------------
    // Debug text
    // ------------------------------------------------
    draw_set_color(c_white);

    draw_text(
        x + 16,
        y + 16,

        "state: " +
        string(state) +

        "\ndir: " +
        string(cannon_direction) +

        "\nangle: " +
        string(shot_angle) +

        "\nmuzzle: " +
        string(muzzle_x_offset) +
        ", " +
        string(muzzle_y_offset) +

        "\nframe: " +
        string_format(
            image_index,
            1,
            2
        ) +

        "\ntimer: " +
        string(shot_timer)
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}