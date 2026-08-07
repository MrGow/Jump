/// oFloatingLaserGun — Draw


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
// DEBUG TEXT
// ====================================================

if (debug_draw)
{
    draw_set_color(c_white);

    draw_text(
        x + 12,
        y + 12,

        "state: " +
        string(state) +

        "\nface: " +
        string(laser_facing) +

        "\npatrol: " +
        string(patrol_enabled) +

        "\nID: " +
        string(patrol_id) +

        "\npoint: " +
        string(patrol_point) +

        "\nt: " +
        string_format(
            patrol_t,
            1,
            2
        )
    );
}


// ====================================================
// NO LASER
// ====================================================

if (!active)
{
    exit;
}


// ====================================================
// LASER VISUALS
// ====================================================

var sx =
    laser_start_x;

var sy =
    laser_start_y;

var len =
    laser_len;


var ray_spr =
    spriteLaserGunRepeatingRay;

var end_spr =
    spriteLaserGunShootEnd;


var fx_frame =
    floor(
        laser_fx_frame
    );


var ray_frame =
    fx_frame
    mod
    sprite_get_number(
        ray_spr
    );

var end_frame =
    fx_frame
    mod
    sprite_get_number(
        end_spr
    );


var tile_len =
    sprite_get_height(
        ray_spr
    );

if (tile_len <= 0)
{
    tile_len = 8;
}


// Laser sprite is authored vertically.
var beam_ang =
    laser_dir - 90;


// ====================================================
// REPEATING BEAM
// ====================================================

var drawn = 0;

while (drawn < len)
{
    var rx =
        sx +
        lengthdir_x(
            drawn,
            laser_dir
        );

    var ry =
        sy +
        lengthdir_y(
            drawn,
            laser_dir
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


// ====================================================
// IMPACT / END EFFECT
// ====================================================

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
        laser_dir
    ),

    sy +
    lengthdir_y(
        end_join_len,
        laser_dir
    ),

    1,
    1,

    beam_ang,

    c_white,
    1
);


// ====================================================
// DEBUG BEAM
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.5);
    draw_set_color(c_red);

    draw_line_width(
        sx,
        sy,

        sx +
        lengthdir_x(
            len,
            laser_dir
        ),

        sy +
        lengthdir_y(
            len,
            laser_dir
        ),

        2
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}