/// oCreditsController — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

if (credit_index >= array_length(credits)) exit;

var total_card_time = fade_in_frames + hold_frames + fade_out_frames;

var alpha = 1;

if (timer < fade_in_frames)
{
    alpha = timer / fade_in_frames;
}
else if (timer > fade_in_frames + hold_frames)
{
    alpha = 1 - ((timer - fade_in_frames - hold_frames) / fade_out_frames);
}

alpha = clamp(alpha, 0, 1);

var title = credits[credit_index][0];
var name  = credits[credit_index][1];

draw_set_alpha(alpha);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Role
draw_set_font(PIXELOPERATORREGULAR10);
draw_set_color(make_color_rgb(150, 160, 170));
draw_text(gw * 0.5, gh * 0.5 - 36, title);

// Name
draw_set_font(PIXELOPERATORBOLD24);
draw_set_color(c_white);
draw_text(gw * 0.5, gh * 0.5 + 10, name);

// Reset
draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);