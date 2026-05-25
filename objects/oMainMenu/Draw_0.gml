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
    draw_sprite_ext(logo_sprite, 0, cx, 86, logo_scale, logo_scale, 0, c_white, 1);
}

// Menu text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var yy = 205;
var line_gap = 36;

for (var i = 0; i < array_length(menu_items); i++)
{
    var is_sel = (i == selected_index);

    draw_set_color(is_sel ? c_yellow : c_white);
    draw_text(cx, yy, string(menu_items[i]));

    if (is_sel)
    {
        draw_text(cx - 78, yy, "▶");
    }

    yy += line_gap;
}

// Helper text bottom-right, smaller
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(140, 150, 160));
draw_text_transformed(gw - 12, gh - 10, "Space / Enter = Select", 0.65, 0.65, 0);

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);