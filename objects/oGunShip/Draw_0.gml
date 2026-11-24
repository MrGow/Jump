
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
//
// Standard = original animated sprite beam
// Arena    = thicker crimson continuous beam
// ====================================================

if (
    gun_beam_visible &&
    gun_laser_len > 0
)
{
    // ================================================
    // ARENA CONTINUOUS LASER
    // ================================================

    if (arena_phase_active)
    {
        // --------------------------------------------
        // VISUAL BEAM START
        //
        // Collision positions are unchanged.
        // --------------------------------------------

        var visual_inset = min(
            arena_laser_visual_inset,
            gun_laser_len
        );

        var visual_start_x =
            gun_laser_start_x +
            lengthdir_x(
                visual_inset,
                gun_angle
            );

        var visual_start_y =
            gun_laser_start_y +
            lengthdir_y(
                visual_inset,
                gun_angle
            );

        var remaining_length = max(
            0,
            gun_laser_len - visual_inset
        );

        // --------------------------------------------
        // FULL VISUAL BEAM END
        //
        // The previous 6px shortening caused a gap.
        // Render up to the true impact again.
        // The impact seam is covered AFTER the sprite.
        // --------------------------------------------

        var visual_length = remaining_length;
        var visual_end_x = gun_laser_end_x;
        var visual_end_y = gun_laser_end_y;

        // --------------------------------------------
        // MUZZLE TAPER
        // --------------------------------------------

        var taper_length = min(
            visual_length,
            arena_laser_taper_length
        );

        var taper_end_x =
            visual_start_x +
            lengthdir_x(
                taper_length,
                gun_angle
            );

        var taper_end_y =
            visual_start_y +
            lengthdir_y(
                taper_length,
                gun_angle
            );

        // --------------------------------------------
        // ENERGY PULSE
        // --------------------------------------------

        var beam_pulse =
            0.90 +
            0.10 *
            abs(
                sin(gun_laser_fx_frame * 0.35)
            );

        if (remaining_length > 0)
        {
            // ========================================
            // OUTER CRIMSON GLOW
            // ========================================

            draw_set_color(
                arena_laser_colour
            );

            draw_set_alpha(
                0.24 * beam_pulse
            );

            // Narrow glow at muzzle
            if (taper_length > 0)
            {
                draw_line_width(
                    visual_start_x,
                    visual_start_y,
                    taper_end_x,
                    taper_end_y,
                    4
                );
            }

            // Wide glow along main beam
            if (visual_length > taper_length)
            {
                draw_line_width(
                    taper_end_x,
                    taper_end_y,
                    visual_end_x,
                    visual_end_y,
                    arena_laser_glow_width
                );
            }

            // ========================================
            // SATURATED RED BODY
            // ========================================

            draw_set_color(
                arena_laser_inner_colour
            );

            draw_set_alpha(
                0.90 * beam_pulse
            );

            if (taper_length > 0)
            {
                draw_line_width(
                    visual_start_x,
                    visual_start_y,
                    taper_end_x,
                    taper_end_y,
                    3
                );
            }

            if (visual_length > taper_length)
            {
                draw_line_width(
                    taper_end_x,
                    taper_end_y,
                    visual_end_x,
                    visual_end_y,
                    arena_laser_inner_width
                );
            }

            // ========================================
            // BRIGHT CENTRAL CORE
            // ========================================

            draw_set_color(
                arena_laser_core_colour
            );

            draw_set_alpha(
                0.98 * beam_pulse
            );

            if (taper_length > 0)
            {
                draw_line_width(
                    visual_start_x,
                    visual_start_y,
                    taper_end_x,
                    taper_end_y,
                    2
                );
            }

            if (visual_length > taper_length)
            {
                draw_line_width(
                    taper_end_x,
                    taper_end_y,
                    visual_end_x,
                    visual_end_y,
                    arena_laser_core_width
                );
            }

            // ========================================
            // SMALL MUZZLE FLASH
            //
            // Keep this narrow so electricity
            // does not spill outside the cannon.
            // ========================================

            draw_set_color(
                arena_laser_core_colour
            );

            draw_set_alpha(
                0.90 * beam_pulse
            );

            draw_circle(
                visual_start_x,
                visual_start_y,
                1.5,
                false
            );

            // ========================================
            // ANIMATED LASER END SPLASH
            //
            // Keep the existing two-pass shader effect.
            // Bridge the central colour seam afterwards.
            // ========================================

            if (gun_end_sprite != -1)
            {
                var arena_end_frames = max(
                    1,
                    sprite_get_number(gun_end_sprite)
                );

                var arena_end_frame =
                    floor(gun_laser_fx_frame)
                    mod arena_end_frames;

                // Visual-only offset along the beam, toward the gun.
                // This keeps the splash centred on the beam at
                // every firing angle (rather than shifting only Y).
                var splash_draw_x =
                    gun_laser_end_x
                    - lengthdir_x(
                        arena_laser_splash_y_offset,
                        gun_angle
                    );

                var splash_draw_y =
                    gun_laser_end_y
                    - lengthdir_y(
                        arena_laser_splash_y_offset,
                        gun_angle
                    );

                draw_set_alpha(1);
                draw_set_color(c_white);

                // Main crimson impact silhouette.
                // The sprite's white/yellow highlights
                // are multiplied by this red colour.
                draw_sprite_ext(
                    gun_end_sprite,
                    arena_end_frame,
                    splash_draw_x,
                    splash_draw_y,
                    1,
                    1,
                    gun_angle - 90,
                    arena_laser_colour,
                    1
                );

                // Brighter pink overlay, preserving the
                // original two-frame animated silhouette.
                gpu_set_blendmode(bm_add);

                shader_set(shGunShipArenaImpact);

draw_sprite_ext(
    gun_end_sprite,
    arena_end_frame,
    splash_draw_x,
    splash_draw_y,
    0.75,
    0.75,
    gun_angle - 90,
    c_white,
    1
);

shader_reset();

                gpu_set_blendmode(bm_normal);

                // ====================================
                // LASER / IMPACT COLOUR SEAM FIX
                //
                // The 100% tinted splash extends farther
                // up the beam than the 75% shader pass.
                // Repaint the full join AFTER both passes
                // using the exact main-beam layering.
                //
                // Visual only: no collision changes.
                // ====================================

                var bridge_length = min(34, gun_laser_len);

                var bridge_start_x =
                    gun_laser_end_x -
                    lengthdir_x(bridge_length, gun_angle);

                var bridge_start_y =
                    gun_laser_end_y -
                    lengthdir_y(bridge_length, gun_angle);

                // Outer crimson glow
                draw_set_color(arena_laser_colour);
                draw_set_alpha(0.24 * beam_pulse);

                draw_line_width(
                    bridge_start_x,
                    bridge_start_y,
                    gun_laser_end_x,
                    gun_laser_end_y,
                    arena_laser_glow_width
                );

                // Saturated red body
                draw_set_color(arena_laser_inner_colour);
                draw_set_alpha(0.90 * beam_pulse);

                draw_line_width(
                    bridge_start_x,
                    bridge_start_y,
                    gun_laser_end_x,
                    gun_laser_end_y,
                    arena_laser_inner_width
                );

                // Pink-white centre
                draw_set_color(arena_laser_core_colour);
                draw_set_alpha(0.98 * beam_pulse);

                draw_line_width(
                    bridge_start_x,
                    bridge_start_y,
                    gun_laser_end_x,
                    gun_laser_end_y,
                    arena_laser_core_width
                );

                draw_set_alpha(1);
                draw_set_color(c_white);


            }
        }

        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    // ================================================
    // STANDARD GUN BEAM
    //
    // Original drawing behaviour unchanged.
    // ================================================

    else
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
}


// ====================================================
// ARENA LASER FLOOR SPARKS — PURELY VISUAL
//
// Tiny horizontal pixel streaks, like metal scrape sparks.
// Draw after the beam and splash so they stay visible.
// No sprites, shaders, collisions, or extra objects.
// ====================================================

for (var spark_i = 0; spark_i < array_length(arena_sparks); spark_i++)
{
    var spark = arena_sparks[spark_i];
    var life_ratio = clamp(spark.life / spark.max_life, 0, 1);

    draw_set_color(merge_color(
        arena_laser_colour,
        spark.colour,
        life_ratio
    ));

    draw_set_alpha(min(1, life_ratio * 2.5));

    var spark_x = round(spark.x);
    var spark_y = round(spark.y);
    var spark_length = max(1, round(spark.size * life_ratio));
    var tail_dir = sign(spark.vx);

    if (tail_dir == 0) tail_dir = 1;

    var spark_tail_x = spark_x - (spark_length - 1) * tail_dir;

    // Exactly one pixel high; deliberately small.
    draw_rectangle(
        min(spark_x, spark_tail_x),
        spark_y,
        max(spark_x, spark_tail_x),
        spark_y,
        false
    );
}

draw_set_alpha(1);
draw_set_color(c_white);


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
//
// Unchanged.
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
// Crimson warning before continuous firing.
// Existing Step timing remains unchanged.
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
                arena_laser_warning_colour
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
