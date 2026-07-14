/// oUpwardsChaseController — Draw GUI

draw_set_color(c_white);

draw_text(
    20,
    20,
    "UPWARDS CHASE ACTIVE: " + string(chase_active)
);

draw_text(
    20,
    40,
    "CHASE SPEED: " + string(chase_speed)
);

draw_text(
    20,
    60,
    "CAM Y: " + string(cam_y)
);

if (instance_exists(activation_trigger))
{
    draw_text(
        20,
        80,
        "TRIGGER Y: " + string(activation_trigger.y)
    );
}

var p = instance_find(oPlayer, 0);

if (p != noone)
{
    draw_text(
        20,
        100,
        "PLAYER Y: " + string(p.y)
    );
}