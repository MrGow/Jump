/// oPauseMenu — Draw

// Draw pause UI in world Draw, but anchor it to the active camera view.
// This keeps the menu screen-locked even if Draw GUI is not running.
var cam = view_camera[0];

var vx = 0;
var vy = 0;
var vw = display_get_gui_width();
var vh = display_get_gui_height();

if (is_real(cam) && cam >= 0) {
    vx = camera_get_view_x(cam);
    vy = camera_get_view_y(cam);
    vw = camera_get_view_width(cam);
    vh = camera_get_view_height(cam);
}

var cx = vx + vw * 0.5;
var cy = vy + vh * 0.5;

// Dark overlay (over current view only)
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(vx, vy, vx + vw, vy + vh, false);

// Panel
var pw = 220;
var ph = 150;
var px = floor(cx - pw * 0.5);
var py = floor(cy - ph * 0.5);

draw_set_alpha(1);
draw_set_color(make_color_rgb(40, 40, 55));
draw_rectangle(px, py, px + pw, py + ph, false);

draw_set_color(c_white);
draw_rectangle(px, py, px + pw, py + ph, true);

// Title
draw_text(px + 12, py + 10, "Paused");

// Menu entries
var yy = py + 34;
for (var i = 0; i < array_length(menu_items); i++) {
    if (i == selected_index) {
        draw_set_color(c_yellow);
        draw_text(px + 12, yy, "> " + string(menu_items[i]));
    } else {
        draw_set_color(c_white);
        draw_text(px + 24, yy, string(menu_items[i]));
    }
    yy += 20;
}

draw_set_color(c_white);
draw_text(px + 12, py + ph - 16, "Jump/Enter = Select");
draw_set_alpha(1);