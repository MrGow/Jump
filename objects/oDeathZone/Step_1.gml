/// oDeathZone — Begin Step

if (!enabled) exit;

update_rect();

// Find player
var p = instance_find(oPlayer, 0);
if (p == noone) exit;

// Don't retrigger if already dead
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// Basic bbox overlap test
var overlap =
    (p.bbox_right  > left)  &&
    (p.bbox_left   < right) &&
    (p.bbox_bottom > top)   &&
    (p.bbox_top    < bottom);

if (overlap)
{
    with (p) {
        // Freeze-in-place death instead of fall death
        scr_player_died();
        // or: scr_player_died(undefined, false);
    }
}