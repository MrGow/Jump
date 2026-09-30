/// oGunShip — Draw

var draw_x = round(x + draw_jitter_x);
var draw_y = round(y + draw_jitter_y);


// ====================================================
// BODY
// ====================================================

if (sprite_index != -1)
{
    var body_frames =
        max(1, sprite_get_number(sprite_index));

    var body_frame = clamp(
        floor(image_index),
        0,
        body_frames - 1
    );

    draw_sprite_ext(
        sprite_index,
        body_frame,
        draw_x,
        draw_y,
        facing,
        1,
        0,
        c_white,
        1
    );

    if (boss_hit_flash_timer > 0)
    {
        gpu_set_blendmode(bm_add);

        draw_sprite_ext(
            sprite_index,
            body_frame,
            draw_x,
            draw_y,
            facing,
            1,
            0,
            c_white,
            0.70
            *
            boss_hit_flash_timer
            /
            max(1, round(room_speed * 0.16))
        );

        gpu_set_blendmode(bm_normal);
    }
}


// ====================================================
// SMALL GUN FIRING BEAM
// ====================================================

if (
    gun_beam_visible &&
    gun_laser_len > 0
)
{
    var beam_colour =
        make_color_rgb(255, 45, 35);

    draw_set_alpha(0.26);
    draw_set_color(beam_colour);

    draw_line_width(
        gun_laser_start_x,
        gun_laser_start_y,
        gun_laser_end_x,
        gun_laser_end_y,
        7
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    if (gun_ray_sprite != -1)
    {
        var ray_frames =
            max(
                1,
                sprite_get_number(gun_ray_sprite)
            );

        var ray_frame =
            floor(gun_laser_fx_frame)
            mod ray_frames;

        var ray_height =
            max(
                1,
                sprite_get_height(gun_ray_sprite)
            );

        var ray_rotation =
            gun_angle - 270;

        var scroll_offset =
            gun_laser_scroll mod ray_height;

        var beam_draw_dist =
            -scroll_offset;

        while (beam_draw_dist < gun_laser_len)
        {
            var segment_start =
                max(0, beam_draw_dist);

            var segment_end = min(
                gun_laser_len,
                beam_draw_dist + ray_height
            );

            var segment_length =
                segment_end - segment_start;

            if (segment_length > 0)
            {
                var beam_x =
                    gun_laser_start_x
                    +
                    lengthdir_x(
                        segment_start,
                        gun_angle
                    );

                var beam_y =
                    gun_laser_start_y
                    +
                    lengthdir_y(
                        segment_start,
                        gun_angle
                    );

                draw_sprite_ext(
                    gun_ray_sprite,
                    ray_frame,
                    beam_x,
                    beam_y,
                    1,
                    segment_length / ray_height,
                    ray_rotation,
                    c_white,
                    1
                );
            }

            beam_draw_dist += ray_height;
        }
    }

    if (gun_end_sprite != -1)
    {
        var small_end_frames =
            max(
                1,
                sprite_get_number(gun_end_sprite)
            );

        var small_end_frame =
            floor(gun_laser_fx_frame)
            mod small_end_frames;

        draw_sprite_ext(
            gun_end_sprite,
            small_end_frame,
            gun_laser_end_x,
            gun_laser_end_y,
            1,
            1,
            gun_angle - 90,
            c_white,
            1
        );
    }
}


// ====================================================
// ATTACHED GUN
// ====================================================

var gun_draw_sprite = gun_sprite;

if (sprite_index == spriteGunShipWeakened)
{
    gun_draw_sprite =
        spriteGunShipGunWeakened;
}

if (gun_draw_sprite != -1)
{
    var recoil_x =
        lengthdir_x(-gun_recoil, gun_angle);

    var recoil_y =
        lengthdir_y(-gun_recoil, gun_angle);

    var attached_gun_x =
        x + gun_mount_offset_x * facing;

    var attached_gun_y =
        y + gun_mount_offset_y;

    draw_sprite_ext(
        gun_draw_sprite,
        0,
        round(
            attached_gun_x
            + recoil_x
            + draw_jitter_x
        ),
        round(
            attached_gun_y
            + recoil_y
            + draw_jitter_y
        ),
        1,
        1,
        gun_draw_angle,
        c_white,
        1
    );
}


// ====================================================
// HUGE HORIZONTAL LASER
// ====================================================

if (
    big_laser_visible &&
    big_laser_len > 0
)
{
    var laser_anim_frame =
        floor(big_laser_fx_frame);

    var start_width = 0;

    if (big_laser_sprite_start != -1)
    {
        var start_frames =
            max(
                1,
                sprite_get_number(
                    big_laser_sprite_start
                )
            );

        var start_frame =
            laser_anim_frame mod start_frames;

        start_width =
            sprite_get_width(
                big_laser_sprite_start
            );

        draw_sprite_ext(
            big_laser_sprite_start,
            start_frame,
            big_laser_start_x,
            big_laser_start_y,
            facing,
            1,
            0,
            c_white,
            1
        );
    }

    var middle_start_dist = max(
        0,
        start_width - big_laser_tile_overlap
    );

    var middle_distance =
        middle_start_dist;

    if (big_laser_sprite_middle != -1)
    {
        var middle_width =
            max(
                1,
                sprite_get_width(
                    big_laser_sprite_middle
                )
            );

        var middle_frames =
            max(
                1,
                sprite_get_number(
                    big_laser_sprite_middle
                )
            );

        var middle_frame =
            laser_anim_frame mod middle_frames;

        while (middle_distance < big_laser_len)
        {
            var remaining =
                big_laser_len - middle_distance;

            var section_width = min(
                middle_width,
                remaining
                + big_laser_tile_overlap
            );

            var middle_x =
                big_laser_start_x
                +
                middle_distance * facing;

            draw_sprite_ext(
                big_laser_sprite_middle,
                middle_frame,
                middle_x,
                big_laser_start_y,
                facing
                *
                (section_width / middle_width),
                1,
                0,
                c_white,
                1
            );

            middle_distance += max(
                1,
                middle_width
                - big_laser_tile_overlap
            );
        }
    }

    if (big_laser_sprite_end != -1)
    {
        var big_end_frames =
            max(
                1,
                sprite_get_number(
                    big_laser_sprite_end
                )
            );

        var big_end_frame =
            laser_anim_frame mod big_end_frames;

        draw_sprite_ext(
            big_laser_sprite_end,
            big_end_frame,
            big_laser_end_x,
            big_laser_end_y,
            facing,
            1,
            0,
            c_white,
            1
        );
    }
}


// ====================================================
// ARENA GUN WARNING RAY
//
// Step determines when this appears, so the warning
// always follows the actual phase timing.
// ====================================================

if (arena_phase_active && state == "hover")
{
    if (
        variable_instance_exists(
            id,
            "arena_warning_visible"
        )
    )
    {
        if (
            arena_warning_visible &&
            gun_laser_len > 0
        )
        {
            draw_set_color(
                make_color_rgb(255, 55, 40)
            );

            draw_set_alpha(
                0.22
                +
                0.25
                *
                abs(
                    sin(arena_phase_frame * 0.2)
                )
            );

            draw_line_width(
                gun_laser_start_x,
                gun_laser_start_y,
                gun_laser_end_x,
                gun_laser_end_y,
                2
            );
        }
    }
}


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);