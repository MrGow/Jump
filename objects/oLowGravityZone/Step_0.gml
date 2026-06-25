/// oLowGravityZone — Step

if (scr_game_frozen()) exit;

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

// Tell player it is inside low gravity this frame
p.in_low_gravity_zone = true;
p.low_grav_mult_zone = low_grav_mult;
p.low_fall_mult_zone = low_fall_mult;