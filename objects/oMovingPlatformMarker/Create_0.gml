/// oMovingPlatformMarker — Create

// Link ID used by one platform to find this marker
if (!variable_instance_exists(id, "move_id")) move_id = 0;

// Optional editor-only visuals
if (!variable_instance_exists(id, "debug_size")) debug_size = 10;
if (!variable_instance_exists(id, "debug_color")) debug_color = c_aqua;