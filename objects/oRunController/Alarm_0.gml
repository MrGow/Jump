/// oRunController — Alarm 0

if (!instance_exists(oPlayer)) {
    is_resetting = false;
    exit;
}

// Reset the single player instance
with (oPlayer) {
    x = other.spawn_x;
    y = other.spawn_y;

    hsp = 0;
    vsp = 0;

    // IMPORTANT: go back to your normal state machine
    state = "idle";

    // HP
    if (!variable_instance_exists(id, "max_hp")) max_hp = 1;
    if (!variable_instance_exists(id, "hp"))     hp = max_hp;
    hp = max_hp;

    sprite_index = spriteBotIdle;
    image_index  = 0;
    image_speed  = 0.2;
    image_xscale = facing;
}

is_resetting = false;
