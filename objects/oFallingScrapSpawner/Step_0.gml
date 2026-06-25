/// oFallingScrapSpawner — Step

if (scr_game_frozen()) exit;

if (!enabled) exit;

spawn_timer--;

if (spawn_timer <= 0)
{
    var sx = x;
    if (randomize_x) {
        sx = x + random_range(-spawn_width * 0.5, spawn_width * 0.5);
    }

    var sy = y + spawn_y_offset;

    var inst = instance_create_layer(sx, sy, "Instances", oFallingScrap);

    inst.fall_speed = random_range(scrap_fall_speed_min, scrap_fall_speed_max);
    inst.hsp        = random_range(scrap_hsp_min, scrap_hsp_max);
    inst.life_timer = scrap_lifetime;

    spawn_timer = irandom_range(spawn_interval_min, spawn_interval_max);
}