/// oStartupController — Draw GUI


// ====================================================
// RESET GPU AND DRAW STATE
//
// The burn glow uses additive blending. Always restore
// normal blending before drawing the background so the
// previous frame cannot produce a full-screen tint.
// ====================================================

gpu_set_blendmode(
    bm_normal
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


var gw =
    display_get_gui_width();

var gh =
    display_get_gui_height();


// ====================================================
// BACKGROUND
// ====================================================

draw_set_color(
    make_color_rgb(
        20,
        29,
        40
    )
);

draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);

draw_set_color(c_white);


// ====================================================
// SCREEN 0 — FULL SEND GAMES
// ====================================================

if (startup_screen == 0)
{
    var logo_centre_x =
        gw * 0.5;

    var logo_centre_y =
        gh * 0.5 +
        fsg_logo_y_offset;


    if (fsg_logo_sprite != -1)
    {
        var logo_width =
            sprite_get_width(
                fsg_logo_sprite
            );

        var logo_height =
            sprite_get_height(
                fsg_logo_sprite
            );

        var logo_scale = 1;


        if (logo_width > 0)
        {
            logo_scale =
                min(
                    1,
                    fsg_logo_max_width /
                    logo_width
                );
        }


        // --------------------------------------------
        // SPRITE DRAWING POSITION
        //
        // draw_sprite_part_ext() uses the top-left of
        // each selected part rather than the sprite's
        // normal origin. Convert the centred logo
        // position into its scaled top-left position.
        // --------------------------------------------

        var logo_origin_x =
            sprite_get_xoffset(
                fsg_logo_sprite
            );

        var logo_origin_y =
            sprite_get_yoffset(
                fsg_logo_sprite
            );

        var logo_left =
            logo_centre_x -
            logo_origin_x *
            logo_scale;

        var logo_top =
            logo_centre_y -
            logo_origin_y *
            logo_scale;


        // --------------------------------------------
        // BURN PROGRESS
        //
        // The logo is completely invisible during the
        // initial delay.
        // --------------------------------------------

        var burn_elapsed =
            max(
                0,
                fsg_burn_timer -
                fsg_burn_delay_frames
            );

        var burn_progress =
            clamp(
                burn_elapsed /
                max(
                    1,
                    fsg_burn_duration_frames
                ),
                0,
                1
            );


        var burn_cell =
            max(
                2,
                round(
                    fsg_burn_cell_size
                )
            );

        var burn_cell_fade =
            max(
                0.01,
                fsg_burn_cell_fade
            );


        var burn_columns =
            max(
                1,
                ceil(
                    logo_width /
                    burn_cell
                )
            );

        var burn_rows =
            max(
                1,
                ceil(
                    logo_height /
                    burn_cell
                )
            );


        // --------------------------------------------
        // ADDITIVE BURN GLOW
        //
        // Only newly appearing pieces glow. The glow
        // is drawn beneath the ordinary logo pieces.
        // --------------------------------------------

        if (
            burn_progress > 0 &&
            burn_progress < 1
        )
        {
            gpu_set_blendmode(
                bm_add
            );


            for (
                var glow_row = 0;
                glow_row < burn_rows;
                glow_row++
            )
            {
                var glow_part_y =
                    glow_row *
                    burn_cell;

                var glow_part_height =
                    min(
                        burn_cell,
                        logo_height -
                        glow_part_y
                    );


                for (
                    var glow_column = 0;
                    glow_column < burn_columns;
                    glow_column++
                )
                {
                    var glow_part_x =
                        glow_column *
                        burn_cell;

                    var glow_part_width =
                        min(
                            burn_cell,
                            logo_width -
                            glow_part_x
                        );


                    // --------------------------------
                    // CELL REVEAL ORDER
                    //
                    // Radial distance creates a loose
                    // centre-out spread. The hash stops
                    // the result looking like a perfect
                    // circular wipe.
                    // --------------------------------

                    var glow_normal_x =
                        (
                            glow_part_x +
                            glow_part_width * 0.5
                        )
                        /
                        max(
                            1,
                            logo_width
                        );

                    var glow_normal_y =
                        (
                            glow_part_y +
                            glow_part_height * 0.5
                        )
                        /
                        max(
                            1,
                            logo_height
                        );


                    var glow_distance_x =
                        glow_normal_x -
                        0.5;

                    var glow_distance_y =
                        glow_normal_y -
                        0.5;


                    var glow_radial =
                        clamp(
                            point_distance(
                                0,
                                0,
                                glow_distance_x,
                                glow_distance_y
                            )
                            /
                            0.707107,
                            0,
                            1
                        );


                    var glow_hash =
                        frac(
                            sin(
                                glow_column *
                                12.9898 +
                                glow_row *
                                78.233
                            )
                            *
                            43758.5453
                        );


                    var glow_delay =
                        clamp(
                            glow_radial * 0.62 +
                            glow_hash * 0.10,
                            0,
                            0.74
                        );


                    var glow_local_progress =
                        clamp(
                            (
                                burn_progress -
                                glow_delay
                            )
                            /
                            burn_cell_fade,
                            0,
                            1
                        );


                    // Glow rises and falls while this
                    // particular piece is appearing.
                    var glow_amount =
                        sin(
                            glow_local_progress *
                            pi
                        )
                        *
                        fsg_burn_glow_strength;


                    if (glow_amount > 0.001)
                    {
                        var glow_draw_x =
                            logo_left +
                            glow_part_x *
                            logo_scale;

                        var glow_draw_y =
                            logo_top +
                            glow_part_y *
                            logo_scale;

                        var glow_alpha =
                            fade_alpha *
                            glow_amount;


                        // Four one-pixel copies create a
                        // compact glow around the piece.
                        draw_sprite_part_ext(
                            fsg_logo_sprite,
                            0,

                            glow_part_x,
                            glow_part_y,
                            glow_part_width,
                            glow_part_height,

                            glow_draw_x - 1,
                            glow_draw_y,

                            logo_scale,
                            logo_scale,

                            fsg_burn_colour,
                            glow_alpha
                        );


                        draw_sprite_part_ext(
                            fsg_logo_sprite,
                            0,

                            glow_part_x,
                            glow_part_y,
                            glow_part_width,
                            glow_part_height,

                            glow_draw_x + 1,
                            glow_draw_y,

                            logo_scale,
                            logo_scale,

                            fsg_burn_colour,
                            glow_alpha
                        );


                        draw_sprite_part_ext(
                            fsg_logo_sprite,
                            0,

                            glow_part_x,
                            glow_part_y,
                            glow_part_width,
                            glow_part_height,

                            glow_draw_x,
                            glow_draw_y - 1,

                            logo_scale,
                            logo_scale,

                            fsg_burn_colour,
                            glow_alpha
                        );


                        draw_sprite_part_ext(
                            fsg_logo_sprite,
                            0,

                            glow_part_x,
                            glow_part_y,
                            glow_part_width,
                            glow_part_height,

                            glow_draw_x,
                            glow_draw_y + 1,

                            logo_scale,
                            logo_scale,

                            fsg_burn_colour,
                            glow_alpha
                        );
                    }
                }
            }


            // Critical: prevent the additive glow from
            // affecting anything drawn afterward.
            gpu_set_blendmode(
                bm_normal
            );
        }


        // Extra safety in case the glow block did not run
        // or was interrupted by a future code change.
        gpu_set_blendmode(
            bm_normal
        );


        // --------------------------------------------
        // VISIBLE LOGO PIECES
        // --------------------------------------------

        if (burn_progress > 0)
        {
            for (
                var piece_row = 0;
                piece_row < burn_rows;
                piece_row++
            )
            {
                var piece_part_y =
                    piece_row *
                    burn_cell;

                var piece_part_height =
                    min(
                        burn_cell,
                        logo_height -
                        piece_part_y
                    );


                for (
                    var piece_column = 0;
                    piece_column < burn_columns;
                    piece_column++
                )
                {
                    var piece_part_x =
                        piece_column *
                        burn_cell;

                    var piece_part_width =
                        min(
                            burn_cell,
                            logo_width -
                            piece_part_x
                        );


                    var piece_normal_x =
                        (
                            piece_part_x +
                            piece_part_width * 0.5
                        )
                        /
                        max(
                            1,
                            logo_width
                        );

                    var piece_normal_y =
                        (
                            piece_part_y +
                            piece_part_height * 0.5
                        )
                        /
                        max(
                            1,
                            logo_height
                        );


                    var piece_distance_x =
                        piece_normal_x -
                        0.5;

                    var piece_distance_y =
                        piece_normal_y -
                        0.5;


                    var piece_radial =
                        clamp(
                            point_distance(
                                0,
                                0,
                                piece_distance_x,
                                piece_distance_y
                            )
                            /
                            0.707107,
                            0,
                            1
                        );


                    var piece_hash =
                        frac(
                            sin(
                                piece_column *
                                12.9898 +
                                piece_row *
                                78.233
                            )
                            *
                            43758.5453
                        );


                    var piece_delay =
                        clamp(
                            piece_radial * 0.62 +
                            piece_hash * 0.10,
                            0,
                            0.74
                        );


                    var piece_progress =
                        clamp(
                            (
                                burn_progress -
                                piece_delay
                            )
                            /
                            burn_cell_fade,
                            0,
                            1
                        );


                    if (piece_progress > 0)
                    {
                        var piece_draw_x =
                            logo_left +
                            piece_part_x *
                            logo_scale;

                        var piece_draw_y =
                            logo_top +
                            piece_part_y *
                            logo_scale;


                        // Newly appearing pieces begin
                        // orange and settle into white.
                        var piece_heat =
                            1 -
                            clamp(
                                piece_progress /
                                0.70,
                                0,
                                1
                            );


                        var piece_colour =
                            merge_color(
                                c_white,
                                fsg_burn_colour,
                                piece_heat
                            );


                        draw_sprite_part_ext(
                            fsg_logo_sprite,
                            0,

                            piece_part_x,
                            piece_part_y,
                            piece_part_width,
                            piece_part_height,

                            piece_draw_x,
                            piece_draw_y,

                            logo_scale,
                            logo_scale,

                            piece_colour,

                            fade_alpha *
                            piece_progress
                        );
                    }
                }
            }
        }


        // --------------------------------------------
        // COMPLETED CLEAN LOGO
        //
        // Once the burn is complete, draw the original
        // sprite normally. This removes any tiny seams
        // between the independently drawn sections.
        // --------------------------------------------

        if (burn_progress >= 0.995)
        {
            gpu_set_blendmode(
                bm_normal
            );

            draw_sprite_ext(
                fsg_logo_sprite,
                0,

                logo_centre_x,
                logo_centre_y,

                logo_scale,
                logo_scale,

                0,

                c_white,
                fade_alpha
            );
        }
    }
}


