/// oFlames - Step

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

// Don't re-kill if already dead
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// Build inset kill rectangle
var kleft   = bbox_left   + kill_inset_x;
var kright  = bbox_right  - kill_inset_x;
var ktop    = bbox_top    + kill_inset_top;
var kbottom = bbox_bottom - kill_inset_bottom;

// Safety (if someone sets huge insets)
if (kright <= kleft)   { var cx = (bbox_left + bbox_right) * 0.5; kleft = cx; kright = cx + 1; }
if (kbottom <= ktop)   { var cy = (bbox_top + bbox_bottom) * 0.5; ktop = cy; kbottom = cy + 1; }

// Player/flame overlap against inset zone
var hit =
    (p.bbox_right  > kleft)  &&
    (p.bbox_left   < kright) &&
    (p.bbox_bottom > ktop)   &&
    (p.bbox_top    < kbottom);

if (!hit) exit;

// Kill player (supports either script-based or direct state kill)
if (script_exists(scr_player_died)) {
    with (p) scr_player_died();
} else {
    with (p) {
        if (variable_instance_exists(id, "state")) state = "dead";
    }
}