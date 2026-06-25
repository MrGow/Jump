/// oRunController — Create

is_resetting   = false;
respawn_delay  = room_speed * 0.75;

// Death flow
death_delay_frames = room_speed * 0.6;
death_delay_timer  = 0;

// --- Get tilemap for Solids layer ---
global.solid_tm = undefined;
if (layer_exists("Solids")) {
    var lid = layer_get_id("Solids");
    if (lid != -1) global.solid_tm = layer_tilemap_get_id(lid);
}

if (instance_exists(oPlayer)) {
    var p = instance_find(oPlayer, 0);
    spawn_x = p.x;
    spawn_y = p.y;
} else {
    spawn_x = x;
    spawn_y = y;
}

if (!variable_global_exists("game_phase")) global.game_phase = "playing";

if (!variable_global_exists("shake_mag"))  global.shake_mag  = 0;
if (!variable_global_exists("shake_time")) global.shake_time = 0;
if (!variable_global_exists("death_shake_strength")) global.death_shake_strength = 10;
if (!variable_global_exists("death_shake_frames"))   global.death_shake_frames   = 14;

if (!variable_global_exists("checkpoint_set"))  global.checkpoint_set  = false;
if (!variable_global_exists("checkpoint_room")) global.checkpoint_room = -1;
if (!variable_global_exists("checkpoint_x"))    global.checkpoint_x    = spawn_x;
if (!variable_global_exists("checkpoint_y"))    global.checkpoint_y    = spawn_y;
if (!variable_global_exists("checkpoint_id"))   global.checkpoint_id   = "";

if (!variable_global_exists("pending_respawn"))      global.pending_respawn      = false;
if (!variable_global_exists("pending_respawn_room")) global.pending_respawn_room = -1;
if (!variable_global_exists("pending_respawn_x"))    global.pending_respawn_x    = 0;
if (!variable_global_exists("pending_respawn_y"))    global.pending_respawn_y    = 0;

if (!global.checkpoint_set) {
    global.checkpoint_set  = true;
    global.checkpoint_room = room;
    global.checkpoint_x    = spawn_x;
    global.checkpoint_y    = spawn_y;
    global.checkpoint_id   = "__default_room_spawn__";
}

if (global.checkpoint_set && global.checkpoint_room == room) {
    spawn_x = global.checkpoint_x;
    spawn_y = global.checkpoint_y;
}