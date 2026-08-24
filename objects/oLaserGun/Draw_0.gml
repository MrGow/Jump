/// oLaserGun — Draw


// ====================================================
// VISUAL OVERLAP SAFETY
// ====================================================

if (!variable_instance_exists(id, "laser_visual_muzzle_overlap"))
{
    laser_visual_muzzle_overlap = 16;
}

if (!variable_instance_exists(id, "laser_visual_end_overlap"))
{
    laser_visual_end_overlap = 3;
}


// ====================================================
// DRAW ACTIVE LASER BEHIND CANNON
// ====================================================

if (active)
{
    var ray_spr =
        asset_get_index(
            "spriteLaserGunRepeatingRay"
        );

    var end_spr =
        asset_get_index(
            "spriteLaserGunShootEnd"
        );


    if (
        ray_spr != -1 &&
        end_spr != -1
    )
    {
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


        // Laser sprite is authored vertically.
        var beam_ang =
            laser_dir - 90;


        var sx =
            laser_start_x;

        var sy =
            laser_start_y;

        var len =
            max(
                0,
                laser_len
            );


        // =================================================
        // OVERLAPPED TILED BEAM
        // =================================================

        var visual_back =
            max(
                0,
                laser_visual_muzzle_overlap
            );

        var visual_end_overlap =
            max(
                0,
                laser_visual_end_overlap
            );


        // Begin beneath the cannon body.
        var drawn =
            -visual_back;


        // Always draw at least one tile.
        var visual_finish =
            max(
                1,
                len +
                visual_end_overlap
            );


        while (drawn < visual_finish)
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


        // =================================================
        // FINAL JOINING TILE
        //
        // The ray sprite extends backwards from its origin.
        // Anchor one final tile to the exact endpoint so
        // there cannot be a gap before the impact sprite.
        // =================================================

        draw_sprite_ext(
            ray_spr,
            ray_frame,

            laser_end_x,
            laser_end_y,

            1,
            1,

            beam_ang,

            c_white,
            1
        );


        // =================================================
        // IMPACT EFFECT
        // =================================================

        draw_sprite_ext(
            end_spr,
            end_frame,

            laser_end_x,
            laser_end_y,

            1,
            1,

            beam_ang,

            c_white,
            1
        );
    }
}


// ====================================================
// DRAW CANNON LAST
// ====================================================

draw_self();


// ====================================================
// DEBUG BEAM
// ====================================================

if (
    debug_draw &&
    active
)
{
    draw_set_alpha(0.55);
    draw_set_color(c_red);


    draw_line_width(
        laser_start_x,
        laser_start_y,
        laser_end_x,
        laser_end_y,
        2
    );


    draw_set_color(c_lime);


    draw_circle(
        laser_start_x,
        laser_start_y,
        2,
        false
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);