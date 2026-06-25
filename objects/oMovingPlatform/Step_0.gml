/// oMovingPlatform — Step

if (scr_game_frozen())
{
    dx = 0;
    dy = 0;
    image_speed = 0;
    exit;
}

if (!enabled) exit;

active = true;
solid_body = true;