/// oLaserGunMultiDirection — Draw


// ====================================================
// DRAW GUN
// ====================================================

draw_self();


// ====================================================
// DEBUG PATROL ROUTE
// ====================================================

if (
    debug_draw &&
    patrol_enabled
)
{
    draw_set_alpha(0.45);
    draw_set_color(c_aqua);

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

    draw_set_alpha(1);
    draw_set_color(c_white);
}


// ====================================================
// DEBUG INFO
// ====================================================

if (debug_draw)
{
    draw_set_color(c_white);

    draw_text(
        x + 16,
        y + 16,

        "state: " +
        string(state) +

        "\npatrol: " +
        string(patrol_enabled) +

        "\nID: " +
        string(patrol_id) +

        "\nt: " +
        string_format(
            patrol_t,
            1,
            2
        )
    );
}


// ====================================================
// NO ACTIVE LASERS
// ====================================================

if (!active)
{
    exit;
}


// ====================================================
// LASER SPRITES
// ====================================================

var ray_spr =
    spriteLaserGunRepeatingRay;

var end_spr =
    spriteLaserGunShootEnd;


var ray_frames =
    max(
        1,
        sprite_get_number(
            ray_spr
        )
    );

var end_frames =
    max(
        1,
        sprite_get_number(
            end_spr
        )
    );


var fx_frame =
    floor(
        laser_fx_frame
    );

var ray_frame =
    fx_frame
    mod
    ray_frames;

var end_frame =
    fx_frame
    mod
    end_frames;


var tile_len =
    sprite_get_height(
        ray_spr
    );

if (tile_len <= 0)
{
    tile_len = 8;
}


// ====================================================
// DRAW ALL EIGHT BEAMS
// ====================================================

for (
    var beam_i = 0;
    beam_i < laser_count;
    beam_i++
)
{
    var beam_dir =
        laser_dirs[beam_i];

    var sx =
        laser_start_x[beam_i];

    var sy =
        laser_start_y[beam_i];

    var len =
        laser_len[beam_i];


    // Repeating-ray asset is authored vertically.
    var beam_ang =
        beam_dir - 90;


    // ------------------------------------------------
    // Repeating middle
    // ------------------------------------------------
    var drawn = 0;

    while (drawn < len)
    {
        var rx =
            sx +
            lengthdir_x(
                drawn,
                beam_dir
            );

        var ry =
            sy +
            lengthdir_y(
                drawn,
                beam_dir
            );


        draw_sprite_ext(
            ray_spr,
            ray_frame,
            rx,
            ry,
            1,
            1,
            beam_ang,
            c_white,
            1
        );


        drawn +=
            tile_len;
    }


    // ------------------------------------------------
    // End / impact sprite
    // ------------------------------------------------
    var end_join_len =
        max(
            0,
            floor(
                len /
                tile_len
            )
            *
            tile_len
        );


    draw_sprite_ext(
        end_spr,
        end_frame,

        sx +
        lengthdir_x(
            end_join_len,
            beam_dir
        ),

        sy +
        lengthdir_y(
            end_join_len,
            beam_dir
        ),

        1,
        1,

        beam_ang,

        c_white,
        1
    );


    // ------------------------------------------------
    // Debug beam
    // ------------------------------------------------
    if (debug_draw)
    {
        draw_set_alpha(0.45);
        draw_set_color(c_red);

        draw_line_width(
            sx,
            sy,

            sx +
            lengthdir_x(
                len,
                beam_dir
            ),

            sy +
            lengthdir_y(
                len,
                beam_dir
            ),

            2
        );

        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}