/// oLaserGun — Draw

draw_self();

if (!active) exit;

var sx  = laser_start_x;
var sy  = laser_start_y;
var len = laser_len;

var ray_spr = spriteLaserGunRepeatingRay;
var end_spr = spriteLaserGunShootEnd;

var fx_frame = floor(laser_fx_frame);

var ray_frame = fx_frame mod sprite_get_number(ray_spr);
var end_frame = fx_frame mod sprite_get_number(end_spr);

var tile_len = sprite_get_height(ray_spr);
if (tile_len <= 0) tile_len = 8;

var beam_ang = laser_dir - 90;

// ----------------------------------------------------
// Draw repeating beam
// ----------------------------------------------------
var drawn = 0;

while (drawn < len)
{
    var rx = sx + lengthdir_x(drawn, laser_dir);
    var ry = sy + lengthdir_y(drawn, laser_dir);

    draw_sprite_ext(
        ray_spr,
        ray_frame,
        rx,
        ry,
        1,
        1,
        beam_ang,
        c_white,
        1
    );

    drawn += tile_len;
}

// ----------------------------------------------------
// Draw impact/end effect
// Place on beam tile grid so it always connects cleanly.
// ----------------------------------------------------
var end_join_len = max(0, floor(len / tile_len) * tile_len);

draw_sprite_ext(
    end_spr,
    end_frame,
    sx + lengthdir_x(end_join_len, laser_dir),
    sy + lengthdir_y(end_join_len, laser_dir),
    1,
    1,
    beam_ang,
    c_white,
    1
);

// ----------------------------------------------------
// Debug
// ----------------------------------------------------
if (debug_draw)
{
    draw_set_alpha(0.5);
    draw_set_color(c_red);

    draw_line_width(
        sx,
        sy,
        sx + lengthdir_x(len, laser_dir),
        sy + lengthdir_y(len, laser_dir),
        2
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}