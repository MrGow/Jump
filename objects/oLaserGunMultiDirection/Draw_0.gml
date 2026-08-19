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
    // Continuous middle
    // ------------------------------------------------
    // The authored middle is a straight rectangle with
    // its origin at the top centre. Stretching that one
    // sprite along its local Y axis gives an exact beam
    // from the muzzle to the collision point. It avoids
    // tile joins, source-crop origin differences, and a
    // misplaced final piece.
    if (len > 0)
    {
        draw_sprite_ext(
            ray_spr,
            ray_frame,
            sx,
            sy,
            1,
            len / tile_len,
            ray_ang,
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