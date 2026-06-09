/// oFallingScrapSpawner — Create

enabled = true;

// Spawn timing
spawn_interval_min = room_speed * 0.6;
spawn_interval_max = room_speed * 1.4;
spawn_timer = irandom_range(spawn_interval_min, spawn_interval_max);

// Spawn area
spawn_width = 160;
spawn_y_offset = -64;

// Falling scrap tuning
scrap_fall_speed_min = 3.5;
scrap_fall_speed_max = 6.0;
scrap_lifetime       = room_speed * 4;

// Optional horizontal drift
scrap_hsp_min = -0.3;
scrap_hsp_max = 0.3;

// If true, scrap spawns around the spawner x position
randomize_x = true;

// Debug
debug_draw = false;