/// oRunController — Alarm 0

if (!instance_exists(oPlayer)) {
    is_resetting = false;
    exit;
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
}

is_resetting = false;


// ----------------------------------------------------
// 🔥 RESET CAMERA LOCK
// ----------------------------------------------------
global.cam_death_lock_active = false;
