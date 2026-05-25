/// oMainMenu — Draw

var gw = 640;
var gh = 360;
var cx = gw * 0.5;

// Background
draw_set_alpha(1);
draw_set_color(make_color_rgb(12, 18, 28));
draw_rectangle(0, 0, gw, gh, false);

// Logo
if (logo_sprite != -1)
{
    draw_sprite_ext(logo_sprite, 0, cx + 10, 85, 0.16, 0.16, 0, c_white, 1);
}

// Menu text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var yy = 205;

for (var i = 0; i < array_length(menu_items); i++)
{
    draw_set_color(i == selected_index ? c_yellow : c_white);
    draw_text(cx - 8, yy, (i == selected_index ? "▶ " : "") + string(menu_items[i]));
    yy += 36;
}

draw_set_color(make_color_rgb(170, 180, 185));
draw_text(cx, gh - 18, "Space / Enter = Select");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);