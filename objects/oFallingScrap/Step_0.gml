/// oFallingScrap — Step

if (!enabled) exit;

x += hsp;
y += fall_speed;
image_angle += spin_speed;

life_timer--;
if (life_timer <= 0)
{
    instance_destroy();
    exit;
}

// Kill player on touch
var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var l = bbox_left   + kill_inset_x;
var r = bbox_right  - kill_inset_x;
var t = bbox_top    + kill_inset_y;
var b = bbox_bottom - kill_inset_y;

var hit =
    (p.bbox_right  > l) &&
    (p.bbox_left   < r) &&
    (p.bbox_bottom > t) &&
    (p.bbox_top    < b);

if (hit)
{
    with (p)
    {
        scr_player_died();
    }

    instance_destroy();
}