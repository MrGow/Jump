/// oSmasher — End Step

if (scr_game_frozen()) exit;

if (!enabled) exit;
if (!active)  exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

if (kill_only_when_falling)
{
    var pv = variable_instance_exists(p, "vsp") ? p.vsp : 0;
    if (pv < 0) exit;
}

// Horizontal overlap with crusher plate
var inset_x = 5;

var kill_l = bbox_left + inset_x;
var kill_r = bbox_right - inset_x;

var horiz_hit =
    (p.bbox_right > kill_l) &&
    (p.bbox_left  < kill_r);

if (!horiz_hit) exit;

// Plate underside
var plate_y = bbox_bottom;

// Player head
var head_y = p.bbox_top;

// This handles both:
// 1) actual overlap
// 2) player being stopped just below the plate by solid collision
var head_gap = head_y - plate_y;

var close_head_hit = (head_gap >= -12 && head_gap <= 6);

// Extra backup: normal bbox overlap
var overlap_hit =
    (p.bbox_right  > kill_l) &&
    (p.bbox_left   < kill_r) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom + 4);

if (!(close_head_hit || overlap_hit)) exit;

var sink = variable_instance_exists(id, "sink_px") ? sink_px : 6;
var lock_y = p.bbox_bottom + sink;



with (p)
{
    scr_player_died(lock_y, false, 18, 18);
}