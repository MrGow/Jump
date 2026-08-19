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


    // Both effect assets are authored vertically, but
    // their visible lines serve opposite purposes:
    //
    // - The repeating ray points away from the gun.
    // - The impact sprite's tail points back at the gun.
    //
    // Using one angle for both made every middle tile
    // extend behind its muzzle, so only the impacts were
    // visible in front of the gun.
    var ray_ang =
        beam_dir + 90;

    var end_ang =
        beam_dir - 90;


    // ------------------------------------------------
    // Repeating middle
    // ------------------------------------------------
    var drawn = 0;

    // Only draw complete tiles here. Drawing a complete
    // 60px tile for a shorter beam makes the impact
    // sprite cover the ray when an obstruction is close.
    while (drawn + tile_len <= len)
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
            ray_ang,
            c_white,
            1
        );


        drawn +=
            tile_len;
    }


    // Crop the final tile to the remaining distance.
    // Do not scale it: scaling a very short remainder
    // compresses the bright pixels at the beginning of
    // the ray until texture sampling makes them vanish.
    // draw_sprite_general supports both source cropping
    // and rotation, so the authored start of the tile is
    // preserved and the beam still ends at the collision.
    var remaining =
        len - drawn;

    if (remaining > 0)
    {
        draw_sprite_general(
            ray_spr,
            ray_frame,

            0,
            0,
            sprite_get_width(
                ray_spr
            ),
            remaining,

            sx +
            lengthdir_x(
                drawn,
                beam_dir
            ),

            sy +
            lengthdir_y(
                drawn,
                beam_dir
            ),

            1,
            1,
            ray_ang,

            c_white,
            c_white,
            c_white,
            c_white,

            1
        );
    }


    // ------------------------------------------------
    // End / impact sprite
    // ------------------------------------------------
    draw_sprite_ext(
        end_spr,
        end_frame,

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

        1,
        1,

        end_ang,

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