/// oMechaSoldier — Draw


// ====================================================
// SHADOW
//
// Small black ellipse that sits on the floor.
//
// It subtly breathes in/out continuously.
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
    // ------------------------------------------------
    // RHYTHMIC BREATHING
    // ------------------------------------------------

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


    // ------------------------------------------------
    // DISTANCE FADE
    //
    // Strong while grounded, lighter while falling.
    // ------------------------------------------------

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


   // ------------------------------------------------
// DRAW
// ------------------------------------------------

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
//
// Keep the same visual floor inset used while alive.
// The soldier's real collision position remains on the
// logical oFloorSurface.
// ====================================================

if (dead)
{
    // Draw the intact death animation only until
    // the body actually breaks apart.
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
// RECOIL DRAW POSITION
//
// Real collision position does NOT move.
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
// MUZZLE FLASH
// ====================================================

if (
    muzzle_flash_active
    &&
    spr_muzzle != -1
)
{
    var _muzzle =
        soldier_get_muzzle(
            locked_aim_frame,
            _draw_x,
            _draw_y
        );


    var _mx =
        _muzzle[0];


    var _my =
        _muzzle[1];


    draw_sprite_ext(
        spr_muzzle,
        floor(
            muzzle_flash_frame
        ),
        _mx,
        _my,
        1,
        1,
        locked_shot_angle - 180,
        c_white,
        1
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // ------------------------------------------------
    // ACTIVATION RANGE
    // ------------------------------------------------

    draw_set_alpha(
        0.20
    );


    draw_set_color(
        c_yellow
    );


    draw_circle(
        x,
        y,
        activation_range,
        true
    );


    // ------------------------------------------------
    // PREFERRED RANGE
    // ------------------------------------------------

    draw_set_color(
        c_lime
    );


    draw_circle(
        x,
        y,
        preferred_range_min,
        true
    );


    draw_circle(
        x,
        y,
        preferred_range_max,
        true
    );


    // ------------------------------------------------
    // FLOOR / FEET
    // ------------------------------------------------

    draw_set_alpha(1);


    draw_set_color(
        grounded
        ? c_lime
        : c_red
    );


    draw_line(
        bbox_left,
        bbox_bottom,
        bbox_right,
        bbox_bottom
    );


    // ------------------------------------------------
    // SHADOW GROUND
    // ------------------------------------------------

    if (
        shadow_ground_distance >= 0
    )
    {
        draw_set_color(
            c_aqua
        );


        draw_line(
            x - 12,
            shadow_ground_y,
            x + 12,
            shadow_ground_y
        );
    }


    // ------------------------------------------------
    // CURRENT MUZZLE
    // ------------------------------------------------

    if (state == "aim")
    {
        var _debug_muzzle =
            soldier_get_muzzle(
                aim_frame,
                x,
                y
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


        if (
            instance_exists(
                oPlayer
            )
        )
        {
            var _debug_player =
                instance_find(
                    oPlayer,
                    0
                );


            draw_line(
                _debug_muzzle[0],
                _debug_muzzle[1],
                _debug_player.x,
                _debug_player.y
            );
        }
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
        "\nCOOLDOWN: "
        +
        string(shot_cooldown)
    );


    draw_set_color(
        c_white
    );


    draw_set_alpha(1);
}