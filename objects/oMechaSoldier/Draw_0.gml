/// oMechaSoldier — Draw


// ====================================================
// SHADOW
// ====================================================

if (
    shadow_enabled
    &&
    !dead
    &&
    shadow_ground_distance >= 0
    &&
    shadow_ground_distance <=
        shadow_max_distance
)
{
    shadow_phase +=
        shadow_breathe_speed;


    if (
        shadow_phase >
        pi * 2
    )
    {
        shadow_phase -=
            pi * 2;
    }


    var _pulse =
        sin(
            shadow_phase
        );


    var _shadow_w =
        shadow_width +
        _pulse *
        shadow_breathe_amount_x;


    var _shadow_h =
        shadow_height +
        _pulse *
        shadow_breathe_amount_y;


    var _distance_t =
        clamp(
            shadow_ground_distance /
            max(
                1,
                shadow_max_distance
            ),
            0,
            1
        );


    var _shadow_alpha =
        shadow_alpha *
        (
            1 -
            _distance_t *
            0.70
        );


    draw_set_color(
        c_black
    );


    draw_set_alpha(
        _shadow_alpha
    );


    draw_ellipse(
        round(
            x +
            shadow_offset_x -
            _shadow_w * 0.5
        ),

        round(
            shadow_ground_y +
            draw_floor_inset -
            _shadow_h * 0.5
        ),

        round(
            x +
            shadow_offset_x +
            _shadow_w * 0.5
        ),

        round(
            shadow_ground_y +
            draw_floor_inset +
            _shadow_h * 0.5
        ),

        false
    );


    draw_set_alpha(1);


    draw_set_color(
        c_white
    );
}


// ====================================================
// DEAD
// ====================================================

if (dead)
{
    if (!death_parts_spawned)
    {
        draw_sprite_ext(
            sprite_index,
            image_index,
            x,
            y + draw_floor_inset,
            image_xscale,
            image_yscale,
            image_angle,
            image_blend,
            image_alpha
        );
    }


    exit;
}


// ====================================================
// RECOIL POSITION
// ====================================================

var _draw_x =
    x -
    facing *
    recoil_amount;


var _draw_y =
    y +
    draw_floor_inset;


// ====================================================
// SOLDIER
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    _draw_x,
    _draw_y,
    image_xscale,
    image_yscale,
    image_angle,
    image_blend,
    image_alpha
);


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(1);


    // ------------------------------------------------
    // HITBOX
    // ------------------------------------------------

    if (instance_exists(hitbox))
    {
        draw_set_color(
            c_red
        );


        draw_rectangle(
            hitbox.bbox_left,
            hitbox.bbox_top,
            hitbox.bbox_right,
            hitbox.bbox_bottom,
            true
        );
    }


    // ------------------------------------------------
    // MUZZLE + FIRING LINE
    // ------------------------------------------------

    if (state == "aim")
    {
        var _debug_muzzle =
            soldier_get_muzzle(
                aim_frame,
                x,
                y + draw_floor_inset
            );


        var _debug_angle =
            soldier_get_fire_angle(
                aim_frame
            );


        draw_set_color(
            c_fuchsia
        );


        draw_circle(
            _debug_muzzle[0],
            _debug_muzzle[1],
            2,
            false
        );


        draw_line(
            _debug_muzzle[0],
            _debug_muzzle[1],

            _debug_muzzle[0] +
            lengthdir_x(
                120,
                _debug_angle
            ),

            _debug_muzzle[1] +
            lengthdir_y(
                120,
                _debug_angle
            )
        );
    }


    // ------------------------------------------------
    // DEBUG TEXT
    // ------------------------------------------------

    draw_set_color(
        c_white
    );


    draw_text(
        x + 18,
        y - 70,

        "STATE: "
        +
        string(state)

        +
        "\nGROUND: "
        +
        string(grounded)

        +
        "\nVSP: "
        +
        string(vsp)

        +
        "\nAIM FRAME: "
        +
        string(aim_frame)

        +
        "\nAIM ANGLE: "
        +
        string(
            aim_pose_angles[
                aim_frame
            ]
        )

        +
        "\nCOOLDOWN: "
        +
        string(
            shot_cooldown
        )
    );


    draw_set_color(
        c_white
    );


    draw_set_alpha(1);
}