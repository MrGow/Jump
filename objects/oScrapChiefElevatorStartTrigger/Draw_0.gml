/// oScrapChiefElevatorStartTrigger — Draw

// ====================================================
// DEBUG DRAW
//
// Uses the actual sprite collision bounds.
// The trigger sprite itself stays invisible
// unless debug drawing is enabled.
// ====================================================

if (!debug_draw)
{
    exit;
}


// ====================================================
// TRIGGER RECTANGLE
// ====================================================

var left   = bbox_left;
var right  = bbox_right;
var top    = bbox_top;
var bottom = bbox_bottom;


// ====================================================
// DRAW DEBUG RECTANGLE
// ====================================================

draw_set_alpha(0.25);

draw_set_color(
    activated ? c_lime : c_yellow
);

draw_rectangle(
    left,
    top,
    right,
    bottom,
    false
);


// ====================================================
// RESET DRAW SETTINGS
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);