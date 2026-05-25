/// oDeathMenu — Create

// Safety: never exist unless the player actually died
if (!variable_global_exists("game_phase") || global.game_phase != "death_menu") {
    instance_destroy();
    exit;
}

alpha = 0;
fade_speed = 0.1;