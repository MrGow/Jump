/// oPauseMenu — Draw

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Dark overlay
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Panel
var pw = 320;
var ph = 220;
var px = floor(gw * 0.5 - pw * 0.5);
var py = floor(gh * 0.5 - ph * 0.5);

draw_set_alpha(1);
draw_set_color(make_color_rgb(40, 40, 55));
draw_rectangle(px, py, px + pw, py + ph, false);

draw_set_color(c_white);
draw_rectangle(px, py, px + pw, py + ph, true);

// Title
draw_text(px + 16, py + 16, "Paused");

// Menu entries
var yy = py + 56;
for (var i = 0; i < array_length(menu_items); i++) {
    if (i == selected_index) {
        draw_set_color(c_yellow);
        draw_text(px + 20, yy, "> " + string(menu_items[i]));
    } else {
        draw_set_color(c_white);
        draw_text(px + 36, yy, string(menu_items[i]));
    }
    yy += 28;
}

draw_set_color(c_white);
draw_text(px + 16, py + ph - 24, "Jump/Enter = Select   Esc/P = Pause");
draw_set_alpha(1);