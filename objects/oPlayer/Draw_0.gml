/// oPlayer — Draw
// player + chopped ledge-aware shadow + jump trail
// + wallhit overlay + perched bird
// + gravity bubble visual compression


// ====================================================
// DRAW POSITION
//
// These must be calculated before any code uses px/py.
// ====================================================

if (!variable_instance_exists(id, "draw_floor_inset"))
{
    draw_floor_inset = 9;
}


// ====================================================
// GRAVITY BUBBLE VISUAL SCALE
//
// DRAW ONLY.
//
// This does not alter the player's real position,
// collision mask, camera target or hazard collision.
//
// The bot and its owned bird are compressed together
// while inside a Gravity Bubble.
// ====================================================

if (
    !variable_instance_exists(
        id,
        "gravity_bubble_visual_scale"
    )
)
{
    gravity_bubble_visual_scale = 1.0;
}

if (
    !variable_instance_exists(
        id,
        "gravity_bubble_pressure_scale"
    )
)
{
    gravity_bubble_pressure_scale =
        1.0;
}


// ====================================================
// FINAL GRAVITY COMPRESSION
//
// Base scale:
//     Smoothly shrinks toward 0.75.
//
// Pressure scale:
//     Adds the tiny continuous squeeze while held.
// ====================================================

var gravity_bubble_draw_scale =
    clamp(
        gravity_bubble_visual_scale *
        gravity_bubble_pressure_scale,
        0.1,
        1.0
    );


// ====================================================
// VISUAL DRAW POSITION
// ====================================================

var visual_platform_shake_x = 0;
var visual_platform_shake_y = 0;

// Grabber motion is draw-only. The player's real position,
// mask, camera target and hazard checks remain unchanged.
var player_is_grabbed =
    variable_instance_exists(id, "grabbed_by") &&
    instance_exists(grabbed_by);

var grab_visual_x = 0;
var grab_visual_y = 0;
var grab_visual_angle = 0;

if (player_is_grabbed)
{
    if (variable_instance_exists(grabbed_by, "player_visual_offset_x"))
        grab_visual_x = grabbed_by.player_visual_offset_x;

    if (variable_instance_exists(grabbed_by, "player_visual_offset_y"))
        grab_visual_y = grabbed_by.player_visual_offset_y;

    if (variable_instance_exists(grabbed_by, "player_visual_angle"))
        grab_visual_angle = grabbed_by.player_visual_angle;
}

// Do not rotate pixel art during grabber sway.
// Positional movement creates the sway without warping.
var player_final_draw_angle =
    image_angle;


// ----------------------------------------------------
// If standing on the Area 1 elevator, inherit its
// VISUAL engine shake only.
//
// This does NOT move the player's real x/y position
// and therefore does not affect collisions or jumping.
// ----------------------------------------------------

if (
    variable_instance_exists(id, "standing_platform") &&
    instance_exists(standing_platform)
)
{
    var elevator_obj =
        asset_get_index(
            "oArea1ElevatorPlatform"
        );

    if (
        elevator_obj != -1 &&
        standing_platform.object_index ==
        elevator_obj
    )
    {
        if (
            variable_instance_exists(
                standing_platform,
                "visual_shake_x"
            )
        )
        {
            visual_platform_shake_x =
                standing_platform.visual_shake_x;
        }

        if (
            variable_instance_exists(
                standing_platform,
                "visual_shake_y"
            )
        )
        {
            visual_platform_shake_y =
                standing_platform.visual_shake_y;
        }
    }
}


// ----------------------------------------------------
// Final player draw position
// ----------------------------------------------------

var px =
    round(
        x +
        visual_platform_shake_x +
        grab_visual_x
    );

var py =
    round(
        y +
        draw_floor_inset +
        visual_platform_shake_y +
        grab_visual_y
    );


// ====================================================
// DEAD PLAYER VISUALS
// ====================================================

