/// oAirVentSmall — Draw

// ====================================================
// DRAW WIND COLUMN
// ====================================================

if (
    enabled &&
    wind_sprite != -1
)
{
    var wind_frame_count =
        max(
            1,
            sprite_get_number(wind_sprite)
        );

    var wind_height =
        sprite_get_height(wind_sprite);

    var tile_step =
        wind_height +
        wind_tile_gap;

    for (var i = 0; i < wind_tiles; i++)
    {
        var wind_frame =
            floor(
                wind_animation_position +
                i * 1.75
            )
            mod wind_frame_count;

        var wind_y =
            bbox_top -
            wind_height * 0.5 -
            i * tile_step;

        draw_sprite_ext(
            wind_sprite,
            wind_frame,
            x,
            wind_y,
            image_xscale,
            1,
            0,
            c_white,
            image_alpha
        );
    }
}

// ====================================================
// DRAW VENT ABOVE WIND BASE
// ====================================================

draw_self();

// ====================================================
// DEBUG WIND COLLISION
// ====================================================

if (
    debug_draw &&
    wind_sprite != -1
)
{
    var debug_wind_width =
        sprite_get_width(wind_sprite);

    var debug_wind_height =
        sprite_get_height(wind_sprite);

    var debug_column_width =
        debug_wind_width *
        wind_collision_width_scale *
        abs(image_xscale);

    var debug_column_height =
        wind_tiles *
        (
            debug_wind_height +
            wind_tile_gap
        );

    var debug_bottom = bbox_top;
    var debug_top = debug_bottom - debug_column_height;

    draw_set_alpha(0.25);
    draw_set_color(c_aqua);

    draw_rectangle(
        x - debug_column_width * 0.5,
        debug_top,
        x + debug_column_width * 0.5,
        debug_bottom,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}