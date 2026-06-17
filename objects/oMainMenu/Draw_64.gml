/// oMainMenu — Draw GUI

var gw = 640;
var gh = 360;
var cx = round(gw * 0.5);

// Dark overlay over live gameplay background
draw_set_alpha(0.55);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);

// Logo
if (logo_sprite != -1)
{
    draw_sprite_ext(logo_sprite, 0, cx, 86, logo_scale, logo_scale, 0, c_white, 1);
}

// Menu text
draw_set_font(PIXELOPERATORBOLD18);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var yy = 205;
var line_gap = 36;

for (var i = 0; i < array_length(menu_items); i++)
{
    var txt = string(menu_items[i]);
    var is_sel = (i == selected_index);

    draw_set_color(is_sel ? make_color_rgb(255, 220, 80) : make_color_rgb(200, 200, 200));
    draw_text(cx, round(yy), txt);

    if (is_sel)
    {
        var tw = string_width(txt);

        draw_set_halign(fa_left);
        draw_set_color(make_color_rgb(255, 235, 110));
        draw_text(round(cx - tw * 0.5 - 26), round(yy), ">");
        draw_set_halign(fa_center);
    }

    yy += line_gap;
}

// Version number bottom-left
draw_set_font(PIXELOPERATORREGULAR10);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(140, 150, 160));
draw_text(12, gh - 10, "v1.0.0");

// Helper text bottom-right
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(140, 150, 160));
draw_text(gw - 12, gh - 10, "Space / Enter = Select");

// Reset draw state
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);