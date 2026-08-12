/// oPendulumSaw — Draw


// ====================================================
// DRAW VALUES
// ====================================================

var draw_anchor_x =
    round(anchor_x);

var draw_anchor_y =
    round(anchor_y);

var draw_saw_x =
    round(saw_x);

var draw_saw_y =
    round(saw_y);


// Direction from anchor to saw.
var chain_angle =
    point_direction(
        draw_anchor_x,
        draw_anchor_y,
        draw_saw_x,
        draw_saw_y
    );


// ====================================================
// CHAIN START / END
// ====================================================

// Move slightly away from base.
var chain_start_x =
    draw_anchor_x +
    lengthdir_x(
        chain_start_offset,
        chain_angle
    );

var chain_start_y =
    draw_anchor_y +
    lengthdir_y(
        chain_start_offset,
        chain_angle
    );


// Stop before the middle of the saw.
var chain_end_x =
    draw_saw_x +
    lengthdir_x(
        chain_end_offset,
        chain_angle + 180
    );

var chain_end_y =
    draw_saw_y +
    lengthdir_y(
        chain_end_offset,
        chain_angle + 180
    );


var chain_draw_length =
    point_distance(
        chain_start_x,
        chain_start_y,
        chain_end_x,
        chain_end_y
    );


// ====================================================
// 1. DRAW TILED CHAIN
// ====================================================

if (
    chain_sprite != -1 &&
    chain_draw_length > 0
)
{
    var chain_tile_len =
        max(
            1,
            sprite_get_height(
                chain_sprite
            )
        );


    // Chain asset is authored vertically.
    var chain_draw_angle =
        chain_angle - 270;


    var drawn =
        0;


    while (drawn < chain_draw_length)
    {
        var remaining =
            chain_draw_length -
            drawn;


        var segment_length =
            min(
                chain_tile_len,
                remaining
            );


        var cx =
            chain_start_x +
            lengthdir_x(
                drawn,
                chain_angle
            );

        var cy =
            chain_start_y +
            lengthdir_y(
                drawn,
                chain_angle
            );


        draw_sprite_ext(
            chain_sprite,
            0,
            round(cx),
            round(cy),
            1,
            segment_length /
            chain_tile_len,
            chain_draw_angle,
            c_white,
            1
        );


        drawn +=
            chain_tile_len;
    }
}


// ====================================================
// 2. DRAW BASE
// ====================================================

if (base_sprite != -1)
{
    draw_sprite(
        base_sprite,
        0,
        draw_anchor_x,
        draw_anchor_y
    );
}


// ====================================================
// 3. DRAW SAW
// ====================================================

if (saw_sprite != -1)
{
    var saw_frame =
        floor(
            saw_image_index
        );

    draw_sprite(
        saw_sprite,
        saw_frame,
        draw_saw_x,
        draw_saw_y
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // ------------------------------------------------
    // Anchor
    // ------------------------------------------------
    draw_set_alpha(1);
    draw_set_color(c_aqua);

    draw_circle(
        draw_anchor_x,
        draw_anchor_y,
        3,
        false
    );


    // ------------------------------------------------
    // Pendulum line
    // ------------------------------------------------
    draw_line(
        draw_anchor_x,
        draw_anchor_y,
        draw_saw_x,
        draw_saw_y
    );


    // ------------------------------------------------
    // Saw lethal radius
    // ------------------------------------------------
    draw_set_alpha(0.35);
    draw_set_color(c_red);

    draw_circle(
        draw_saw_x,
        draw_saw_y,
        saw_hit_radius,
        false
    );


    // ------------------------------------------------
    // Rail extents
    // ------------------------------------------------
    if (rail_enabled)
    {
        draw_set_alpha(0.5);
        draw_set_color(c_lime);

        draw_line(
            origin_x -
                rail_distance * 0.5,
            origin_y,

            origin_x +
                rail_distance * 0.5,
            origin_y
        );
    }


    // ------------------------------------------------
    // Text
    // ------------------------------------------------
    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_text(
        draw_anchor_x + 12,
        draw_anchor_y + 12,

        "swing: " +
        string_format(
            swing_angle,
            1,
            1
        ) +

        "\narc: " +
        string(swing_arc) +

        "\nrail: " +
        string(rail_enabled) +

        "\nchain: " +
        string(chain_length)
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}