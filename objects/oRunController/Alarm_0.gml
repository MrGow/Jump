/// oRunController — Alarm 0

if (!instance_exists(oPlayer)) {
    is_resetting = false;
    exit;
}

// Reset the single player instance
with (oPlayer) {
    // Move back to spawn
    x = other.spawn_x;
    y = other.spawn_y;

    // Reset movement
    hsp = 0;
    vsp = 0;

    // Revive
    state = "alive";
    hp    = max_hp;

    sprite_index = spriteBotIdle;
    image_index  = 0;
    image_speed  = 0.2;
    image_xscale = facing;
}

is_resetting = false;
