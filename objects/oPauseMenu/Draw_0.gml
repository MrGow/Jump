/// oPauseMenu — Draw

scr_settings_init();

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

draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(vx, vy, vx + vw, vy + vh, false);

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
    py = floor(cy - panel_h * 0.5);

    draw_set_alpha(1);
    draw_sprite(pause_ui_sprite, 0, px, py);
}
else
{
    panel_w = 260;
    panel_h = 150;

    px = floor(cx - panel_w * 0.5);
    py = floor(cy - panel_h * 0.5);

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(40, 40, 55));
    draw_rectangle(px, py, px + panel_w, py + panel_h, false);

    draw_set_color(c_white);
    draw_rectangle(px, py, px + panel_w, py + panel_h, true);
}

draw_set_font(PIXELOPERATORBOLD14);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(230, 235, 235));

draw_text(cx, py + 16, menu_mode == "settings" ? "SYSTEM SETTINGS" : "SYSTEM PAUSED");

if (menu_mode == "main")
{
    draw_set_font(PIXELOPERATORREGULAR10);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(make_color_rgb(165, 200, 165));
    draw_text(px + 52, py + 48, "jumpbot@factory:~$ menu");

    draw_set_color(make_color_rgb(90, 140, 90));
    draw_line(px + 52, py + 63, px + panel_w - 58, py + 63);

    draw_set_font(PIXELOPERATORBOLD18);

    var yy = py + 68;

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
            draw_set_color(make_color_rgb(200, 200, 200));
            draw_text(px + 54, yy, txt);
        }

        yy += 20;
    }
}
else if (menu_mode == "settings")
{
    var spr_left  = asset_get_index("spritePauseUILeftNavigator");
    var spr_right = asset_get_index("spritePauseUIRightNavigator");
    var spr_bar   = asset_get_index("spritePauseUIEmptyDialBox");
    var spr_dial  = asset_get_index("spritePauseUIDial");

    var widget_scale = 0.62;
    var arrow_scale  = widget_scale * 0.5;

    draw_set_font(PIXELOPERATORREGULAR10);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    var label_x = px + 46;
    var value_x = px + 176;

    var yy = py + 48;
    var gap = 17;

    for (var i = 0; i < array_length(settings_items); i++)
    {
        var item = settings_items[i];
        var is_sel = (i == settings_index);

        var disabled = (item == "resolution" && !scr_settings_resolution_enabled());

        var col_text;
        if (disabled) col_text = make_color_rgb(95, 100, 105);
        else if (is_sel) col_text = make_color_rgb(255, 220, 80);
        else col_text = make_color_rgb(200, 200, 200);

        draw_set_color(col_text);

        var label = scr_settings_label(item);

        if (is_sel) draw_text(label_x - 16, yy, ">");
        draw_text(label_x, yy, label);

        if (
            item == "master_volume" ||
            item == "music_volume" ||
            item == "sfx_volume" ||
            item == "brightness" ||
            item == "contrast"
        )
        {
            var val = scr_settings_value01(item);

            var bx = value_x;
            var by = yy;

            var bar_w = 70;
            var bar_h = 8;

            if (spr_bar != -1)
            {
                bar_w = sprite_get_width(spr_bar) * widget_scale;
                bar_h = sprite_get_height(spr_bar) * widget_scale;

                draw_sprite_ext(
                    spr_bar,
                    0,
                    bx,
                    by - bar_h * 0.5,
                    widget_scale,
                    widget_scale,
                    0,
                    c_white,
                    1
                );
            }

            var dial_x = bx + round(bar_w * val);

            if (spr_dial != -1)
            {
                draw_sprite_ext(
                    spr_dial,
                    0,
                    dial_x,
                    by,
                    widget_scale,
                    widget_scale,
                    0,
                    c_white,
                    1
                );
            }
        }

        if (item == "display_mode" || item == "resolution")
        {
            draw_set_halign(fa_center);
            draw_set_color(col_text);

            var out_txt = "";

            if (item == "display_mode") out_txt = global.display_mode_labels[global.display_mode_index];
            else out_txt = global.resolution_labels[global.resolution_index];

            var tx = value_x + 40;
            var lx = tx - 34;
            var rx = tx + 34;

            var arrow_col = disabled ? make_color_rgb(80, 85, 90) : c_white;

            if (spr_left != -1)
            {
                draw_sprite_ext(spr_left, 0, lx, yy, arrow_scale, arrow_scale, 0, arrow_col, 1);
            }

            draw_text(tx, yy, out_txt);

            if (spr_right != -1)
            {
                draw_sprite_ext(spr_right, 0, rx, yy, arrow_scale, arrow_scale, 0, arrow_col, 1);
            }

            draw_set_halign(fa_left);
        }

        yy += gap;
    }
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);