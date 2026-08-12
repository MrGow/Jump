/// oAdminLayerCannon — Draw

draw_self();


if (debug_draw)
{
    draw_set_alpha(1);
    draw_set_color(c_aqua);


    // ------------------------------------------------
    // Shooting direction
    // ------------------------------------------------
    draw_line(
        x,
        y,

        x +
        lengthdir_x(
            48,
            shot_angle
        ),

        y +
        lengthdir_y(
            48,
            shot_angle
        )
    );


    // ------------------------------------------------
    // Muzzle point
    // ------------------------------------------------
    draw_circle(
        x +
        lengthdir_x(
            muzzle_dist,
            shot_angle
        ),

        y +
        lengthdir_y(
            muzzle_dist,
            shot_angle
        ),

        3,
        false
    );


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

        "\nframe: " +
        string_format(
            image_index,
            1,
            2
        ) +

        "\ntimer: " +
        string(shot_timer)
    );


    draw_set_color(c_white);
    draw_set_alpha(1);
}