
/// oFirstSpawnSparks — Create

depth = -1600;
visible = true;

// ====================================================
// TIMING
// ====================================================

start_delay = round(room_speed * 1.0);
effect_duration = round(room_speed * 5.0);

delay_timer = 0;
effect_timer = 0;

effect_started = false;
sequence_detected = false;

// ====================================================
// PLAYER
// ====================================================

player_ref = noone;

// ====================================================
// SPARK SETTINGS
// ====================================================

// Number of sparks that can exist simultaneously.
max_sparks = 12;

// Chance of generating a spark each frame.
// Lower values produce more intermittent faults.
spark_chance = 0.24;

// Lifetime in frames.
spark_life_min = 3;
spark_life_max = 8;

// Pixel dimensions.
spark_length_min = 3;
spark_length_max = 9;

// Player-relative emission area.
spark_radius_x = 10;
spark_radius_y = 10;

// Draw offset to match oPlayer's custom Draw event.
player_draw_y_offset = 9;

// ====================================================
// COLOURS
// ====================================================

spark_yellow = make_color_rgb(255, 223, 76);
spark_bright = make_color_rgb(255, 248, 166);
spark_orange = make_color_rgb(255, 165, 49);

// ====================================================
// PARTICLES
// ====================================================

sparks = [];
