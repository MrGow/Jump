/// oElectricCable — End Step

if (scr_game_frozen()) exit;

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (!variable_instance_exists(p, "electric_hit_lock")) p.electric_hit_lock = 0;

if (p.electric_hit_lock > 0) {
    p.electric_hit_lock--;
    exit;
}

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var rr = get_hurt_rect();

var l = rr[0];
var t = rr[1];
var r = rr[2];
var b = rr[3];

var hit =
    (p.bbox_right  > l) &&
    (p.bbox_left   < r) &&
    (p.bbox_bottom > t) &&
    (p.bbox_top    < b);

if (!hit) exit;

with (p)
{
    if (state == "dead") exit;
    scr_player_died();
    electric_hit_lock = other.player_hit_lock_frames;
}