if (
    variable_instance_exists(id, "state") &&
    state == "dead"
)
{
    var _draw_special_death =
        variable_instance_exists(
            id,
            "death_uses_player_sprite"
        ) &&
        death_uses_player_sprite;


    // ------------------------------------------------
    // Default explosion death
    //
    // oDeathExplosion and oBotDeathPart handle the
    // visuals, so the player draws nothing.
    // ------------------------------------------------

    if (!_draw_special_death)
    {
        exit;
    }


    // ------------------------------------------------
    // Hot-reload safety
    // ------------------------------------------------

    if (!variable_instance_exists(id, "death_draw_offset_x"))
    {
        death_draw_offset_x = 0;
    }

    if (!variable_instance_exists(id, "death_draw_offset_y"))
    {
        death_draw_offset_y = 0;
    }


    // ------------------------------------------------
    // Alternative sprite-based death
    //
    // Draw the sprite using the presentation offsets.
    // Ripped-apart deaths move downward visually while
    // the real player instance remains stationary.
    //
    // Gravity Bubble scaling is deliberately NOT
    // applied to death presentations.
    // ------------------------------------------------

    if (sprite_index != -1)
    {
        draw_sprite_ext(
            sprite_index,
            image_index,
            px + death_draw_offset_x,
            py + death_draw_offset_y,
            image_xscale,
            image_yscale,
            image_angle,
            image_blend,
            image_alpha
        );
    }

    exit;
}


// ----------------------------------------------------
// Ground shadow
// ----------------------------------------------------

if (!variable_instance_exists(id, "shadow_enabled"))
{
    shadow_enabled = true;
}

if (!variable_instance_exists(id, "shadow_max_dist"))
{
    shadow_max_dist = 56;
}

if (!variable_instance_exists(id, "shadow_ground_dist"))
{
    shadow_ground_dist = -1;
}

if (!variable_instance_exists(id, "shadow_support_ratio"))
{
    shadow_support_ratio = 1;
}

if (!variable_instance_exists(id, "shadow_support_cx"))
{
    shadow_support_cx = x;
}

if (!variable_instance_exists(id, "shadow_support_left"))
{
    shadow_support_left = bbox_left;
}

if (!variable_instance_exists(id, "shadow_support_right"))
{
    shadow_support_right = bbox_right;
}

if (!variable_instance_exists(id, "shadow_max_w"))
{
    shadow_max_w = 26;
}

if (!variable_instance_exists(id, "shadow_min_w"))
{
    shadow_min_w = 10;
}

if (!variable_instance_exists(id, "shadow_max_h"))
{
    shadow_max_h = 8;
}

if (!variable_instance_exists(id, "shadow_min_h"))
{
    shadow_min_h = 3;
}

if (!variable_instance_exists(id, "shadow_alpha_near"))
{
    shadow_alpha_near = 0.22;
}

if (!variable_instance_exists(id, "shadow_alpha_far"))
{
    shadow_alpha_far = 0;
}

if (!variable_instance_exists(id, "shadow_y_nudge"))
{
    shadow_y_nudge = 0;
}


