/// oChipBankPopup — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var cx = round(gw * 0.5);
var cy = round(gh * 0.5);

draw_set_alpha(alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Slight screen dim
draw_set_color(c_black);
draw_set_alpha(alpha * 0.28);
draw_rectangle(0, 0, gw, gh, false);

draw_set_alpha(alpha);

// Text
var title_txt = "DATA CHIP";
var count_txt =
    string(display_count)
    + " / "
    + string(global.chips_total);

var pop = 1;

if (number_pop_timer > 0) {
    pop = 1 + (number_pop_timer / 14) * 0.22;
}

var main_scale = scale * pop;

// Title
draw_set_font(PIXELOPERATORBOLD14);

draw_set_color(c_black);
draw_text_transformed(
    cx + 1,
    cy - 31,
    title_txt,
    scale,
    scale,
    0
);

draw_set_color(make_color_rgb(200, 200, 200));
draw_text_transformed(
    cx,
    cy - 32,
    title_txt,
    scale,
    scale,
    0
);

// Count
draw_set_font(PIXELOPERATORBOLD18);

draw_set_color(c_black);
draw_text_transformed(
    cx + 2,
    cy + 4,
    count_txt,
    main_scale * 1.45,
    main_scale * 1.45,
    0
);

draw_set_color(make_color_rgb(130, 220, 255));
draw_text_transformed(
    cx,
    cy + 2,
    count_txt,
    main_scale * 1.45,
    main_scale * 1.45,
    0
);

// Small subtitle
draw_set_font(PIXELOPERATORREGULAR10);

draw_set_color(c_black);
draw_text(
    cx + 1,
    cy + 55,
    "uploaded to checkpoint"
);

draw_set_color(make_color_rgb(180, 200, 210));
draw_text(
    cx,
    cy + 54,
    "uploaded to checkpoint"
);

// Reset
draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);