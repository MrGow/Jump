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

// --- Global phase / meta state ---
if (!variable_global_exists("game_phase")) global.game_phase = "playing";

// Camera shake globals
if (!variable_global_exists("shake_mag"))  global.shake_mag  = 0;
if (!variable_global_exists("shake_time")) global.shake_time = 0;
if (!variable_global_exists("death_shake_strength")) global.death_shake_strength = 10;
if (!variable_global_exists("death_shake_frames"))   global.death_shake_frames   = 14;