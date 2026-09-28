/// oMissileLauncher — Draw GUI

if (
    !show_launch_bar &&
    launch_ui_hold_timer <= 0
)
{
    exit;
}

var cam = view_camera[0];

if (cam == -1)
{
    exit;
}

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// World position above the pressure plate.
var world_x = plate_x;

var world_y =
    plate_y -
    plate_height * 0.5 -
    26;

// Convert world coordinates into GUI coordinates.
var text_x = round(
    (world_x - cam_x)
    *
    gui_w / cam_w
);

var text_y = round(
    (world_y - cam_y)
    *
    gui_h / cam_h
);

var percentage =
    (launch_ui_hold_timer > 0)
    ?
    100
    :
    clamp(
        floor(launch_progress * 100),
        0,
        99
    );

var label =
    "MISSILE LAUNCHING... "
    +
    string(percentage)
    +
    "%";

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1);

// Hard black outline for readability over scenery.
draw_set_color(c_black);

draw_text(text_x - 1, text_y, label);
draw_text(text_x + 1, text_y, label);
draw_text(text_x, text_y - 1, label);
draw_text(text_x, text_y + 1, label);

draw_set_color(
    make_color_rgb(255, 163, 65)
);

draw_text(
    text_x,
    text_y,
    label
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);