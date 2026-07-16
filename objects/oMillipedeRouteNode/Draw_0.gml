/// oMillipedeRouteNode — Draw

if (!debug_draw)
{
    exit;
}

var surface_names = [
    "FLOOR",
    "RIGHT WALL",
    "CEILING",
    "LEFT WALL"
];

var sr =
    ((round(surface_rotation) mod 4) + 4) mod 4;

var ang = sr * 90;

draw_set_alpha(0.8);
draw_set_color(c_aqua);

draw_circle(
    x,
    y,
    5,
    false
);

// Surface-facing marker
draw_line(
    x,
    y,
    x + lengthdir_x(18, ang + 90),
    y + lengthdir_y(18, ang + 90)
);

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

draw_text(
    x,
    y - 10,
    string(route_id) +
    ":" +
    string(node_order) +
    " " +
    surface_names[sr]
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);