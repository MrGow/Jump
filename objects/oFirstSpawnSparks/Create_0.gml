
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

// Matches the existing player drawing offset.
player_draw_y_offset = 9;

// Additional adjustment to centre emission.
spark_y_adjust = -5;

// ====================================================
// PARTICLE SETTINGS
// ====================================================

max_sparks = 24;

// Chance of starting a burst each frame.
spark_chance = 0.13;

// Number of particles in each burst.
burst_min = 2;
burst_max = 5;

// Particle lifetime in frames.
spark_life_min = 8;
spark_life_max = 17;

// Initial outward speed in pixels/frame.
spark_speed_min = 0.9;
spark_speed_max = 2.3;

// Gravity and horizontal drag.
spark_gravity = 0.055;
spark_drag = 0.985;

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
