
/// oScrapChiefSpitProjectile — Collision with oPlayer

if (scr_game_frozen())
{
    exit;
}

if (!initialized || !dangerous)
{
    exit;
}

with (other)
{
    scr_player_died();
}
