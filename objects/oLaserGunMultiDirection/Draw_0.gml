/// oLaserGunMultiDirection — Draw


// ====================================================
// NO ACTIVE LASERS
//
// If not firing, just draw the gun and debug.
// ====================================================

if (!active)
{
    draw_self();


    // ------------------------------------------------
    // DEBUG PATROL ROUTE
    // ------------------------------------------------

    if (
        debug_draw
        &&
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


    // ------------------------------------------------
    // DEBUG INFO
    // ------------------------------------------------

    if (debug_draw)
    {
        draw_set_color(c_white);

        draw_text(
            x + 16,
            y + 16,

            "state: "
            +
            string(state)
            +
            "\nactive: "
            +
            string(active)
            +
            "\npatrol: "
            +
            string(patrol_enabled)
            +
            "\nID: "
            +
            string(patrol_id)
            +
            "\nstart dist: "
            +
            string(laser_start_dist)
        );
    }


    exit;
}


// ====================================================
// LASER SPRITES
// ====================================================

var ray_spr =
    asset_get_index(
        "spriteLaserGunRepeatingRay"
    );

var end_spr =
    asset_get_index(
        "spriteLaserGunShootEnd"
    );


if (
    ray_spr != -1
    &&
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
        tile_len =
            8;
    }


    // =================================================
    // DRAW ALL EIGHT BEAMS FIRST
    //
    // These are deliberately drawn BEFORE the gun.
    // Any overlap into the cannon body gets covered by
    // draw_self() later.
    // =================================================

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
            max(
                0,
                laser_len[beam_i]
            );


        // ------------------------------------------------
        // VISUAL START
        //
        // Push beam backwards into cannon.
        // Since the cannon is drawn later, excess overlap
        // is safely hidden.
        // ------------------------------------------------

        var visual_back =
            max(
                0,
                laser_visual_muzzle_overlap
            );


        var draw_sx =
            sx
            -
            lengthdir_x(
                visual_back,
                beam_dir
            );


        var draw_sy =
            sy
            -
            lengthdir_y(
                visual_back,
                beam_dir
            );


        var draw_len =
            len
            +
            visual_back
            +
            max(
                0,
                laser_visual_end_overlap
            );


        var ray_ang =
            beam_dir - 90;


        var end_ang =
            beam_dir - 90;


        // =================================================
        // CONTINUOUS BEAM
        // =================================================

        if (draw_len > 0)
        {
            draw_sprite_ext(
                ray_spr,
                ray_frame,

                draw_sx,
                draw_sy,

                1,
                -draw_len / tile_len,

                ray_ang,

                c_white,
                1
            );
        }


        // =================================================
        // IMPACT FX
        // =================================================

        var ex =
            laser_end_x[beam_i];


        var ey =
            laser_end_y[beam_i];


        draw_sprite_ext(
            end_spr,
            end_frame,

            ex,
            ey,

            1,
            1,

            end_ang,

            c_white,
            1
        );


        // =================================================
        // DEBUG BEAM
        // =================================================

        if (debug_draw)
        {
            draw_set_alpha(
                0.55
            );

            draw_set_color(
                c_red
            );


            draw_line_width(
                sx,
                sy,
                ex,
                ey,
                2
            );


            draw_set_color(
                c_lime
            );


            draw_circle(
                sx,
                sy,
                2,
                false
            );


            draw_set_alpha(
                1
            );

            draw_set_color(
                c_white
            );
        }
    }
}


// ====================================================
// DRAW GUN LAST
//
// This is the important change.
//
// The cannon now sits visually ABOVE its own laser
// beams, hiding any excess overlap underneath the body.
// ====================================================

draw_self();


// ====================================================
// DEBUG PATROL ROUTE
// ====================================================

if (
    debug_draw
    &&
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

        "state: "
        +
        string(state)
        +
        "\nactive: "
        +
        string(active)
        +
        "\npatrol: "
        +
        string(patrol_enabled)
        +
        "\nID: "
        +
        string(patrol_id)
        +
        "\nstart dist: "
        +
        string(laser_start_dist)
    );
}