/// oChipCounterPopup — Draw GUI

if (global.chips_carried <= 0) exit;

var gw = display_get_gui_width();

draw_set_font(PIXELOPERATORBOLD14);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

var spr_chip = asset_get_index("spriteComputerChip");

var txt = "DATA CHIP x" + string(global.chips_carried);

var text_x = gw - 24;
var text_y = 18;

var chip_scale = 0.55;
var chip_gap   = 7;

var tw = string_width(txt);
var th = string_height(txt);

// Since sprite origin is middle-centre, put its origin at text vertical centre
var chip_x = text_x - tw - chip_gap;
var chip_y = text_y + round(th * 0.5);

draw_set_alpha(alpha);

// Chip shadow
if (spr_chip != -1) {
    draw_sprite_ext(
        spr_chip,
        0,
        chip_x + 1,
        chip_y + 1,
        chip_scale,
        chip_scale,
        0,
        c_black,
        alpha * 0.55
    );
}

// Chip sprite
if (spr_chip != -1) {
    draw_sprite_ext(
        spr_chip,
        0,
        chip_x,
        chip_y,
        chip_scale,
        chip_scale,
        0,
        c_white,
        alpha
    );
}

// Text shadow
draw_set_color(c_black);
draw_text(text_x + 1, text_y + 1, txt);

// Main text
draw_set_color(make_color_rgb(130, 220, 255));
draw_text(text_x, text_y, txt);

// Reset
draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);