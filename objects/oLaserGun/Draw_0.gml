/// oLaserGun — Draw

draw_self();

if (!active) exit;

var sx  = laser_start_x;
var sy  = laser_start_y;
var len = laser_len;

var ray_spr = spriteLaserGunRepeatingRay;
var end_spr = spriteLaserGunShootEnd;

// Beam sprite is vertical, so tile by height
var tile_len = sprite_get_height(ray_spr);
if (tile_len <= 0) tile_len = 8;

// Sprite points down by default, so rotate from DOWN to laser_dir
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
        0,
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
// ----------------------------------------------------
draw_sprite_ext(
    end_spr,
    0,
    sx + lengthdir_x(len, laser_dir),
    sy + lengthdir_y(len, laser_dir),
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