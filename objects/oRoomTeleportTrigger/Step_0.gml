/// oRoomTeleportTrigger — Step

if (!enabled) exit;
if (!armed) exit;

if (variable_global_exists("room_teleport_active") && global.room_teleport_active) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var hit =
    (p.bbox_right  > bbox_left) &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom);

if (hit)
{
    armed = false;

    var c = instance_create_layer(0, 0, "Instances", oRoomTeleportController);
    c.target_room  = target_room;
    c.target_spawn = target_spawn;
}