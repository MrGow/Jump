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

// Pause UI Sprite
var pause_ui_sprite = asset_get_index("spritePauseUI");

var px;
var py;
var panel_w;
var panel_h;

if (pause_ui_sprite != -1)
{
    panel_w = sprite_get_width(pause_ui_sprite);
    panel_h = sprite_get_height(pause_ui_sprite);

    px = floor(cx - panel_w * 0.5);
    py = floor(cy - panel_h * 0.5 + 40);

    draw_set_alpha(1);
    draw_sprite(pause_ui_sprite, 0, px, py);
}
else
{
    panel_w = 260;
    panel_h = 150;

    px = floor(cx - panel_w * 0.5);
    py = floor(cy - panel_h * 0.5 + 40);

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(40, 40, 55));
    draw_rectangle(px, py, px + panel_w, py + panel_h, false);

    draw_set_color(c_white);
    draw_rectangle(px, py, px + panel_w, py + panel_h, true);
}

// Logo above panel
if (pause_logo_sprite != -1)
{
    draw_sprite_ext(pause_logo_sprite, 0, cx, py - 52, 0.13, 0.13, 0, c_white, 1);
}

// Header text
draw_set_font(PIXELOPERATORBOLD14);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(230, 235, 235));
draw_text(cx, py + 16, "SYSTEM PAUSED");

// Terminal header
draw_set_font(PIXELOPERATORREGULAR10);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(make_color_rgb(120, 220, 120));
draw_text(px + 34, py + 48, "jumpbot@factory:~$ menu");

draw_set_color(make_color_rgb(90, 140, 90));
draw_line(px + 34, py + 62, px + panel_w - 34, py + 62);

// Menu entries
draw_set_font(PIXELOPERATORBOLD18);

var yy = py + 74;

for (var i = 0; i < array_length(menu_items); i++)
{
    var txt = string_lower(string(menu_items[i]));
    txt = string_replace_all(txt, " ", "_");

    if (i == selected_index)
    {
        draw_set_color(make_color_rgb(255, 220, 80));
        draw_text(px + 34, yy, "> " + txt);
    }
    else
    {
        draw_set_color(make_color_rgb(220, 220, 220));
        draw_text(px + 54, yy, txt);
    }

    yy += 20;
}

// Reset draw state
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);