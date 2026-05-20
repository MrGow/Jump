/// oGravityStripGreen — Step


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

// Apply speed boost
if (ax == 1 || ax == 3)
{
    if (abs(p.hsp) > 0.05)
    {
        p.hsp = (p.hsp * boost_mult) + (sign(p.hsp) * boost_add);
        p.hsp = clamp(p.hsp, -max_hsp, max_hsp);
    }
}

if (ax == 2 || ax == 3)
{
    if (abs(p.vsp) > 0.05)
    {
        p.vsp = (p.vsp * boost_mult) + (sign(p.vsp) * boost_add);
        p.vsp = clamp(p.vsp, -max_vsp, max_vsp);
    }
}