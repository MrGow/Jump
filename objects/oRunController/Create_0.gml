/// oRunController — Create

// Per-run controller, not persistent per game.
// Put one in each room that has gameplay.

is_resetting   = false;
respawn_delay  = room_speed * 0.75; // delay before respawn (0.75s)


// --- Get tilemap for Solids layer ---
if (layer_exists("Solids")) {
    global.solid_tm = layer_tilemap_get_id("Solids");
} else {
    global.solid_tm = undefined;
}

// Decide initial spawn point from the first oPlayer we find
if (instance_exists(oPlayer)) {
    var p = instance_find(oPlayer, 0);
    spawn_x = p.x;
    spawn_y = p.y;
} else {
    // Fallback: use the controller's own position
    spawn_x = x;
    spawn_y = y;
}
