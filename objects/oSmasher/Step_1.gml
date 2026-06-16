/// oSmasher — Begin Step

if (!enabled) exit;

x = base_x;
y = base_y;

// ----------------------------------------------------
// Manual animation with raised-position pause
// ----------------------------------------------------
if (smasher_pause_timer > 0)
{
    smasher_pause_timer--;

    image_speed = 0;
    image_index = 0;
}
else
{
    image_speed = 0;
    image_index += smasher_anim_speed;

    if (image_index >= image_number - 1)
    {
        image_index = 0;

        if (smasher_pause_frames > 0)
        {
            smasher_pause_timer = smasher_pause_frames;
        }
    }
}

// ----------------------------------------------------
// Active window before player collision
// ----------------------------------------------------
if (use_active_frames)
{
    var fr = floor(image_index);
    active = (fr >= active_from && fr <= active_to);
}
else
{
    active = true;
}

// Up frames = body only
// Down frames = full mask
mask_index = active ? mask_full : mask_body;