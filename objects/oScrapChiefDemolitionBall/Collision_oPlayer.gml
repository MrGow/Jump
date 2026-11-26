/// oScrapChiefDemolitionBall — Collision with oPlayer

// ====================================================
// SAFETY
// ====================================================

if (scr_game_frozen())
{
    exit;
}

if (!active || !visible || !dangerous)
{
    exit;
}


// ====================================================
// CRUSH PLAYER
// ====================================================

with (other)
{
    scr_player_died(
        undefined,
        false,
        undefined,
        undefined,
        "crush",
        false
    );
}