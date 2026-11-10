
/// oDeathMenu — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var cx = gw * 0.5;
var cy = gh * 0.5;


// ====================================================
// DARKEN BACKGROUND
// ====================================================

draw_set_alpha(0.6 * alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);


// ====================================================
// DEATH UI SPRITE
// ====================================================

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
    draw_set_color(c_white);
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
    draw_rectangle(
        px,
        py,
        px + panel_w,
        py + panel_h,
        false
    );
}


// ====================================================
// TEXT ALIGNMENT
// ====================================================

draw_set_alpha(alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// ====================================================
// SYSTEM FAILURE
// ====================================================

draw_set_font(PIXELOPERATORBOLD18);
draw_set_color(make_color_rgb(255, 80, 70));

draw_text(
    cx,
    py + 42,
    "SYSTEM FAILURE"
);


// ====================================================
// BLINKING REINITIALIZE
// Smaller font to provide more vertical space.
// ====================================================

var blink_on =
    ((current_time div 450) mod 2) == 0;

draw_set_font(PIXELOPERATORREGULAR10);

if (blink_on)
{
    draw_set_color(make_color_rgb(255, 220, 80));
}
else
{
    draw_set_color(make_color_rgb(180, 150, 60));
}

draw_text(
    cx,
    py + 64,
    "> REINITIALIZE?"
);


// ====================================================
// CONTINUE PROMPT — INSIDE DEATH PANEL
// ====================================================

var prompt_y = py + 80;

var prompt_gap = 6;
var prompt_scale = 0.75;
var prompt_text = "CONTINUE";

var prompt_icon_slot_w = 34;

draw_set_font(PIXELOPERATORREGULAR10);
draw_set_valign(fa_middle);

var prompt_text_w = string_width(prompt_text);

var prompt_total_w =
    prompt_icon_slot_w +
    prompt_gap +
    prompt_text_w;

var prompt_left =
    cx - prompt_total_w * 0.5;


// ----------------------------------------------------
// INPUT ICON
// ----------------------------------------------------

if (instance_exists(oInputPromptController))
{
    var ipc = instance_find(oInputPromptController, 0);

    if (ipc != noone)
    {
        var icon_x =
            prompt_left +
            prompt_icon_slot_w * 0.5;

        ipc.draw_prompt(
            "confirm",
            round(icon_x),
            round(prompt_y),
            prompt_scale,
            alpha
        );
    }
}


// ----------------------------------------------------
// CONTINUE TEXT
// ----------------------------------------------------

draw_set_halign(fa_left);

draw_set_color(make_color_rgb(140, 150, 160));
draw_set_alpha(alpha);

draw_text(
    round(
        prompt_left +
        prompt_icon_slot_w +
        prompt_gap
    ),
    round(prompt_y),
    prompt_text
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
