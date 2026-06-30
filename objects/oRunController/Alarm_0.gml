/// oRunController — Alarm 0

if (!instance_exists(oPlayer)) {
    is_resetting = false;
    exit;
}

// Prefer active checkpoint if it belongs to this room
if (variable_global_exists("checkpoint_set") &&
    global.checkpoint_set &&
    variable_global_exists("checkpoint_room") &&
    global.checkpoint_room == room)
{
    spawn_x = global.checkpoint_x;
    spawn_y = global.checkpoint_y;
}

// Reset player
with (oPlayer) {
    x = other.spawn_x;
    y = other.spawn_y;

    hsp = 0;
    vsp = 0;

    state = "idle";

    if (variable_instance_exists(id, "death_fall")) death_fall = false;

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
}

// Lose carried, unbanked chips on death/respawn
if (variable_global_exists("chips_carried")) {
    global.chips_carried = 0;
}

if (variable_global_exists("chips_carried_ids")) {
    ds_map_clear(global.chips_carried_ids);
}

is_resetting = false;

// Reset camera lock
global.cam_death_lock_active = false;