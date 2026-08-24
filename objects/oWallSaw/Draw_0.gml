/// oWallSaw — Draw

draw_self();


if (debug_draw)
{
    // =================================================
    // PATROL ROUTE
    // =================================================

    draw_set_alpha(
        0.45
    );


    draw_set_color(
        c_aqua
    );


    draw_line(
        patrol_start_x,
        patrol_start_y,
        patrol_end_x,
        patrol_end_y
    );


    draw_circle(
        patrol_start_x,
        patrol_start_y,
        4,
        false
    );


    draw_circle(
        patrol_end_x,
        patrol_end_y,
        4,
        false
    );


    // =================================================
    // CURRENT LETHAL MASK BOUNDS
    //
    // Because mask_index is now spriteWallSawMask,
    // this bbox should surround only the blade area.
    // =================================================

    draw_set_alpha(
        0.20
    );


    draw_set_color(
        c_red
    );


    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );


    // =================================================
    // INFO
    // =================================================

    draw_set_alpha(
        1
    );


    draw_set_color(
        c_white
    );


    draw_text(
        x + 16,
        y + 16,

        "Wall Saw"
        +
        "\nID: "
        +
        string(patrol_id)
        +
        "\nstate: "
        +
        string(patrol_state)
        +
        "\nfacing: "
        +
        string(facing_direction)
        +
        "\naudio: "
        +
        string(saw_audio_allowed)
        +
        "\ngain: "
        +
        string_format(
            saw_current_gain,
            1,
            2
        )
    );
}