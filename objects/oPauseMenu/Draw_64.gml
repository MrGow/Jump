/// oPauseMenu — Draw GUI

// Force fixed GUI space
var gw = global.GAME_W;
var gh = global.GAME_H;

// Absolute screen center in GUI space
var cx = gw * 0.5;
var cy = gh * 0.5;

// Dark overlay
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

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