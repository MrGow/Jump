/// oRunController — Create

is_resetting   = false;
respawn_delay  = room_speed * 0.75; // delay before respawn (0.75s)

// --- Get tilemap for Solids layer ---
global.solid_tm = undefined;
if (layer_exists("Solids")) {
    var lid = layer_get_id("Solids");
    if (lid != -1) global.solid_tm = layer_tilemap_get_id(lid);
}

// Decide initial spawn point from the first oPlayer we find
if (instance_exists(oPlayer)) {
    var p = instance_find(oPlayer, 0);
    spawn_x = p.x;
    spawn_y = p.y;
} else {
    spawn_x = x;
    spawn_y = y;
}
