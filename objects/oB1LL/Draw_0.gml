/// oB1LL — Draw


// ====================================================
// GROUND SHADOW
//
// Probe directly downward from B1LL's feet until we hit
// oFloorSurface, then place the shadow on that surface.
// ====================================================

if (shadow_enabled)
{
    var shadow_x =
        x +
        shadow_x_nudge;


    // ------------------------------------------------
    // FIND FLOOR DIRECTLY BELOW
    // ------------------------------------------------

    var probe_start_y =
        bbox_bottom -
        2;


    var probe_end_y =
        bbox_bottom +
        80;


    var floor_inst =
        collision_line(
            shadow_x,
            probe_start_y,
            shadow_x,
            probe_end_y,
            oFloorSurface,
            false,
            true
        );


    // ------------------------------------------------
    // IF FLOOR FOUND
    // ------------------------------------------------

    if (floor_inst != noone)
    {
        // Find the actual first collision point by
        // scanning downward pixel-by-pixel.
        var floor_y =
            -1;


        for (
            var yy = floor(probe_start_y);
            yy <= ceil(probe_end_y);
            yy++
        )
        {
            if (
                collision_point(
                    shadow_x,
                    yy,
                    floor_inst,
                    false,
                    true
                )
                != noone
            )
            {
                floor_y =
                    yy;

                break;
            }
        }


        // ------------------------------------------------
        // DRAW SHADOW
        // ------------------------------------------------

        if (floor_y >= 0)
        {
            var shadow_y =
                floor_y +
                shadow_y_nudge;


            var sh_w =
                max(
                    1,
                    shadow_w
                );


            var sh_h =
                max(
                    1,
                    shadow_h
                );


            var rx =
                sh_w *
                0.5;


            var ry =
                sh_h *
                0.5;


            // --------------------------------------------
            // Pixel ellipse
            // --------------------------------------------

            draw_set_alpha(
                shadow_alpha
            );


            draw_set_color(
                c_black
            );


            var start_x =
                floor(
                    shadow_x -
                    rx
                );


            var end_x =
                ceil(
                    shadow_x +
                    rx
                );


            for (
                var sx = start_x;
                sx <= end_x;
                sx++
            )
            {
                var dx =
                    (
                        sx +
                        0.5
                    )
                    -
                    shadow_x;


                var nx =
                    dx /
                    max(
                        0.001,
                        rx
                    );


                if (abs(nx) <= 1.0001)
                {
                    var circle_term =
                        max(
                            0,
                            1 -
                            nx *
                            nx
                        );


                    var yoff =
                        ry *
                        sqrt(
                            circle_term
                        );


                    draw_rectangle(
                        sx,
                        shadow_y - yoff,
                        sx + 1,
                        shadow_y + yoff,
                        false
                    );
                }
            }


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
// B1LL-E
// ====================================================

draw_self();