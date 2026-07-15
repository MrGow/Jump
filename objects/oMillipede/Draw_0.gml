/// oMillipede — Draw

if (!visible)
{
    exit;
}

// ----------------------------------------------------
// Horizontal for left/right movement.
// Vertical for up/down movement.
// ----------------------------------------------------
var body_angle = 0;

if (move_direction == 1 || move_direction == 3)
{
    body_angle = 90;
}

// ----------------------------------------------------
// Animation frames
// ----------------------------------------------------
var left_frame = 0;
var mid_frame = 0;
var right_frame = 0;

if (spr_head_left != -1)
{
    left_frame =
        floor(anim_position) mod
        max(1, sprite_get_number(spr_head_left));
}

if (spr_middle != -1)
{
    mid_frame =
        floor(anim_position) mod
        max(1, sprite_get_number(spr_middle));
}

if (spr_head_right != -1)
{
    right_frame =
        floor(anim_position) mod
        max(1, sprite_get_number(spr_head_right));
}

// ----------------------------------------------------
// Helper for transforming a local body position
// ----------------------------------------------------
var body_left_edge = -body_length * 0.5;

// ----------------------------------------------------
// Left-facing head
// ----------------------------------------------------
if (spr_head_left != -1)
{
    var local_x =
        body_left_edge +
        left_w * 0.5;

    var draw_x =
        x + lengthdir_x(local_x, body_angle);

    var draw_y =
        y + lengthdir_y(local_x, body_angle);

    draw_sprite_ext(
        spr_head_left,
        left_frame,
        draw_x,
        draw_y,
        1,
        1,
        body_angle,
        c_white,
        1
    );
}

// ----------------------------------------------------
// Repeating middle sections
// ----------------------------------------------------
if (spr_middle != -1)
{
    for (var i = 0; i < middle_count; i++)
    {
        var local_x =
            body_left_edge +
            left_w +
            mid_w * (i + 0.5);

        var draw_x =
            x + lengthdir_x(local_x, body_angle);

        var draw_y =
            y + lengthdir_y(local_x, body_angle);

        draw_sprite_ext(
            spr_middle,
            mid_frame,
            draw_x,
            draw_y,
            1,
            1,
            body_angle,
            c_white,
            1
        );
    }
}

// ----------------------------------------------------
// Right-facing head
// ----------------------------------------------------
if (spr_head_right != -1)
{
    var local_x =
        body_length * 0.5 -
        right_w * 0.5;

    var draw_x =
        x + lengthdir_x(local_x, body_angle);

    var draw_y =
        y + lengthdir_y(local_x, body_angle);

    draw_sprite_ext(
        spr_head_right,
        right_frame,
        draw_x,
        draw_y,
        1,
        1,
        body_angle,
        c_white,
        1
    );
}

// ----------------------------------------------------
// Debug collision
// ----------------------------------------------------
if (debug_draw)
{
    var horizontal =
        move_direction == 0 ||
        move_direction == 2;

    var collision_w;
    var collision_h;

    if (horizontal)
    {
        collision_w =
            max(1, body_length - collision_inset_length * 2);

        collision_h =
            max(1, body_thickness - collision_inset_side * 2);
    }
    else
    {
        collision_w =
            max(1, body_thickness - collision_inset_side * 2);

        collision_h =
            max(1, body_length - collision_inset_length * 2);
    }

    draw_set_alpha(0.25);
    draw_set_color(c_red);

    draw_rectangle(
        x - collision_w * 0.5,
        y - collision_h * 0.5,
        x + collision_w * 0.5,
        y + collision_h * 0.5,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}