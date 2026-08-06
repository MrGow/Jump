/// oArea3ChasingCaterpillar — Draw


// ====================================================
// SAFETY
// ====================================================

if (!visible)
{
    exit;
}


if (
    head_sprite == -1 ||
    body_sprite == -1
)
{
    exit;
}


// ====================================================
// COMPOSITE POSITION
// ====================================================

var draw_x =
    round(
        x +
        visual_shake_x
    );

var draw_y =
    round(
        y +
        visual_shake_y
    );


// ====================================================
// SPRITE INFORMATION
// ====================================================

var head_frame_count =
    max(
        1,
        sprite_get_number(
            head_sprite
        )
    );

var body_frame_count =
    max(
        1,
        sprite_get_number(
            body_sprite
        )
    );


var head_height =
    sprite_get_height(
        head_sprite
    );

var body_height =
    sprite_get_height(
        body_sprite
    );


// Fixed top-to-top distance between body sections.
var body_step =
    max(
        1,
        body_segment_step
    );


// ====================================================
// FIRST BODY POSITION
// ====================================================

var body_start_y =
    draw_y +
    head_draw_offset_y +
    head_height +
    body_draw_offset_y;


// ====================================================
// DRAW BODY SEGMENTS
//
// Draw back-to-front so the upper sections overlap the
// sections beneath them cleanly.
// ====================================================

for (
    var segment = body_segment_count - 1;
    segment >= 0;
    segment--
)
{
    var body_frame =
        floor(
            body_anim_position +
            segment *
            body_phase_offset
        )
        mod
        body_frame_count;


    var segment_x =
        draw_x +
        body_draw_offset_x;

    var segment_y =
        body_start_y +
        segment *
        body_step;


    draw_sprite(
        body_sprite,
        body_frame,
        round(segment_x),
        round(segment_y)
    );
}


// ====================================================
// DRAW HEAD
// ====================================================

var head_frame =
    floor(
        head_anim_position
    )
    mod
    head_frame_count;


draw_sprite(
    head_sprite,
    head_frame,

    round(
        draw_x +
        head_draw_offset_x
    ),

    round(
        draw_y +
        head_draw_offset_y
    )
);


// ====================================================
// DEBUG COLLISION RECTANGLES
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.30);


    // ------------------------------------------------
    // Head collision
    // ------------------------------------------------

    var head_w =
        sprite_get_width(
            head_sprite
        );

    var head_h =
        sprite_get_height(
            head_sprite
        );


    var head_left =
        draw_x -
        head_w * 0.5 +
        head_draw_offset_x +
        head_collision_inset_left;

    var head_right =
        draw_x +
        head_w * 0.5 +
        head_draw_offset_x -
        head_collision_inset_right;

    var head_top =
        draw_y +
        head_draw_offset_y +
        head_collision_inset_top;

    var head_bottom =
        draw_y +
        head_draw_offset_y +
        head_h -
        head_collision_inset_bottom;


    draw_set_color(c_red);

    draw_rectangle(
        head_left,
        head_top,
        head_right,
        head_bottom,
        false
    );


    // ------------------------------------------------
    // Body collision
    // ------------------------------------------------

    var body_w =
        sprite_get_width(
            body_sprite
        );


    draw_set_color(c_yellow);


    for (
        var segment = 0;
        segment < body_segment_count;
        segment++
    )
    {
        var segment_x =
            draw_x +
            body_draw_offset_x;

        var segment_y =
            body_start_y +
            segment *
            body_step;


        var body_left =
            segment_x -
            body_w * 0.5 +
            body_collision_inset_left;

        var body_right =
            segment_x +
            body_w * 0.5 -
            body_collision_inset_right;

        var body_top =
            segment_y +
            body_collision_inset_top;

        var body_bottom =
            segment_y +
            body_height -
            body_collision_inset_bottom;


        draw_rectangle(
            body_left,
            body_top,
            body_right,
            body_bottom,
            false
        );
    }


    draw_set_alpha(1);
    draw_set_color(c_white);
}