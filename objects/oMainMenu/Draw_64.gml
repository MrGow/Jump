/// oMainMenu — Draw GUI

scr_settings_init();

var gw = 640;
var gh = 360;
var cx = round(gw * 0.5);

draw_set_alpha(0.55);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);

if (logo_sprite != -1)
{
    draw_sprite_ext(logo_sprite, 0, cx, 86, logo_scale, logo_scale, 0, c_white, 1);
}

if (menu_mode == "main")
{
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

    draw_set_font(PIXELOPERATORREGULAR10);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(make_color_rgb(140, 150, 160));
    draw_text(gw - 12, gh - 10, "Space / Enter = Select");
}
else if (menu_mode == "settings")
{
    draw_set_font(PIXELOPERATORBOLD18);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 235, 235));
    draw_text(cx, 150, "SYSTEM SETTINGS");

    var spr_left  = asset_get_index("spritePauseUILeftNavigator");
    var spr_right = asset_get_index("spritePauseUIRightNavigator");
    var spr_bar   = asset_get_index("spritePauseUIEmptyDialBox");
    var spr_dial  = asset_get_index("spritePauseUIDial");

    var widget_scale = 0.62;

    draw_set_font(PIXELOPERATORREGULAR10);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    var label_x = 210;
    var value_x = 365;

    var yy = 180;
    var gap = 17;

    for (var i = 0; i < array_length(settings_items); i++)
    {
        var item = settings_items[i];
        var is_sel = (i == settings_index);

        var col_text = is_sel ? make_color_rgb(255, 220, 80) : make_color_rgb(200, 200, 200);

        draw_set_color(col_text);

        var label = string_replace_all(item, "_", " ");

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

                draw_sprite_ext(spr_bar, 0, bx, by - bar_h * 0.5, widget_scale, widget_scale, 0, c_white, 1);
            }

            var dial_x = bx + round(bar_w * val);

            if (spr_dial != -1) {
                draw_sprite_ext(spr_dial, 0, dial_x, by, widget_scale, widget_scale, 0, c_white, 1);
            }
        }

        if (item == "display_mode")
        {
            draw_set_halign(fa_center);
            draw_set_color(col_text);

            var mode_txt = global.display_mode_labels[global.display_mode_index];

            var tx = value_x + 70;
            var lx = tx - 48;
            var rx = tx + 48;

            if (spr_left != -1) draw_sprite_ext(spr_left, 0, lx, yy, widget_scale, widget_scale, 0, c_white, 1);
            draw_text(tx, yy, mode_txt);
            if (spr_right != -1) draw_sprite_ext(spr_right, 0, rx, yy, widget_scale, widget_scale, 0, c_white, 1);

            draw_set_halign(fa_left);
        }

        if (item == "resolution")
        {
            draw_set_halign(fa_center);
            draw_set_color(col_text);

            var res_txt = global.resolution_labels[global.resolution_index];

            var tx = value_x + 70;
            var lx = tx - 48;
            var rx = tx + 48;

            if (spr_left != -1) draw_sprite_ext(spr_left, 0, lx, yy, widget_scale, widget_scale, 0, c_white, 1);
            draw_text(tx, yy, res_txt);
            if (spr_right != -1) draw_sprite_ext(spr_right, 0, rx, yy, widget_scale, widget_scale, 0, c_white, 1);

            draw_set_halign(fa_left);
        }

        yy += gap;
    }

    draw_set_font(PIXELOPERATORREGULAR10);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(make_color_rgb(140, 150, 160));
    draw_text(gw - 12, gh - 10, "Left / Right = Change");
}

draw_set_font(PIXELOPERATORREGULAR10);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(140, 150, 160));
draw_text(12, gh - 10, "v1.0.0");

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);