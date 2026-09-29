/// oMissileLauncher — Draw

// ====================================================
// DIMENSIONS
// ====================================================

var _cable_frames = max(
    1,
    sprite_get_number(
        spriteMissileLauncherConnectingCable
    )
);

var _plate_frame =
    floor(plate_anim_position);

var _disabled_colour =
    make_color_rgb(85, 90, 95);


// ====================================================
// CABLE
// ====================================================

for (var i = 0; i < cable_repeats; i++)
{
    var _cable_x =
        x +
        direction *
        (
            cable_start_offset
            +
            cable_width * 0.5
            +
            i * cable_step
        );

    // Normal cable.
    draw_sprite_ext(
        spriteMissileLauncherConnectingCable,
        0,
        _cable_x,
        y,
        direction,
        1,
        0,
        c_white,
        1
    );

    // Charging begins at the pressure plate.
    var _from_plate =
        cable_repeats - 1 - i;

    var _segment_start =
        _from_plate / cable_repeats;

    var _segment_end =
        (_from_plate + 1) / cable_repeats;

    if (launch_progress >= _segment_end)
    {
        var _pulse =
            0.78
            +
            sin(
                cable_power_pulse +
                _from_plate * 0.7
            )
            * 0.12;

        draw_sprite_ext(
            spriteMissileLauncherConnectingCable,
            min(1, _cable_frames - 1),
            _cable_x,
            y,
            direction,
            1,
            0,
            make_color_rgb(255, 125, 35),
            _pulse
        );
    }
    else if (launch_progress > _segment_start)
    {
        var _local_progress =
            (launch_progress - _segment_start)
            /
            max(
                0.001,
                _segment_end - _segment_start
            );

        draw_sprite_ext(
            spriteMissileLauncherConnectingCable,
            min(1, _cable_frames - 1),
            _cable_x,
            y,
            direction,
            1,
            0,
            make_color_rgb(255, 125, 35),
            clamp(_local_progress, 0, 1)
        );
    }
}


// ====================================================
// PRESSURE PLATE
// ====================================================

var _plate_colour = c_white;

if (arena_disabled)
{
    _plate_colour =
        _disabled_colour;
}

draw_sprite_ext(
    spritePressurePlate,
    _plate_frame,
    plate_x,
    plate_y + plate_visual_offset,
    direction,
    1,
    0,
    _plate_colour,
    1
);


// ====================================================
// MISSILE LAUNCHER
// ====================================================

if (arena_disabled)
{
    image_blend =
        _disabled_colour;
}
else
{
    image_blend =
        c_white;
}

draw_self();


// ====================================================
// DEBUG
// ====================================================

if (
    debug_draw &&
    instance_exists(plate_solid)
)
{
    var _trigger_half_width =
        plate_width
        *
        plate_trigger_width_scale
        *
        0.5;

    var _trigger_top =
        plate_solid.bbox_top
        -
        plate_trigger_height;

    var _trigger_bottom =
        plate_solid.bbox_top
        +
        4;

    draw_set_alpha(0.25);
    draw_set_color(c_lime);

    draw_rectangle(
        plate_solid.x - _trigger_half_width,
        _trigger_top,
        plate_solid.x + _trigger_half_width,
        _trigger_bottom,
        false
    );

    draw_set_alpha(0.7);
    draw_set_color(c_yellow);

    draw_rectangle(
        plate_solid.bbox_left,
        plate_solid.bbox_top,
        plate_solid.bbox_right,
        plate_solid.bbox_bottom,
        true
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}