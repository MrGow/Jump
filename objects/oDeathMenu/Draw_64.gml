/// oDeathMenu — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var cx = gw * 0.5;
var cy = gh * 0.5;

// Darken background
draw_set_alpha(0.6 * alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Death UI sprite
var death_ui_sprite = asset_get_index("spriteDeathUI");

var px;
var py;
var panel_w;
var panel_h;

if (death_ui_sprite != -1)
{
    panel_w = sprite_get_width(death_ui_sprite);
    panel_h = sprite_get_height(death_ui_sprite);

    px = floor(cx - panel_w * 0.5);
    py = floor(cy - panel_h * 0.5);

    draw_set_alpha(alpha);
    draw_sprite(death_ui_sprite, 0, px, py);
}
else
{
    panel_w = 300;
    panel_h = 120;

    px = floor(cx - panel_w * 0.5);
    py = floor(cy - panel_h * 0.5);

    draw_set_alpha(alpha);
    draw_set_color(make_color_rgb(30, 30, 40));
    draw_rectangle(px, py, px + panel_w, py + panel_h, false);
}

// Text
draw_set_alpha(alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Main failure text
draw_set_font(PIXELOPERATORBOLD18);
draw_set_color(make_color_rgb(255, 80, 70));
draw_text(cx, py + 43, "SYSTEM FAILURE");

// Blinking retry text
var blink_on = ((current_time div 450) mod 2) == 0;

draw_set_font(PIXELOPERATORBOLD14);

if (blink_on)
{
    draw_set_color(make_color_rgb(255, 220, 80));
}
else
{
    draw_set_color(make_color_rgb(180, 150, 60));
}

draw_text(cx, py + 70, "> REINITIALIZE_");

// Reset draw state
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);