/// oBouncingScrapSpawner — Draw


// The rectangle sprite is an editor-only trigger.
// Do not draw it during normal gameplay.


if (debug_draw)
{
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


    draw_text(
        bbox_left,
        bbox_top - 48,

        "BOUNCING SCRAP"
        +
        "\nACTIVE: "
        +
        string(active)
        +
        "\nSIZE: "
        +
        _size_name
        +
        "\nDIR: "
        +
        string(direction)
    );
}