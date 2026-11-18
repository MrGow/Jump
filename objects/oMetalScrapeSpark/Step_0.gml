/// oMetalScrapeSpark — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}

// ====================================================
// INITIAL VELOCITY
// ====================================================

// The player assigns the horizontal velocity after
// the Create event. Boost it once on the first Step.

if (spark_first_step)
{
    spark_first_step = false;

    spark_vx *= random_range(1.25, 1.65);
}

// ====================================================
// MOVEMENT
// ====================================================

x += spark_vx;
y += spark_vy;

// Gentle horizontal deceleration.
spark_vx *= 0.94;

// Very slight gravity.
spark_vy += spark_gravity;

// ====================================================
// LIFETIME
// ====================================================

spark_life--;

if (spark_life <= 0)
{
    instance_destroy();
}