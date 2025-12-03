/// oDeathMenu — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Darken background
draw_set_alpha(0.6 * alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Panel
var pw = 300;
var ph = 200;
var px = gw * 0.5 - pw * 0.5;
var py = gh * 0.5 - ph * 0.5;

draw_set_alpha(alpha);
draw_set_color(make_color_rgb(30, 30, 40));
draw_rectangle(px, py, px + pw, py + ph, false);

// Title
draw_set_color(c_white);
draw_text(px + 16, py + 16, "You Fell");

// Scrap info
draw_text(px + 16, py + 40, "Scrap: " + string(global.scrap_total));

// Upgrades list
var list_y = py + 70;
var count  = array_length(global.upgrades);

for (var i = 0; i < count; i++) {
    var u    = global.upgrades[i];
    var cost = scr_upgrade_cost(i);

    var line = u.name
        + "  (Lv " + string(u.level) + "/" + string(u.max_level) + ")"
        + "  - " + string(cost);

    if (i == selected_index) {
        draw_set_color(c_yellow);
        draw_text(px + 16, list_y, "> " + line);
    } else {
        draw_set_color(c_white);
        draw_text(px + 32, list_y, line);
    }

    list_y += 20;
}

draw_set_color(c_white);
draw_text(px + 16, py + ph - 24, "Press Jump to Climb again");
