/// oAreaTitleDisplay — Draw GUI

var gw = 640;
var gh = 360;

var cx = gw * 0.5;
var title_y = 64;

var shown = string_copy(area_name, 1, shown_chars);

// Soft dark strip
draw_set_alpha(0.35 * alpha);
draw_set_color(c_black);
draw_rectangle(0, title_y - 28, gw, title_y + 42, false);

// Terminal label
draw_set_alpha(alpha);

draw_set_font(PIXELOPERATORREGULAR10);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(make_color_rgb(160, 200, 160));
draw_text(cx, title_y - 12, "jumpbot@nav:~$ entering_area");

// Area name
draw_set_font(PIXELOPERATORBOLD18);
draw_set_color(make_color_rgb(255, 220, 80));
draw_text(cx, title_y + 12, shown);

// Blinking cursor
if (state != "fade")
{
    if ((current_time div 350) mod 2 == 0)
    {
        var tw = string_width(shown);
        draw_text(cx + tw * 0.5 + 8, title_y + 12, "_");
    }
}

// Reset draw state
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);