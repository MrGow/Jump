/// oAirVentLarge — Draw


// ====================================================
// DRAW AIR
//
// Only while vent is fully open.
// ====================================================

if (vent_state == VENT_OPEN)
{
    var _air_width =
        sprite_get_width(
            spriteAirVentLargeAir
        );

    var _air_height =
        sprite_get_height(
            spriteAirVentLargeAir
        );

    var _air_frames =
        max(
            1,
            sprite_get_number(
                spriteAirVentLargeAir
            )
        );

    var _tile_step =
        _air_width +
        air_tile_gap;


    // ------------------------------------------------
    // START AT EDGE OF VENT
    // ------------------------------------------------

    var _vent_half_width =
        sprite_get_width(
            spriteAirVentLarge
        )
        *
        0.5
        *
        abs(image_xscale);

    var _wind_start_x =
        x +
        direction *
        _vent_half_width;


    // ------------------------------------------------
    // DRAW REPEATED AIR
    // ------------------------------------------------

    for (
        var i = 0;
        i < air_repeats;
        i++
    )
    {
        // Convert the authored delay into animation
        // phase difference between each repeated tile.

        var _delay_frames =
            air_repeat_delay *
            room_speed *
            wind_animation_speed;

        var _air_frame =
            floor(
                wind_frame_position -
                i *
                _delay_frames
            );

        _air_frame =
            ((_air_frame mod _air_frames)
            + _air_frames)
            mod _air_frames;


        var _air_x =
            _wind_start_x
            +
            direction *
            (
                _air_width * 0.5
                +
                i *
                _tile_step
            );


        draw_sprite_ext(
            spriteAirVentLargeAir,
            _air_frame,
            _air_x,
            y,
            direction,
            1,
            0,
            c_white,
            image_alpha
        );
    }
}


// ====================================================
// DRAW VENT
// ====================================================

draw_self();


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    var _air_width =
        sprite_get_width(
            spriteAirVentLargeAir
        );

    var _air_height =
        sprite_get_height(
            spriteAirVentLargeAir
        );

    var _tile_step =
        _air_width +
        air_tile_gap;

    var _wind_length =
        air_repeats *
        _tile_step;

    var _vent_half_width =
        sprite_get_width(
            spriteAirVentLarge
        )
        *
        0.5
        *
        abs(image_xscale);

    var _wind_start_x =
        x +
        direction *
        _vent_half_width;


    var _wind_left;
    var _wind_right;

    if (direction > 0)
    {
        _wind_left =
            _wind_start_x;

        _wind_right =
            _wind_start_x +
            _wind_length;
    }
    else
    {
        _wind_left =
            _wind_start_x -
            _wind_length;

        _wind_right =
            _wind_start_x;
    }


    var _collision_height =
        _air_height *
        wind_collision_height_scale;

    var _wind_top =
        y -
        _collision_height * 0.5;

    var _wind_bottom =
        y +
        _collision_height * 0.5;


    // ------------------------------------------------
    // ACTIVE WIND AREA
    // ------------------------------------------------

    if (vent_state == VENT_OPEN)
    {
        draw_set_alpha(
            0.22
        );

        draw_set_color(
            c_aqua
        );

        draw_rectangle(
            _wind_left,
            _wind_top,
            _wind_right,
            _wind_bottom,
            false
        );
    }


    // ------------------------------------------------
    // ORIGIN
    // ------------------------------------------------

    draw_set_alpha(1);

    draw_set_color(
        c_yellow
    );

    draw_circle(
        x,
        y,
        3,
        false
    );


    // ------------------------------------------------
    // STATE TEXT
    // ------------------------------------------------

    var _state_text =
        "CLOSED";

    if (vent_state == VENT_OPENING)
    {
        _state_text =
            "OPENING";
    }
    else if (vent_state == VENT_OPEN)
    {
        _state_text =
            "OPEN";
    }
    else if (vent_state == VENT_CLOSING)
    {
        _state_text =
            "CLOSING";
    }


    draw_set_color(
        c_white
    );

    draw_text(
        x - 28,
        y - 64,
        _state_text
    );
}