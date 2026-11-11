/// oSmasher — Step

if (scr_game_frozen())
{
    image_speed = 0;
    x = base_x;
    y = base_y;
    exit;
}

if (!enabled) exit;

x = base_x;
y = base_y;

// Begin Step controls mask_body versus mask_full.
// Do not change mask_index here.