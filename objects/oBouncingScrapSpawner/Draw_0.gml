/// oBouncingScrapSpawner — Draw


if (debug_draw)
{
    // =================================================
    // TRIGGER AREA
    // =================================================

    draw_set_alpha(
        0.20
    );


    draw_set_color(
        active
        ? c_lime
        : c_red
    );


    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );


    draw_set_alpha(1);


    // =================================================
    // SPAWN POSITION DEBUG
    // =================================================

    var _debug_spawn_x =
        x +
        spawn_x_offset;


    var _debug_spawn_y =
        y +
        spawn_y_offset;


    draw_set_color(
        c_yellow
    );


    if (spawn_mode == 1)
    {
        // Exact single-ball spawn point.

        draw_circle(
            _debug_spawn_x,
            _debug_spawn_y,
            4,
            false
        );


        draw_line(
            _debug_spawn_x - 8,
            _debug_spawn_y,
            _debug_spawn_x + 8,
            _debug_spawn_y
        );


        draw_line(
            _debug_spawn_x,
            _debug_spawn_y - 8,
            _debug_spawn_x,
            _debug_spawn_y + 8
        );
    }
    else
    {
        // Continuous random spawn range.

        var _half_width =
            spawn_width * 0.5;


        draw_line(
            _debug_spawn_x - _half_width,
            _debug_spawn_y,
            _debug_spawn_x + _half_width,
            _debug_spawn_y
        );
    }


    // =================================================
    // DEBUG TEXT
    // =================================================

    draw_set_color(
        c_white
    );


    var _size_name =
        "MEDIUM";


    switch (scrap_size)
    {
        case 0:
            _size_name = "SMALL";
        break;

        case 1:
            _size_name = "MEDIUM";
        break;

        case 2:
            _size_name = "LARGE";
        break;

        case 3:
            _size_name = "RANDOM";
        break;
    }


    var _mode_name =
        (spawn_mode == 1)
        ? "SINGLE"
        : "CONTINUOUS";


    draw_text(
        bbox_left,
        bbox_top - 64,

        "BOUNCING SCRAP"
        +
        "\nMODE: "
        +
        _mode_name
        +
        "\nID: "
        +
        string(trigger_id)
        +
        "\nSIZE: "
        +
        _size_name
        +
        "\nDIR: "
        +
        string(travel_direction)
        +
        "\nFIRED: "
        +
        string(single_fired)
    );
}