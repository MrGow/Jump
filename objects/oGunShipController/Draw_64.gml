/// oGunShipController — Draw GUI

if (!active || !instance_exists(ship))
{
    exit;
}


// ====================================================
// SAVE DRAW STATE
// ====================================================

var previous_font = draw_get_font();
var previous_halign = draw_get_halign();
var previous_valign = draw_get_valign();
var previous_colour = draw_get_color();
var previous_alpha = draw_get_alpha();


// ====================================================
// POSITION / COLOURS
// ====================================================

var bar_w = 240;
var bar_h = 12;

// Slightly lower to give the name room above it.
var bar_x = round(
    (display_get_gui_width() - bar_w) * 0.5
);

var bar_y = 28;

var name_x = round(bar_x + bar_w * 0.5);
var name_y = bar_y - 5;

var frame_col = make_color_rgb(12, 18, 28);
var empty_col = make_color_rgb(43, 49, 62);
var fill_col = make_color_rgb(238, 69, 49);
var edge_col = make_color_rgb(255, 161, 72);
var name_col = make_color_rgb(225, 235, 240);
var shadow_col = make_color_rgb(5, 8, 12);


// ====================================================
// BOSS NAME
// ====================================================

draw_set_font(PIXELOPERATORBOLD14);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_alpha(1);


// ----------------------------------------------------
// Shadow
// ----------------------------------------------------

draw_set_color(shadow_col);

draw_text(
    name_x + 2,
    name_y + 2,
    "GUNSHIP"
);


// ----------------------------------------------------
// Black outline
// ----------------------------------------------------

draw_set_color(c_black);

for (var ox = -1; ox <= 1; ox++)
{
    for (var oy = -1; oy <= 1; oy++)
    {
        if (ox == 0 && oy == 0)
        {
            continue;
        }

        draw_text(
            name_x + ox,
            name_y + oy,
            "GUNSHIP"
        );
    }
}


// ----------------------------------------------------
// Main lettering
// ----------------------------------------------------

draw_set_color(name_col);
draw_text(name_x, name_y, "GUNSHIP");


// ====================================================
// BAR SHADOW
// ====================================================

draw_set_color(shadow_col);

draw_rectangle(
    bar_x - 3 + 2,
    bar_y - 3 + 2,
    bar_x + bar_w + 3 + 2,
    bar_y + bar_h + 3 + 2,
    false
);


// ====================================================
// BAR FRAME
// ====================================================

draw_set_color(c_black);

draw_rectangle(
    bar_x - 4,
    bar_y - 4,
    bar_x + bar_w + 4,
    bar_y + bar_h + 4,
    false
);

draw_set_color(frame_col);

draw_rectangle(
    bar_x - 3,
    bar_y - 3,
    bar_x + bar_w + 3,
    bar_y + bar_h + 3,
    false
);


// ====================================================
// EMPTY BAR
// ====================================================

draw_set_color(empty_col);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    false
);


// ====================================================
// HP FILL
// ====================================================

var hp_fraction = clamp(
    hp / max(1, max_hp),
    0,
    1
);

if (hp_fraction > 0)
{
    draw_set_color(fill_col);

    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + bar_w * hp_fraction,
        bar_y + bar_h,
        false
    );
}


// ====================================================
// HP QUARTERS
// ====================================================

draw_set_color(frame_col);

for (var i = 1; i < max_hp; i++)
{
    var divider_x = round(
        bar_x + bar_w * i / max_hp
    );

    draw_rectangle(
        divider_x - 1,
        bar_y,
        divider_x + 1,
        bar_y + bar_h,
        false
    );
}


// ====================================================
// ORANGE EDGE
// ====================================================

draw_set_color(edge_col);

draw_rectangle(
    bar_x - 1,
    bar_y - 1,
    bar_x + bar_w + 1,
    bar_y + bar_h + 1,
    true
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_font(previous_font);
draw_set_halign(previous_halign);
draw_set_valign(previous_valign);
draw_set_color(previous_colour);
draw_set_alpha(previous_alpha);