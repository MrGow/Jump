/// oSwivelGun — Draw

var draw_x_origin = round(x);
var draw_y_origin = round(y);

// ----------------------------------------------------
// 1. Rear mounting base
// ----------------------------------------------------
if (gun_base_sprite != -1)
{
    draw_sprite_ext(
        gun_base_sprite,
        0,
        draw_x_origin,
        draw_y_origin,
        1,
        1,
        base_draw_angle,
        c_white,
        1
    );
}

// ----------------------------------------------------
// 2. Beam behind the gun
// ----------------------------------------------------
if (
    beam_visible &&
    laser_len > 0
)
{
    var firing_now =
        state == "firing";

    var beam_colour =
        firing_now
        ? fire_beam_colour
        : scan_beam_colour;

    var scan_pulse =
        (
            sin(scan_pulse_t) +
            1
        ) * 0.5;

    var beam_alpha =
        firing_now
        ? 1.0
        : lerp(
            scan_alpha_min,
            scan_alpha_max,
            scan_pulse
        );

    var glow_alpha =
        firing_now
        ? fire_glow_alpha
        : scan_glow_alpha;

    var glow_width =
        firing_now
        ? fire_glow_width
        : scan_glow_width;

    // ------------------------------------------------
    // Beam glow underlay
    // ------------------------------------------------
    draw_set_alpha(glow_alpha);
    draw_set_color(beam_colour);

    draw_line_width(
        laser_start_x,
        laser_start_y,
        laser_end_x,
        laser_end_y,
        glow_width
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    // ------------------------------------------------
    // Vertical repeating beam sprite
    // ------------------------------------------------
    if (ray_sprite != -1)
    {
        var ray_frames =
            max(
                1,
                sprite_get_number(
                    ray_sprite
                )
            );

        var ray_frame =
            floor(laser_fx_frame)
            mod ray_frames;

        var ray_height =
            max(
                1,
                sprite_get_height(
                    ray_sprite
                )
            );

        var ray_rotation =
            beam_angle - 270;

        // Scroll the tiled texture forward.
        var scroll_offset =
            laser_scroll
            mod ray_height;

        var draw_dist =
            -scroll_offset;

        var remaining =
            laser_len +
            scroll_offset;

        while (remaining > 0)
        {
            var segment_start =
                max(0, draw_dist);

            var segment_end =
                min(
                    laser_len,
                    draw_dist +
                    ray_height
                );

            var segment_length =
                segment_end -
                segment_start;

            if (segment_length > 0)
            {
                var ray_draw_x =
                    laser_start_x +
                    lengthdir_x(
                        segment_start,
                        beam_angle
                    );

                var ray_draw_y =
                    laser_start_y +
                    lengthdir_y(
                        segment_start,
                        beam_angle
                    );

                draw_sprite_ext(
                    ray_sprite,
                    ray_frame,
                    ray_draw_x,
                    ray_draw_y,
                    1,
                    segment_length /
                    ray_height,
                    ray_rotation,
                    beam_colour,
                    beam_alpha
                );
            }

            draw_dist += ray_height;
            remaining -= ray_height;
        }
    }
    else
    {
        draw_set_alpha(
            beam_alpha
        );

        draw_set_color(
            beam_colour
        );

        draw_line_width(
            laser_start_x,
            laser_start_y,
            laser_end_x,
            laser_end_y,
            firing_now ? 3 : 1
        );

        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    // ------------------------------------------------
    // Animated impact/end sprite
    //
    // The asset is authored pointing upward.
    // ------------------------------------------------
    if (
        end_sprite != -1 &&
        firing_now
    )
    {
        var end_frames =
            max(
                1,
                sprite_get_number(
                    end_sprite
                )
            );

        var end_frame =
            floor(laser_fx_frame)
            mod end_frames;

        var end_draw_angle =
            beam_angle - 90;

        draw_sprite_ext(
            end_sprite,
            end_frame,
            laser_end_x,
            laser_end_y,
            1,
            1,
            end_draw_angle,
            beam_colour,
            beam_alpha
        );
    }
}

// ----------------------------------------------------
// 3. Rotating gun with recoil
// ----------------------------------------------------
if (gun_sprite != -1)
{
    var gun_frame = 0;

    if (state == "firing")
    {
        gun_frame = clamp(
            floor(image_index),
            0,
            sprite_get_number(
                gun_sprite
            ) - 1
        );
    }

    var recoil_x =
        lengthdir_x(
            -gun_recoil,
            beam_angle
        );

    var recoil_y =
        lengthdir_y(
            -gun_recoil,
            beam_angle
        );

    draw_sprite_ext(
        gun_sprite,
        gun_frame,
        round(draw_x_origin + recoil_x),
        round(draw_y_origin + recoil_y),
        1,
        1,
        gun_draw_angle,
        c_white,
        1
    );
}

// ----------------------------------------------------
// 4. Front mounting cover
// ----------------------------------------------------
if (gun_top_sprite != -1)
{
    draw_sprite_ext(
        gun_top_sprite,
        0,
        draw_x_origin,
        draw_y_origin,
        1,
        1,
        base_draw_angle,
        c_white,
        1
    );
}

// ----------------------------------------------------
// Debug
// ----------------------------------------------------
if (debug_draw)
{
    draw_set_alpha(1);
    draw_set_color(c_yellow);

    draw_circle(
        draw_x_origin,
        draw_y_origin,
        3,
        false
    );

    draw_line(
        x,
        y,
        x +
        lengthdir_x(
            48,
            beam_angle
        ),
        y +
        lengthdir_y(
            48,
            beam_angle
        )
    );

    draw_set_color(c_white);

    draw_text(
        x + 12,
        y + 12,
        "state: " + state +
        "\nbeam: " +
        string(round(beam_angle)) +
        "\ndraw: " +
        string(round(gun_draw_angle)) +
        "\nrecoil: " +
        string(gun_recoil) +
        "\nframe: " +
        string(floor(image_index)) +
        "\nsafe: " +
        string(respawn_safe_timer)
    );
}