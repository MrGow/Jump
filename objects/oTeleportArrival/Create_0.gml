/// oTeleportArrival — Create


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "arrival_id"))
{
    arrival_id = "A";
}


// Optional fine adjustment.
if (!variable_instance_exists(id, "arrival_offset_x"))
{
    arrival_offset_x = 0;
}

if (!variable_instance_exists(id, "arrival_offset_y"))
{
    arrival_offset_y = 0;
}


// -1 = face left
//  1 = face right
//  0 = preserve whatever player already has
if (!variable_instance_exists(id, "arrival_facing"))
{
    arrival_facing = 1;
}


if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// Invisible during gameplay unless debugging.
visible =
    debug_draw;