/// oGravityStripRed — Step

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var hit =
    (p.bbox_right  > bbox_left) &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom);

if (!hit) exit;

// Decide axis
var ax = affect_axis;

if (ax == 0)
{
    var a = ((round(image_angle) mod 360) + 360) mod 360;
    ax = (a == 90 || a == 270) ? 2 : 1;
}

// Apply slowdown
if (ax == 1 || ax == 3)
{
    p.hsp *= slow_mult;
    if (abs(p.hsp) < min_speed_cutoff) p.hsp = 0;
}

if (ax == 2 || ax == 3)
{
    p.vsp *= slow_mult;
    if (abs(p.vsp) < min_speed_cutoff) p.vsp = 0;
}