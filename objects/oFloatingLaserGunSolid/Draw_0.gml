/// oFloatingLaserGunSolid — Draw

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

if (!debug_draw)
{
    exit;
}

draw_set_alpha(0.40);

draw_sprite_ext(
    spriteFloatingLaserGunMaskSolid,
    0,
    x,
    y,
    1,
    1,
    image_angle,
    c_lime,
    1
);

draw_set_alpha(1);
draw_set_color(c_lime);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    true
);

draw_set_color(c_white);