/// oGunShipArenaTrigger — Draw GUI

if (!completed || scr_game_frozen())
{
    exit;
}

var p = instance_find(oPlayer, 0);

if (!instance_exists(p) || p.state == "dead")
{
    exit;
}

if (p.x > arena_camera_x + scan_width + 80)
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

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var ax = round(gw - 65);
var ay = round(gh * 0.49);

var text_x = ax - 6;
var text_y = ay + 20;

var pulse =
    0.55
    +
    0.45 * abs(sin(go_flash));

var gold = make_color_rgb(255, 210, 45);
var dark_gold = make_color_rgb(175, 105, 20);
var shadow_colour = make_color_rgb(5, 8, 12);


// ====================================================
// ARROW DRAW HELPER
// ====================================================

var draw_arena_go_shape = function(_x, _y)
{
    draw_rectangle(
        _x - 23,
        _y - 6,
        _x,
        _y + 6,
        false
    );

    draw_triangle(
        _x,
        _y - 13,
        _x,
        _y + 13,
        _x + 19,
        _y,
        false
    );
};


// ====================================================
// ARROW SHADOW
// ====================================================

draw_set_alpha(1);
draw_set_color(shadow_colour);

draw_arena_go_shape(ax + 2, ay + 2);


// ====================================================
// ARROW BLACK OUTLINE
// ====================================================

draw_set_color(c_black);

for (var ox = -1; ox <= 1; ox++)
{
    for (var oy = -1; oy <= 1; oy++)
    {
        if (ox == 0 && oy == 0)
        {
            continue;
        }

        draw_arena_go_shape(ax + ox, ay + oy);
    }
}


// ====================================================
// ARROW GOLD FILL
// ====================================================

draw_set_alpha(1);
draw_set_color(dark_gold);

draw_arena_go_shape(ax, ay);

draw_set_alpha(pulse);
draw_set_color(gold);

draw_arena_go_shape(ax, ay);


// ====================================================
// GO TEXT
// ====================================================

draw_set_font(PIXELOPERATORBOLD18);
draw_set_halign(fa_center);
draw_set_valign(fa_top);


// ----------------------------------------------------
// Shadow
// ----------------------------------------------------

draw_set_alpha(1);
draw_set_color(shadow_colour);

draw_text(
    text_x + 2,
    text_y + 2,
    "GO!"
);


// ----------------------------------------------------
// Black outline
// ----------------------------------------------------

draw_set_color(c_black);

for (var tx = -1; tx <= 1; tx++)
{
    for (var ty = -1; ty <= 1; ty++)
    {
        if (tx == 0 && ty == 0)
        {
            continue;
        }

        draw_text(
            text_x + tx,
            text_y + ty,
            "GO!"
        );
    }
}


// ----------------------------------------------------
// Gold fill
// ----------------------------------------------------

draw_set_alpha(1);
draw_set_color(dark_gold);

draw_text(text_x, text_y, "GO!");

draw_set_alpha(pulse);
draw_set_color(gold);

draw_text(text_x, text_y, "GO!");


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_font(previous_font);
draw_set_halign(previous_halign);
draw_set_valign(previous_valign);
draw_set_color(previous_colour);
draw_set_alpha(previous_alpha);