/// oSpringPlatformBig — Draw

draw_self();

if (!debug_draw) exit;


draw_set_alpha(1);

// ----------------------------------------------------
// Draw spring top surface
// ----------------------------------------------------
var debug_surface_y =
    bbox_top +
    surface_y_offset;

var debug_surface_left =
    bbox_left +
    top_inset +
    surface_x_offset;

var debug_surface_right =
    bbox_right -
    top_inset +
    surface_x_offset;

draw_set_color(c_yellow);

draw_line(
    debug_surface_left,
    debug_surface_y,
    debug_surface_right,
    debug_surface_y
);



// ----------------------------------------------------
// Resolve debug direction
// ----------------------------------------------------
var direction_text =
    string_lower(
        string(spring_push_direction)
    );

var debug_direction = 1;

if (
    direction_text == "left" ||
    direction_text == "l" ||
    direction_text == "-1"
)
{
    debug_direction = -1;
}

