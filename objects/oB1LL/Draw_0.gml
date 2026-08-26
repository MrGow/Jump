/// oB1LL — Draw


// ====================================================
// GROUND SHADOW
// ====================================================

if (shadow_enabled)
{
    var shadow_x =
        x +
        shadow_x_nudge;


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


    if (floor_inst != noone)
    {
        var floor_y =
            -1;


        for (
            var yy =
                floor(
                    probe_start_y
                );

            yy <=
                ceil(
                    probe_end_y
                );

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
                        shadow_y -
                            yoff,

                        sx + 1,

                        shadow_y +
                            yoff,

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
// B1LL-E BODY
//
// Idle:
//     baked sprite bob.
//
// Talking:
//     external synchronized bob.
//
// Frozen talking pose:
//     talking animation stays frozen, but the bob keeps
//     moving.
// ====================================================

var body_draw_y =
    y;


var use_external_bob =
    b1ll_state == "talking" &&
    sprite_index != spr_idle;


if (use_external_bob)
{
    body_draw_y +=
        b1ll_bob_draw_y;
}


// ====================================================
// DRAW B1LL-E
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,

    x,
    body_draw_y,

    image_xscale,
    image_yscale,

    image_angle,

    image_blend,
    image_alpha
);