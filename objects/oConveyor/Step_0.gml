/// oConveyor - Step
prev_x = x;
prev_y = y;

if (enabled && do_move)
{
    t += move_speed;
    var s = sin(t * 0.02);
    if (move_axis == 0) x = x0 + s * move_range;
    else               y = y0 + s * move_range;
}

dx = x - prev_x;
dy = y - prev_y;
