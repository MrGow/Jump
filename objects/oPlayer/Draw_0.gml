/// oPlayer - Draw (player + chopped ledge-aware shadow + jump trail + perched bird)

if (!variable_instance_exists(id, "draw_floor_inset")) draw_floor_inset = 9;

var px = round(x);
var py = round(y) + draw_floor_inset;

// ----------------------------------------------------
// Ground shadow (chopped to supported ledge area)
// ----------------------------------------------------
if (!variable_instance_exists(id, "shadow_enabled"))       shadow_enabled = true;
if (!variable_instance_exists(id, "shadow_max_dist"))      shadow_max_dist = 56;
if (!variable_instance_exists(id, "shadow_ground_dist"))   shadow_ground_dist = -1;
if (!variable_instance_exists(id, "shadow_support_ratio")) shadow_support_ratio = 1;
if (!variable_instance_exists(id, "shadow_support_cx"))    shadow_support_cx = x;
if (!variable_instance_exists(id, "shadow_support_left"))  shadow_support_left = bbox_left;
if (!variable_instance_exists(id, "shadow_support_right")) shadow_support_right = bbox_right;

if (!variable_instance_exists(id, "shadow_max_w"))      shadow_max_w = 26;
if (!variable_instance_exists(id, "shadow_min_w"))      shadow_min_w = 10;
if (!variable_instance_exists(id, "shadow_max_h"))      shadow_max_h = 8;
if (!variable_instance_exists(id, "shadow_min_h"))      shadow_min_h = 3;
if (!variable_instance_exists(id, "shadow_alpha_near")) shadow_alpha_near = 0.22;
if (!variable_instance_exists(id, "shadow_alpha_far"))  shadow_alpha_far = 0.00;
if (!variable_instance_exists(id, "shadow_y_nudge"))    shadow_y_nudge = 0;

if (shadow_enabled && shadow_ground_dist >= 0 && shadow_ground_dist <= shadow_max_dist)
{
    var shadow_t = 1 - clamp(shadow_ground_dist / max(1, shadow_max_dist), 0, 1);

    var sh_w = lerp(shadow_min_w, shadow_max_w, shadow_t);
    var sh_h = lerp(shadow_min_h, shadow_max_h, shadow_t);
    var sh_a = lerp(shadow_alpha_far, shadow_alpha_near, shadow_t);

    var support_ratio = clamp(shadow_support_ratio, 0, 1);
    var support_cx    = shadow_support_cx;
    var support_l     = shadow_support_left;
    var support_r     = shadow_support_right;

    sh_a *= lerp(0.35, 1.0, support_ratio);

    var shadow_x = support_cx;
    var shadow_y = round(bbox_bottom + shadow_ground_dist + draw_floor_inset + shadow_y_nudge);

    var ell_l = shadow_x - sh_w * 0.5;
    var ell_r = shadow_x + sh_w * 0.5;

    var clip_l = max(ell_l, support_l);
    var clip_r = min(ell_r, support_r);

    if (clip_r > clip_l && sh_a > 0.001)
    {
        draw_set_alpha(sh_a);
        draw_set_color(c_black);

        var start_x = floor(clip_l);
        var end_x   = ceil(clip_r);

        var rx = sh_w * 0.5;
        var ry = sh_h * 0.5;

        if (rx > 0.001 && ry > 0.001)
        {
            for (var sx = start_x; sx <= end_x; sx++)
            {
                var dx = (sx + 0.5) - shadow_x;
                var nx = dx / rx;

                if (abs(nx) <= 1)
                {
                    var yoff = ry * sqrt(1 - nx * nx);

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

// ----------------------------------------------------
// Jump trail
// ----------------------------------------------------
if (!variable_instance_exists(id, "jump_trail_enabled"))    jump_trail_enabled = true;
if (!variable_instance_exists(id, "jump_trail_points"))     jump_trail_points = array_create(0);
if (!variable_instance_exists(id, "jump_trail_alpha"))      jump_trail_alpha = 0.32;
if (!variable_instance_exists(id, "jump_trail_size_start")) jump_trail_size_start = 1.00;
if (!variable_instance_exists(id, "jump_trail_size_end"))   jump_trail_size_end = 0.45;
if (!variable_instance_exists(id, "jump_trail_y_lift"))     jump_trail_y_lift = -12;
if (!variable_instance_exists(id, "jump_trail_sprite"))     jump_trail_sprite = -1;

if (jump_trail_enabled)
{
    var trail_len = array_length(jump_trail_points);

    for (var i = trail_len - 1; i >= 0; i--)
    {
        var pnt = jump_trail_points[i];
        if (is_undefined(pnt)) continue;

        var t = 1 - (i / max(1, trail_len - 1));
        var a = jump_trail_alpha * t;
        var sc = lerp(jump_trail_size_end, jump_trail_size_start, t);

        var tx = round(pnt.x - (pnt.facing * (2 + i * 1.5)));
        var ty = round(pnt.y + jump_trail_y_lift - i);

        draw_set_alpha(a);

        if (jump_trail_sprite != -1)
        {
            draw_sprite_ext(
                jump_trail_sprite,
                0,
                tx,
                ty,
                sc * pnt.facing,
                sc,
                0,
                c_white,
                a
            );
        }
        else
        {
            draw_set_color(c_white);
            draw_circle(tx, ty, max(1, round(6 * sc)), false);
            draw_set_color(c_black);
            draw_circle(tx + (2 * pnt.facing), ty, max(1, round(4 * sc)), false);
            draw_set_color(c_white);
        }

        draw_set_alpha(1);
    }
}

// ----------------------------------------------------
// Draw player
// ----------------------------------------------------
draw_sprite_ext(
    sprite_index,
    image_index,
    px,
    py,
    image_xscale,
    image_yscale,
    image_angle,
    image_blend,
    image_alpha
);

// ----------------------------------------------------
// Draw bird in front
// ----------------------------------------------------
if (variable_instance_exists(id, "bird") && instance_exists(bird)) {

    if (variable_instance_exists(bird, "owner") && bird.owner == id) {

        var rel_x = bird.x - x;
        var rel_y = bird.y - y;

        var bird_draw_x = round(px + rel_x);
        var bird_draw_y = round(py + rel_y);

        draw_sprite_ext(
            bird.sprite_index,
            bird.image_index,
            bird_draw_x,
            bird_draw_y,
            bird.image_xscale,
            bird.image_yscale,
            bird.image_angle,
            bird.image_blend,
            bird.image_alpha
        );
    }
    else
    {
        draw_sprite_ext(
            bird.sprite_index,
            bird.image_index,
            round(bird.x),
            round(bird.y) + draw_floor_inset,
            bird.image_xscale,
            bird.image_yscale,
            bird.image_angle,
            bird.image_blend,
            bird.image_alpha
        );
    }
}