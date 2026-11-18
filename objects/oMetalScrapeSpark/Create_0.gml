/// oMetalScrapeSpark — Create

// ====================================================
// MOVEMENT
// ====================================================

// Horizontal velocity is assigned by the player
// when the spark is created.
spark_vx = 0;

// Keep sparks close to the ground.
spark_vy = random_range(-0.65, -0.10);

spark_gravity = 0.08;

// ====================================================
// LIFETIME
// ====================================================

spark_life = irandom_range(5, 10);
spark_life_max = spark_life;

// ====================================================
// APPEARANCE
// ====================================================

var _roll = random(1);

if (_roll < 0.70)
{
    // Yellow streaks — 70%
    spark_colour = make_colour_rgb(255, 220, 65);
    spark_size = irandom_range(2, 4);
}
else if (_roll < 0.90)
{
    // Small orange sparks — 20%
    spark_colour = make_colour_rgb(255, 165, 35);
    spark_size = irandom_range(1, 2);
}
else
{
    // Bright white-yellow sparks — 10%
    spark_colour = make_colour_rgb(255, 250, 195);
    spark_size = irandom_range(2, 3);
}

// ====================================================
// INTERNAL
// ====================================================

spark_first_step = true;