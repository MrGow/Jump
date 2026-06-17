/// oHighGravityZone — Step

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var overlap =
    (p.bbox_right  > bbox_left) &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom);

if (!overlap) exit;

p.in_high_gravity_zone = true;
p.high_grav_mult_zone = high_grav_mult;
p.high_fall_mult_zone = high_fall_mult;