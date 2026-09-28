/// oGunShipController — Draw GUI

if (!active || !instance_exists(ship))
{
    exit;
}

var bar_w = 240;
var bar_h = 12;

var bar_x = round((display_get_gui_width() - bar_w) * 0.5);
var bar_y = 22;

var frame_col = make_color_rgb(12, 18, 28);
var empty_col = make_color_rgb(43, 49, 62);
var fill_col = make_color_rgb(238, 69, 49);
var edge_col = make_color_rgb(255, 161, 72);

draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_text(bar_x + bar_w * 0.5, bar_y - 4, "GUNSHIP");

draw_set_color(frame_col);
draw_rectangle(
    bar_x - 3, bar_y - 3,
    bar_x + bar_w + 3, bar_y + bar_h + 3,
    false
);

draw_set_color(empty_col);
draw_rectangle(
    bar_x, bar_y,
    bar_x + bar_w, bar_y + bar_h,
    false
);

draw_set_color(fill_col);
draw_rectangle(
    bar_x, bar_y,
    bar_x + bar_w * clamp(hp / max_hp, 0, 1),
    bar_y + bar_h,
    false
);

// Four readable quarters.
draw_set_color(frame_col);
for (var i = 1; i < max_hp; i++)
{
    var divider_x = bar_x + bar_w * i / max_hp;
    draw_rectangle(
        divider_x - 1, bar_y,
        divider_x + 1, bar_y + bar_h,
        false
    );
}

draw_set_color(edge_col);
draw_rectangle(
    bar_x - 1, bar_y - 1,
    bar_x + bar_w + 1, bar_y + bar_h + 1,
    true
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);