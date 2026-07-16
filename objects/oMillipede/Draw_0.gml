/// oMillipede — Draw

if (!route_ready)
{
    exit;
}

var final_segment =
    total_segments - 1;


// ====================================================
// PASS 1: MIDDLE SECTIONS
//
// All middles use the same orientation.
//
// Later middles are drawn after earlier middles,
// reproducing the artist's overlapping shell stack.
// ====================================================

if (spr_middle != -1)
{
    var middle_frame_count =
        max(
            1,
            sprite_get_number(
                spr_middle
            )
        );

    var middle_frame =
        floor(anim_position)
        mod middle_frame_count;

    for (
        var physical_index = 1;
        physical_index < final_segment;
        physical_index++
    )
    {
        var angle =
            segment_angle[
                physical_index
            ];

        // body_lift moves away from the route centre in
        // the sprite's local downward-facing direction.
        var normal_angle =
            angle + 90;

        var draw_x =
            segment_x[
                physical_index
            ] +
            lengthdir_x(
                body_lift,
                normal_angle
            );

        var draw_y =
            segment_y[
                physical_index
            ] +
            lengthdir_y(
                body_lift,
                normal_angle
            );

        draw_sprite_ext(
            spr_middle,
            middle_frame,
            draw_x,
            draw_y,
            1,
            1,
            angle,
            c_white,
            1
        );
    }
}


// ====================================================
// PASS 2: LEFT HEAD
//
// Both heads are drawn above the middle body so the
// adjacent middle cannot cover their rear shell.
// ====================================================

if (spr_head_left != -1)
{
    var left_angle =
        segment_angle[0];

    var left_normal =
        left_angle + 90;

    var left_draw_x =
        segment_x[0] +
        lengthdir_x(
            body_lift,
            left_normal
        );

    var left_draw_y =
        segment_y[0] +
        lengthdir_y(
            body_lift,
            left_normal
        );

    var left_frame =
        floor(anim_position)
        mod
        max(
            1,
            sprite_get_number(
                spr_head_left
            )
        );

    draw_sprite_ext(
        spr_head_left,
        left_frame,
        left_draw_x,
        left_draw_y,
        1,
        1,
        left_angle,
        c_white,
        1
    );
}


// ====================================================
// PASS 3: RIGHT HEAD
// ====================================================

if (spr_head_right != -1)
{
    var right_angle =
        segment_angle[
            final_segment
        ];

    var right_normal =
        right_angle + 90;

    var right_draw_x =
        segment_x[
            final_segment
        ] +
        lengthdir_x(
            body_lift,
            right_normal
        );

    var right_draw_y =
        segment_y[
            final_segment
        ] +
        lengthdir_y(
            body_lift,
            right_normal
        );

    var right_frame =
        floor(anim_position)
        mod
        max(
            1,
            sprite_get_number(
                spr_head_right
            )
        );

    draw_sprite_ext(
        spr_head_right,
        right_frame,
        right_draw_x,
        right_draw_y,
        1,
        1,
        right_angle,
        c_white,
        1
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // Route
    draw_set_alpha(0.45);
    draw_set_color(c_aqua);

    for (
        var r = 0;
        r < route_count - 1;
        r++
    )
    {
        draw_line(
            route_x[r],
            route_y[r],
            route_x[r + 1],
            route_y[r + 1]
        );
    }

    if (route_mode == 1)
    {
        draw_line(
            route_x[route_count - 1],
            route_y[route_count - 1],
            route_x[0],
            route_y[0]
        );
    }

    // Segment centres
    draw_set_color(c_red);

    for (
        var i = 0;
        i < total_segments;
        i++
    )
    {
        draw_circle(
            segment_x[i],
            segment_y[i],
            5,
            false
        );

        draw_line(
            segment_x[i],
            segment_y[i],
            segment_x[i] +
                lengthdir_x(
                    16,
                    segment_angle[i] + 90
                ),
            segment_y[i] +
                lengthdir_y(
                    16,
                    segment_angle[i] + 90
                )
        );
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}