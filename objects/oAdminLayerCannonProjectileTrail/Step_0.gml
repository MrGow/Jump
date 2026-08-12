/// oAdminLayerCannonProjectileTrail — Step


// ====================================================
// PAUSE / DEATH FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// LIFE
// ====================================================

life_timer--;

if (life_timer <= 0)
{
    instance_destroy();
    exit;
}