/// oHazardBox - Create
event_inherited();

// Rectangle hazard (top-left anchored)
if (!variable_instance_exists(id, "w")) w = 160;
if (!variable_instance_exists(id, "h")) h = 40;

// Visual
if (!variable_instance_exists(id, "color")) color = c_red;
if (!variable_instance_exists(id, "alpha")) alpha = 0.30;

