/// oRunController — Room Start

// ----------------------------------------------------
// Safety
// ----------------------------------------------------
if (!variable_global_exists("checkpoint_set"))  global.checkpoint_set  = false;
if (!variable_global_exists("checkpoint_room")) global.checkpoint_room = -1;
if (!variable_global_exists("checkpoint_x"))    global.checkpoint_x    = 0;
if (!variable_global_exists("checkpoint_y"))    global.checkpoint_y    = 0;

if (!variable_global_exists("pending_respawn"))      global.pending_respawn      = false;
if (!variable_global_exists("pending_respawn_room")) global.pending_respawn_room = -1;
if (!variable_global_exists("pending_respawn_x"))    global.pending_respawn_x    = 0;
if (!variable_global_exists("pending_respawn_y"))    global.pending_respawn_y    = 0;

// Chip safety
if (!variable_global_exists("chips_carried")) {
    global.chips_carried = 0;
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}

// ----------------------------------------------------
// If active checkpoint belongs to this room, use it
// ----------------------------------------------------
if (global.checkpoint_set && global.checkpoint_room == room) {
    spawn_x = global.checkpoint_x;
    spawn_y = global.checkpoint_y;
}

// ----------------------------------------------------
// Cross-room respawn
// ----------------------------------------------------
if (global.pending_respawn && global.pending_respawn_room == room)
{
    spawn_x = global.pending_respawn_x;
    spawn_y = global.pending_respawn_y;

    if (instance_exists(oPlayer)) {
        with (oPlayer) {
            x = other.spawn_x;
            y = other.spawn_y;

            if (!variable_instance_exists(id, "hsp")) hsp = 0;
            if (!variable_instance_exists(id, "vsp")) vsp = 0;
            hsp = 0;
            vsp = 0;

            state = "idle";

            if (variable_instance_exists(id, "death_fall")) death_fall = false;
            if (variable_instance_exists(id, "death_cam_lock_x")) death_cam_lock_x = x;
            if (variable_instance_exists(id, "death_cam_lock_y")) death_cam_lock_y = y;

            if (!variable_instance_exists(id, "max_hp")) max_hp = 1;
            if (!variable_instance_exists(id, "hp"))     hp = max_hp;
            hp = max_hp;

            sprite_index = spriteBotIdle;
            image_index  = 0;
            image_speed  = 0.2;
            image_xscale = facing;

            if (variable_instance_exists(id, "jump_charging"))     jump_charging = false;
            if (variable_instance_exists(id, "jump_charge"))       jump_charge = 0;
            if (variable_instance_exists(id, "jump_charge_level")) jump_charge_level = 0;
            if (variable_instance_exists(id, "bounce_pending"))    bounce_pending = false;
            if (variable_instance_exists(id, "bounce_timer"))      bounce_timer = 0;
            if (variable_instance_exists(id, "standing_platform")) standing_platform = noone;
            if (variable_instance_exists(id, "coyote_timer"))      coyote_timer = 0;

            if (variable_instance_exists(id, "prev_jump_h"))        prev_jump_h = true;
            if (variable_instance_exists(id, "respawn_input_lock")) respawn_input_lock = 8;
        }
    }

    // ----------------------------------------------------
    // Lose any carried (unbanked) chips on death
    // ----------------------------------------------------
    global.chips_carried = 0;
    ds_map_clear(global.chips_carried_ids);

    // ----------------------------------------------------
    // Finish respawn
    // ----------------------------------------------------
    global.pending_respawn      = false;
    global.pending_respawn_room = -1;
    global.pending_respawn_x    = 0;
    global.pending_respawn_y    = 0;

    global.inp_jump_press = false;
    global.game_phase = "playing";
}