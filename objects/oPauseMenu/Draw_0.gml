/// oPauseMenu — Draw

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

// Dark overlay
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(vx, vy, vx + vw, vy + vh, false);

// Logo above panel
if (pause_logo_sprite != -1) {
    draw_sprite_ext(
        pause_logo_sprite,
        0,
        cx,
        cy - 105,
        0.13,
        0.13,
        0,
        c_white,
        1
    );
}

// Panel only for menu
var pw = 260;
var ph = 150;
var px = floor(cx - pw * 0.5);
var py = floor(cy - ph * 0.5 + 40);

draw_set_alpha(1);
draw_set_color(make_color_rgb(40, 40, 55));
draw_rectangle(px, py, px + pw, py + ph, false);

draw_set_color(c_white);
draw_rectangle(px, py, px + pw, py + ph, true);

// Menu entries
var yy = py + 18;

for (var i = 0; i < array_length(menu_items); i++) {
    if (i == selected_index) {
        draw_set_color(c_yellow);
        draw_text(px + 42, yy, "> " + string(menu_items[i]));
    } else {
        draw_set_color(c_white);
        draw_text(px + 54, yy, string(menu_items[i]));
    }

    yy += 20;
}

draw_set_color(c_white);
draw_text(px + 38, py + ph - 18, "Jump/Enter = Select");

draw_set_alpha(1);