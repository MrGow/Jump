/// oRoomTeleportTrigger — Create

if (!variable_instance_exists(id, "target_room"))  target_room  = noone;
if (!variable_instance_exists(id, "target_spawn")) target_spawn = "";

if (!variable_instance_exists(id, "area_name")) area_name = "";
if (!variable_instance_exists(id, "show_area_name")) show_area_name = false;

if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;
if (!variable_instance_exists(id, "enabled")) enabled = true;

armed = true;