// ====================================================
// SCREEN 1 — SAVE WARNING
// ====================================================

else if (startup_screen == 1)
{
    gpu_set_blendmode(
        bm_normal
    );

    draw_set_alpha(
        fade_alpha
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );


    var warning_centre_x =
        gw * 0.5;


    // ------------------------------------------------
    // TITLE
    // ------------------------------------------------

    if (font_warning_title != -1)
    {
        draw_set_font(
            font_warning_title
        );
    }

    draw_set_color(c_white);

    draw_text(
        warning_centre_x,
        88,
        "SAVING"
    );


    // ------------------------------------------------
    // ANIMATED SAVE ICON
    // ------------------------------------------------

    if (save_icon_sprite != -1)
    {
        draw_sprite_ext(
            save_icon_sprite,
            floor(
                save_icon_frame
            ),

            warning_centre_x,
            150,

            save_icon_scale,
            save_icon_scale,

            0,

            c_white,
            1
        );
    }


    // ------------------------------------------------
    // WARNING TEXT
    // ------------------------------------------------

    if (font_warning_body != -1)
    {
        draw_set_font(
            font_warning_body
        );
    }

    draw_set_color(
        make_color_rgb(
            205,
            215,
            225
        )
    );

    draw_text(
        warning_centre_x,
        245,

        "WHEN THIS ICON APPEARS IN THE BOTTOM-RIGHT,\n" +
        "THE GAME IS SAVING.\n\n" +
        "DO NOT CLOSE THE GAME OR TURN OFF YOUR DEVICE."
    );
}


// ====================================================
// RESTORE GPU AND DRAW STATE
// ====================================================

gpu_set_blendmode(
    bm_normal
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);