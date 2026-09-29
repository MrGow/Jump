/// oGunShipStartTrigger — Draw

// Keep the trigger's sprite/mask for collision, but do not
// draw its artwork during normal gameplay.
if (!debug_draw)
{
    exit;
}

var debug_colour = c_lime;
var debug_label = "GUNSHIP START";

if (completed)
{
    debug_colour = c_yellow;
    debug_label = "GUNSHIP COMPLETE";
}
else if (activated)
{
    debug_colour = c_red;
    debug_label = "GUNSHIP ACTIVE";
}

draw_set_alpha(0.25);
draw_set_color(debug_colour);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);

draw_text(
    bbox_left,
    bbox_top - 14,
    debug_label
);