if (
    !player_is_grabbed &&
    shadow_enabled &&
    shadow_ground_dist >= 0 &&
    shadow_ground_dist <= shadow_max_dist
)
{
    var shadow_t =
        1 -
        clamp(
            shadow_ground_dist /
            max(1, shadow_max_dist),
            0,
            1
        );

    var sh_w =
        lerp(
            shadow_min_w,
            shadow_max_w,
            shadow_t
        );

    var sh_h =
        lerp(
            shadow_min_h,
            shadow_max_h,
            shadow_t
        );

    var sh_a =
        lerp(
            shadow_alpha_far,
            shadow_alpha_near,
            shadow_t
        );

    var support_ratio =
        clamp(
            shadow_support_ratio,
            0,
            1
        );

    var support_cx =
        shadow_support_cx;

    var support_l =
        shadow_support_left;

    var support_r =
        shadow_support_right;

    sh_a *=
        lerp(
            0.35,
            1,
            support_ratio
        );

    var shadow_x =
        support_cx;

    var shadow_y =
        round(
            bbox_bottom +
            shadow_ground_dist +
            draw_floor_inset +
            shadow_y_nudge
        );

    var ell_l =
        shadow_x -
        sh_w * 0.5;

    var ell_r =
        shadow_x +
        sh_w * 0.5;

    var clip_l =
        max(
            ell_l,
            support_l
        );

    var clip_r =
        min(
            ell_r,
            support_r
        );

    if (
        clip_r > clip_l &&
        sh_a > 0.001
    )
    {
        draw_set_alpha(sh_a);
        draw_set_color(c_black);

        var start_x =
            floor(clip_l);

        var end_x =
            ceil(clip_r);

        var rx =
            sh_w * 0.5;

        var ry =
            sh_h * 0.5;

        if (
            rx > 0.001 &&
            ry > 0.001
        )
        {
            for (
                var sx = start_x;
                sx <= end_x;
                sx++
            )
            {
                var dx =
                    (sx + 0.5) -
                    shadow_x;

                var nx =
                    dx /
                    rx;

                if (abs(nx) <= 1.0001)
                {
                    var circle_term =
                        max(
                            0,
                            1 -
                            nx * nx
                        );

                    var yoff =
                        ry *
                        sqrt(circle_term);

                    draw_rectangle(
                        sx,
                        shadow_y - yoff,
                        sx + 1,
                        shadow_y + yoff,
                        false
                    );
                }
            }
        }

        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

// ====================================================
// JUMP TRAIL — MOTION-FOLLOWING PIXEL AIR STREAKS
// ====================================================

// The trail follows recorded movement, not facing alone.
// Fewer, uneven streaks; tapered tips; reduced apex strength.
// No sprite or circular particles are used.
if (
    jump_trail_enabled &&
    !player_is_grabbed &&
    state != "gravity_bubble" &&
    state != "dead" &&
    array_length(jump_trail_points) >= 3
)
{
    var air_col = make_color_rgb(250, 250, 245);
    var air_count = array_length(jump_trail_points);

    // Three staggered lanes, rather than three identical
    // streaks drawn at every history sample.
    for (var lane = 0; lane < 3; lane++)
    {
        var lane_offset = (lane - 1) * 5;
        var lane_start = lane; // stagger lane age
        var lane_stride = (lane == 1) ? 3 : 4;

        for (var i = lane_start; i < air_count - 2; i += lane_stride)
        {
            var p = jump_trail_points[i];
            var q = jump_trail_points[i + 2];

            if (!is_struct(p) || !is_struct(q)) continue;

            var dx = p.x - q.x;
            var dy = p.y - q.y;
            var d = point_distance(0, 0, dx, dy);
            if (d < 0.8 || d > 75) continue;

            // Unit tangent: direction of travel, from old to new.
            var ux = dx / d;
            var uy = dy / d;
            var nx = -uy;
            var ny = ux;

            var speed_now = variable_struct_exists(p, "speed")
                ? p.speed : point_distance(0, 0, p.hsp, p.vsp);

            var speed_t = clamp(
                (speed_now - jump_trail_speed_min) /
                max(0.01, jump_trail_speed_full - jump_trail_speed_min),
                0, 1
            );

            // Near the jump apex, shorten and fade the airflow.
            var vertical_t = clamp(abs(p.vsp) / 3.5, 0, 1);
            var apex_t = lerp(jump_trail_apex_factor, 1, vertical_t);
            var motion_t = speed_t * apex_t;
            if (motion_t < 0.055) continue;

            var age_t = 1 - i / max(1, air_count - 1);
            var fade_t = age_t;
            var lane_weight = (lane == 1) ? 1 : ((lane == 0) ? 0.70 : 0.52);
            var alpha = jump_trail_alpha * fade_t * motion_t * lane_weight;
            if (alpha < 0.025) continue;

            // Slightly different lengths per lane, plus
            // deterministic variation along the recorded path.
            var variation = 0.84 + 0.16 * ((i + lane * 2) mod 3);
            var lane_length = (lane == 1) ? 22 : ((lane == 0) ? 15 : 11);
            var len = lane_length * jump_trail_length *
                (0.38 + 0.62 * speed_t) * variation;

            // Anchor behind the player's actual travel position.
            var ax = p.x - ux * (5 + lane * 2) + nx * lane_offset;
            var ay = p.y + jump_trail_y_lift - uy * (5 + lane * 2) + ny * lane_offset;

            // Three short pieces form one flowing streak.
            // Deliberate tiny breaks keep the far end airy.
            var x0 = round(ax);
            var y0 = round(ay);
            var x1 = round(ax - ux * len * 0.44 + nx * 0.8);
            var y1 = round(ay - uy * len * 0.44 + ny * 0.8);
            var x2 = round(ax - ux * len * 0.78 + nx * 1.6);
            var y2 = round(ay - uy * len * 0.78 + ny * 1.6);
            var x3 = round(ax - ux * len + nx * 2.1);
            var y3 = round(ay - uy * len + ny * 2.1);

            draw_set_color(air_col);
            draw_set_alpha(alpha);
            draw_line(x0, y0, x1, y1);

            draw_set_alpha(alpha * 0.85);
            draw_line(x1, y1, x2, y2);

            // Thin, faint tip. Alternate tiny gaps to avoid
            // a repeated 'three parallel stripes' appearance.
            if (((i + lane) mod 3) != 0)
            {
                draw_set_alpha(alpha * 0.55);
                draw_line(x2, y2, x3, y3);
            }
        }
    }
}

// Restore state before drawing JumpBot and the bird.
draw_set_color(c_white);
draw_set_alpha(1);

// ----------------------------------------------------
// Draw player / wallhit replacement pose
// ----------------------------------------------------

if (!variable_instance_exists(id, "wallhit_overlay_sprite"))
{
    wallhit_overlay_sprite =
        asset_get_index(
            "spriteBotWallHit"
        );
}

if (!variable_instance_exists(id, "wallhit_timer"))
{
    wallhit_timer = 0;
}

var draw_spr =
    sprite_index;

var draw_img =
    image_index;

if (
    wallhit_timer > 0 &&
    wallhit_overlay_sprite != -1
)
{
    draw_spr =
        wallhit_overlay_sprite;

    draw_img =
        0;
}


// ====================================================
// DRAW LIVING PLAYER
//
// Gravity Bubble compression is applied here only.
// Facing is preserved because the scale multiplies the
// existing signed image_xscale.
// ====================================================

if (draw_spr != -1)
{
    draw_sprite_ext(
        draw_spr,
        draw_img,
        px,
        py,
        image_xscale *
        gravity_bubble_draw_scale,
        image_yscale *
        gravity_bubble_draw_scale,
        player_final_draw_angle,
        image_blend,
        image_alpha
    );
}


// ----------------------------------------------------
// Wall-hit overlay
// ----------------------------------------------------

if (!variable_instance_exists(id, "wallhit_overlay_sprite"))
{
    wallhit_overlay_sprite =
        asset_get_index(
            "spriteBotWallHit"
        );
}

if (!variable_instance_exists(id, "wallhit_overlay_alpha"))
{
    wallhit_overlay_alpha = 1;
}

if (!variable_instance_exists(id, "wallhit_timer"))
{
    wallhit_timer = 0;
}

if (
    wallhit_timer > 0 &&
    wallhit_overlay_sprite != -1
)
{
    draw_sprite_ext(
        wallhit_overlay_sprite,
        0,
        px,
        py,
        image_xscale *
        gravity_bubble_draw_scale,
        image_yscale *
        gravity_bubble_draw_scale,
        player_final_draw_angle,
        c_white,
        wallhit_overlay_alpha
    );
}


// ----------------------------------------------------
// Draw living bird in front
// ----------------------------------------------------

if (
    variable_instance_exists(id, "bird") &&
    instance_exists(bird)
)
{
    var _bird_is_alive =
        !variable_instance_exists(
            bird,
            "bird_state"
        ) ||
        bird.bird_state == "alive";

    if (_bird_is_alive)
    {
        if (
            variable_instance_exists(
                bird,
                "owner"
            ) &&
            bird.owner == id
        )
        {
            var rel_x =
                bird.x -
                x;

            var rel_y =
                bird.y -
                y;


            // ========================================
            // GRAVITY BUBBLE BIRD COMPRESSION
            //
            // Compress BOTH the bird sprite and its
            // position relative to JumpBot.
            //
            // This pulls the complete bot/bird visual
            // toward the same central gravity point.
            // ========================================

            rel_x *=
                gravity_bubble_draw_scale;

            rel_y *=
                gravity_bubble_draw_scale;


            var bird_draw_x =
                round(
                    px +
                    rel_x
                );

            var bird_draw_y =
                round(
                    py +
                    rel_y
                );


            if (bird.sprite_index != -1)
            {
                draw_sprite_ext(
                    bird.sprite_index,
                    bird.image_index,
                    bird_draw_x,
                    bird_draw_y,
                    bird.image_xscale *
                    gravity_bubble_draw_scale,
                    bird.image_yscale *
                    gravity_bubble_draw_scale,
                    bird.image_angle,
                    bird.image_blend,
                    bird.image_alpha
                );
            }
        }
        else
        {
            // ----------------------------------------
            // Free/non-owned bird.
            //
            // Do NOT apply the player's Gravity Bubble
            // compression to a detached bird.
            // ----------------------------------------

            if (bird.sprite_index != -1)
            {
                draw_sprite_ext(
                    bird.sprite_index,
                    bird.image_index,
                    round(bird.x),
                    round(bird.y) +
                    draw_floor_inset,
                    bird.image_xscale,
                    bird.image_yscale,
                    bird.image_angle,
                    bird.image_blend,
                    bird.image_alpha
                );
            }
        }
    }
}