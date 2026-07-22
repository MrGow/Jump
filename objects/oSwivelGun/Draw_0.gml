/// oSwivelGun — Draw

var draw_x_origin = round(x);
var draw_y_origin = round(y);

// ----------------------------------------------------
// 1. Draw rear mounting socket
//
// This sits behind both the gun and front cover.
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
// 2. Draw laser behind the rotating gun
// ----------------------------------------------------
if (
    beam_visible &&
    laser_len > 0
)
{
    var beam_colour =
        (state == "firing")
        ? fire_beam_colour
        : scan_beam_colour;

    var beam_alpha =
        (state == "firing")
        ? 1.0
        : 0.72;

    // ------------------------------------------------
    // Vertical repeating ray sprite
    //
    // Source sprite runs downward at rotation 0.
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

        var remaining =
            laser_len;

        var draw_dist = 0;

        while (remaining > 0)
        {
            var segment_length =
                min(
                    ray_height,
                    remaining
                );

            var ray_draw_x =
                laser_start_x +
                lengthdir_x(
                    draw_dist,
                    beam_angle
                );

            var ray_draw_y =
                laser_start_y +
                lengthdir_y(
                    draw_dist,
                    beam_angle
                );

            draw_sprite_ext(
                ray_sprite,
                ray_frame,
                ray_draw_x,
                ray_draw_y,
                1,
                segment_length / ray_height,
                ray_rotation,
                beam_colour,
                beam_alpha
            );

            draw_dist +=
                segment_length;

            remaining -=
                segment_length;
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
            state == "firing"
                ? 3
                : 1
        );

        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    // ------------------------------------------------
    // Beam end effect
    // ------------------------------------------------
    if (
    end_sprite != -1 &&
    state == "firing"
)
{
    // spriteLaserGunShootEnd is authored pointing upward
    // at angle 0, so align its upward axis to beam_angle.
    var end_draw_angle = beam_angle - 90;

    draw_sprite_ext(
        end_sprite,
        0,
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
// 3. Draw rotating combined gun
//
// Patrol, alert and cooldown use frame 0.
// Only firing uses the shooting animation.
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

    draw_sprite_ext(
        gun_sprite,
        gun_frame,
        draw_x_origin,
        draw_y_origin,
        1,
        1,
        gun_draw_angle,
        c_white,
        1
    );
}

// ----------------------------------------------------
// 4. Draw front mounting cover
//
// This conceals the top edge of the rotating gun,
// making it look seated inside the mounting socket.
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

    // Exact shared world pivot
    draw_circle(
        draw_x_origin,
        draw_y_origin,
        3,
        false
    );

    draw_line(
        x,
        y,
        x + lengthdir_x(
            48,
            beam_angle
        ),
        y + lengthdir_y(
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
        "\noffset: " +
        string(round(patrol_offset)) +
        "\nframe: " +
        string(floor(image_index))
    );
}