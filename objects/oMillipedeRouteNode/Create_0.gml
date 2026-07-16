/// oMillipedeRouteNode — Create

depth = -30000;

// ----------------------------------------------------
// Editor-variable safety
// ----------------------------------------------------
if (!variable_instance_exists(id, "route_id"))
{
    route_id = 0;
}

if (!variable_instance_exists(id, "node_order"))
{
    node_order = 0;
}

// ----------------------------------------------------
// Surface orientation for the route section that begins
// at this node.
//
// 0 = floor
// 1 = right wall
// 2 = ceiling
// 3 = left wall
// ----------------------------------------------------
if (!variable_instance_exists(id, "surface_rotation"))
{
    surface_rotation = 0;
}

surface_rotation =
    ((round(surface_rotation) mod 4) + 4) mod 4;

// ----------------------------------------------------
// Debug
// ----------------------------------------------------
debug_draw = false;
visible    = true;