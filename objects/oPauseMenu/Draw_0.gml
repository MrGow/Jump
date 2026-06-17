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

// UI sprite
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

// Header
draw_set_font(PIXELOPERATORBOLD14);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(230, 235, 235));

if (menu_mode == "settings") {
    draw_text(cx, py + 16, "SYSTEM SETTINGS");
} else {
    draw_text(cx, py + 16, "SYSTEM PAUSED");
}

// Terminal header
draw_set_font(PIXELOPERATORREGULAR10);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(make_color_rgb(165, 200, 165));

if (menu_mode == "settings") {
    draw_text(px + 52, py + 48, "jumpbot@factory:~$ settings");
} else {
    draw_text(px + 52, py + 48, "jumpbot@factory:~$ menu");
}

draw_set_color(make_color_rgb(90, 140, 90));
draw_line(px + 52, py + 63, px + panel_w - 58, py + 63);

// ----------------------------------------------------
// Main pause menu
// ----------------------------------------------------
if (menu_mode == "main")
{
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
// ----------------------------------------------------
// Settings menu
// ----------------------------------------------------
else if (menu_mode == "settings")
{
    var spr_left  = asset_get_index("spritePauseUILeftNavigator");
    var spr_right = asset_get_index("spritePauseUIRightNavigator");
    var spr_box   = asset_get_index("spritePauseUICheckbox");
    var spr_check = asset_get_index("spritePauseUICheck");
    var spr_bar   = asset_get_index("spritePauseUIEmptyDialBox");
    var spr_dial  = asset_get_index("spritePauseUIDial");

    draw_set_font(PIXELOPERATORBOLD14);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var label_x = px + 36;
    var value_x = px + 218;
    var yy = py + 70;
    var gap = 15;

    for (var i = 0; i < array_length(settings_items); i++)
    {
        var item = settings_items[i];
        var is_sel = (i == settings_index);

        var col_text = is_sel ? make_color_rgb(255, 220, 80) : make_color_rgb(200, 200, 200);

        draw_set_color(col_text);

        var label = item;
        label = string_replace_all(label, "_", " ");

        if (is_sel) {
            draw_text(label_x - 18, yy, ">");
        }

        draw_text(label_x, yy, label);

        // ------------------------------
        // Volume dials
        // ------------------------------
        if (item == "master_volume" || item == "music_volume" || item == "sfx_volume")
        {
            var vol = 1;

            if (item == "master_volume") vol = global.vol_master;
            if (item == "music_volume")  vol = global.vol_music;
            if (item == "sfx_volume")    vol = global.vol_sfx;

            var bx = value_x;
            var by = yy + 4;

            if (spr_bar != -1) {
                draw_sprite(spr_bar, 0, bx, by);
            } else {
                draw_set_color(make_color_rgb(80, 90, 95));
                draw_rectangle(bx, by, bx + 80, by + 6, false);
            }

            var bar_w = (spr_bar != -1) ? sprite_get_width(spr_bar) : 80;
            var dial_x = bx + round(bar_w * vol);

            if (spr_dial != -1) {
                draw_sprite(spr_dial, 0, dial_x, by - 2);
            } else {
                draw_set_color(make_color_rgb(255, 220, 80));
                draw_rectangle(dial_x - 2, by - 3, dial_x + 2, by + 9, false);
            }
        }

        // ------------------------------
        // Checkboxes
        // ------------------------------
        if (item == "fullscreen" || item == "screen_shake" || item == "button_prompts")
        {
            var enabled = false;

            if (item == "fullscreen")      enabled = global.fullscreen;
            if (item == "screen_shake")    enabled = global.screen_shake_enabled;
            if (item == "button_prompts")  enabled = global.button_prompts;

            var cbx = value_x + 44;
            var cby = yy + 1;

            if (spr_box != -1) {
                draw_sprite(spr_box, 0, cbx, cby);
            }

            if (enabled && spr_check != -1) {
                draw_sprite(spr_check, 0, cbx, cby);
            }
        }

        // ------------------------------
        // Resolution navigator
        // ------------------------------
        if (item == "resolution")
        {
            draw_set_halign(fa_center);
            draw_set_color(col_text);

            var res_txt = resolution_labels[global.resolution_index];

            if (spr_left != -1) {
                draw_sprite(spr_left, 0, value_x + 10, yy + 2);
            } else {
                draw_text(value_x + 10, yy, "<");
            }

            draw_text(value_x + 58, yy, res_txt);

            if (spr_right != -1) {
                draw_sprite(spr_right, 0, value_x + 105, yy + 2);
            } else {
                draw_text(value_x + 105, yy, ">");
            }

            draw_set_halign(fa_left);
        }

        yy += gap;
    }
}

// Reset draw state
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);