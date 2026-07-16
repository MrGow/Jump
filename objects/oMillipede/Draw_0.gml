/// oMillipede — Draw

if (!route_ready)
{
    exit;
}

var final_segment =
    total_segments - 1;


// ====================================================
// PASS 1: DRAW MIDDLE PIECES
//
// All middle pieces are drawn first.
// Each later middle is drawn over the previous one,
// producing the artist's layered shell construction.
// ====================================================
if (spr_middle != -1)
{
    var middle_frame =
        floor(anim_position)
        mod
        max(
            1,
            sprite_get_number(
                spr_middle
            )
        );

    for (
        var physical_index = 1;
        physical_index < final_segment;
        physical_index++
    )
    {
        var angle_mid =
            segment_angle[
                physical_index
            ];

        var normal_mid =
            angle_mid + 90;

        var wave_mid =
            sin(
                (
                    anim_position *
                    body_wave_speed
                ) -
                (
                    physical_index *
                    body_wave_spacing
                )
            ) *
            body_wave_amount;

        var shell_stack =
            min(
                1.5,
                (
                    physical_index -
                    1
                ) *
                0.30
            );

        var mid_offset =
            body_lift +
            wave_mid +
            shell_stack;

        var middle_draw_x =
            segment_x[
                physical_index
            ] +
            lengthdir_x(
                mid_offset,
                normal_mid
            );

        var middle_draw_y =
            segment_y[
                physical_index
            ] +
            lengthdir_y(
                mid_offset,
                normal_mid
            );

        draw_sprite_ext(
            spr_middle,
            middle_frame,
            middle_draw_x,
            middle_draw_y,
            1,
            1,
            angle_mid,
            c_white,
            1
        );
    }
}


// ====================================================
// PASS 2: DRAW LEFT HEAD
//
// Drawn after the body so the first middle section
// cannot cover the head's rear shell or connector.
// ====================================================
if (spr_head_left != -1)
{
    var angle_left =
        segment_angle[0];

    var normal_left =
        angle_left + 90;

    var wave_left =
        sin(
            anim_position *
            body_wave_speed
        ) *
        body_wave_amount *
        0.35;

    var left_draw_x =
        segment_x[0] +
        lengthdir_x(
            body_lift + wave_left,
            normal_left
        );

    var left_draw_y =
        segment_y[0] +
        lengthdir_y(
            body_lift + wave_left,
            normal_left
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
        angle_left,
        c_white,
        1
    );
}


// ====================================================
// PASS 3: DRAW RIGHT HEAD
//
// Also drawn above the body so the final connector
// overlaps cleanly.
// ====================================================
if (spr_head_right != -1)
{
    var angle_right =
        segment_angle[
            final_segment
        ];

    var normal_right =
        angle_right + 90;

    var wave_right =
        sin(
            (
                anim_position *
                body_wave_speed
            ) -
            (
                final_segment *
                body_wave_spacing
            )
        ) *
        body_wave_amount *
        0.35;

    var right_draw_x =
        segment_x[
            final_segment
        ] +
        lengthdir_x(
            body_lift + wave_right,
            normal_right
        );

    var right_draw_y =
        segment_y[
            final_segment
        ] +
        lengthdir_y(
            body_lift + wave_right,
            normal_right
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
        angle_right,
        c_white,
        1
    );
}


// ====================================================
// DEBUG
// ====================================================
if (debug_draw)
{
    draw_set_alpha(0.35);
    draw_set_color(c_aqua);

    for (
        var t = 1;
        t < array_length(trail_x);
        t++
    )
    {
        draw_line(
            trail_x[t - 1],
            trail_y[t - 1],
            trail_x[t],
            trail_y[t]
        );
    }

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