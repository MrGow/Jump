/// oB1LL — Draw


// ====================================================
// B1LL-E BOB VALUE
//
// b1ll_bob_draw_y is driven from the same hidden idle
// bob clock used for dialogue.
//
// Positive = B1LL-E visually lower / closer to floor.
// Negative = B1LL-E visually higher / farther away.
// ====================================================

var shadow_bob_target =
    0;


if (variable_instance_exists(id, "b1ll_bob_draw_y"))
{
    var bob_range =
        max(
            1,
            dialogue_bob_height
        );


    var bob_normal =
        clamp(
            b1ll_bob_draw_y /
            bob_range,
            -1,
            1
        );


    shadow_bob_target =
        bob_normal *
        shadow_bob_width_amount;
}


// ====================================================
// SMOOTH SHADOW RESPONSE
//
// Gives the shadow a slightly softer response than
// B1LL-E himself.
//
// This still follows the exact same bob timing.
// ====================================================

shadow_bob_width_offset =
    lerp(
        shadow_bob_width_offset,
        shadow_bob_target,
        shadow_bob_smooth
    );


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


            // =================================================
            // BOB-RESPONSIVE WIDTH
            //
            // Lower B1LL-E:
            //     wider shadow.
            //
            // Higher B1LL-E:
            //     narrower shadow.
            // =================================================

            var sh_w =
                max(
                    1,
                    shadow_w +
                    shadow_bob_width_offset
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
//
// The ground shadow above follows the same bob clock.
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