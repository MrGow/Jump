/// oDirectionalJumper — Draw

draw_self();


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_aqua);


    // ------------------------------------------------
    // Collision bounds
    // ------------------------------------------------
    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );


    draw_set_alpha(1);


    // ------------------------------------------------
    // Launch direction
    // ------------------------------------------------
    var dir =
        (
            (
                round(jump_direction)
                mod 8
            )
            +
            8
        )
        mod 8;


    var angle =
        dir * 45;


    var cx =
        (
            bbox_left +
            bbox_right
        )
        * 0.5;


    var cy =
        (
            bbox_top +
            bbox_bottom
        )
        * 0.5;


    draw_line(
        cx,
        cy,

        cx +
        lengthdir_x(
            24,
            angle
        ),

        cy +
        lengthdir_y(
            24,
            angle
        )
    );


    // ------------------------------------------------
    // State text
    // ------------------------------------------------
    draw_set_color(c_white);

    draw_text(
        cx + 12,
        cy + 12,

        "dir: " +
        string(dir) +

        "\nstrength: " +
        string(jump_strength) +

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