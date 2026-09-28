/// oMissileLauncher — Draw


// ====================================================
// DIMENSIONS
// ====================================================

var _cable_frames =
    max(
        1,
        sprite_get_number(
            spriteMissileLauncherConnectingCable
        )
    );

var _plate_frame =
    floor(
        plate_anim_position
    );


// ====================================================
// CABLE
//
// Draw from launcher outward toward pressure plate.
// ====================================================

for (
    var i = 0;
    i < cable_repeats;
    i++
)
{
    var _cable_x =
        x +
        direction *
        (
            cable_start_offset
            +
            cable_width * 0.5
            +
            i *
            cable_step
        );


    // ------------------------------------------------
    // NORMAL CABLE
    // ------------------------------------------------

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


    // ------------------------------------------------
    // POWER PROGRESS
    //
    // Because charging begins at the pressure plate,
    // convert loop index into distance FROM plate.
    // ------------------------------------------------

    var _from_plate =
        cable_repeats -
        1 -
        i;

    var _segment_start =
        _from_plate /
        cable_repeats;

    var _segment_end =
        (_from_plate + 1) /
        cable_repeats;


    // Fully powered segment.
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
            min(
                1,
                _cable_frames - 1
            ),
            _cable_x,
            y,
            direction,
            1,
            0,
            make_color_rgb(
                255,
                125,
                35
            ),
            _pulse
        );
    }


    // Currently charging segment.
    else if (
        launch_progress >
        _segment_start
    )
    {
        var _local_progress =
            (
                launch_progress -
                _segment_start
            )
            /
            max(
                0.001,
                _segment_end -
                _segment_start
            );

        draw_sprite_ext(
            spriteMissileLauncherConnectingCable,
            min(
                1,
                _cable_frames - 1
            ),
            _cable_x,
            y,
            direction,
            1,
            0,
            make_color_rgb(
                255,
                125,
                35
            ),
            clamp(
                _local_progress,
                0,
                1
            )
        );
    }
}


// ====================================================
// PRESSURE PLATE
//
// Only the artwork moves down.
// Gameplay trigger remains at original Y.
// ====================================================

draw_sprite_ext(
    spritePressurePlate,
    _plate_frame,
    plate_x,
    plate_y +
    plate_visual_offset,
    direction,
    1,
    0,
    c_white,
    1
);


// ====================================================
// MISSILE LAUNCHER
// ====================================================

draw_self();


// ====================================================
// LAUNCH PROGRESS BAR
// ====================================================

if (
    show_launch_bar &&
    missile_state == MISSILE_CHARGING
)
{
    var _bar_x =
        plate_x;

    var _bar_y =
        plate_y -
        launch_bar_y_offset;

    var _half_w =
        launch_bar_width * 0.5;


    // ------------------------------------------------
    // TEXT
    // ------------------------------------------------

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_bottom
    );

    draw_set_alpha(1);

    draw_set_color(
        c_white
    );

    draw_text(
        _bar_x,
        _bar_y - 4,
        "MISSILE LAUNCHING..."
    );


    // ------------------------------------------------
    // BAR BACKGROUND
    // ------------------------------------------------

    draw_set_color(
        c_black
    );

    draw_rectangle(
        _bar_x - _half_w - 2,
        _bar_y - 2,
        _bar_x + _half_w + 2,
        _bar_y + launch_bar_height + 2,
        false
    );


    // ------------------------------------------------
    // BAR EMPTY AREA
    // ------------------------------------------------

    draw_set_color(
        make_color_rgb(
            45,
            48,
            58
        )
    );

    draw_rectangle(
        _bar_x - _half_w,
        _bar_y,
        _bar_x + _half_w,
        _bar_y + launch_bar_height,
        false
    );


    // ------------------------------------------------
    // BAR FILL
    // ------------------------------------------------

    var _fill_right =
        _bar_x -
        _half_w
        +
        launch_bar_width *
        launch_progress;

    draw_set_color(
        make_color_rgb(
            255,
            125,
            35
        )
    );

    draw_rectangle(
        _bar_x - _half_w,
        _bar_y,
        _fill_right,
        _bar_y + launch_bar_height,
        false
    );


    // ------------------------------------------------
    // RESET ALIGNMENT
    // ------------------------------------------------

    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );

    draw_set_alpha(1);

    draw_set_color(
        c_white
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    var _trigger_half_width =
        (
            plate_width *
            plate_trigger_width_scale
        )
        * 0.5;

    var _plate_top =
        plate_y -
        plate_height * 0.5;

    var _trigger_top =
        _plate_top -
        plate_trigger_height;

    var _trigger_bottom =
        _plate_top +
        3;


    draw_set_alpha(
        0.25
    );

    draw_set_color(
        c_lime
    );

    draw_rectangle(
        plate_x -
        _trigger_half_width,
        _trigger_top,
        plate_x +
        _trigger_half_width,
        _trigger_bottom,
        false
    );


    draw_set_alpha(1);

    draw_set_color(
        c_white
    );

    draw_text(
        plate_x - 24,
        plate_y + 18,
        string(
            round(
                launch_progress *
                100
            )
        )
        +
        "%"
    );
}