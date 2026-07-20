/// oDeathExplosion — Step

// The explosion must keep animating while the world is
// in death_delay.

var freeze_explosion = false;

if (variable_global_exists("game_phase"))
{
    freeze_explosion =
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu";
}

if (freeze_explosion)
{
    image_speed = 0;
    exit;
}

image_speed = 0.6;