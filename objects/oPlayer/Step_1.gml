/// oPlayer — Begin Step

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}

// Stores previous feet for hazards before movement/collision changes bbox/vsp.
crusher_prev_feet_y = bbox_bottom;
crusher_prev_vsp    = vsp;