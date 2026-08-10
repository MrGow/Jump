/// oArea1ElevatorActivationTrigger — Draw


if (!debug_draw)
{
    exit;
}


var left =
    x -
    trigger_width * 0.5;

var right =
    x +
    trigger_width * 0.5;

var top =
    y -
    trigger_height * 0.5;

var bottom =
    y +
    trigger_height * 0.5;


draw_set_alpha(
    0.25
);

draw_set_color(
    activated
    ? c_lime
    : c_yellow
);


draw_rectangle(
    left,
    top,
    right,
    bottom,
    false
);


draw_set_alpha(1);
draw_set_color(c_white);