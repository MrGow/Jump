/// oB1LL — Animation End

// ====================================================
// STRETCH COMPLETE
// ====================================================

if (b1ll_state == "stretching")
{
    b1ll_state =
        "idle";

    if (spr_idle != -1)
    {
        sprite_index =
            spr_idle;

        image_index = 0;
        image_speed = 1;
    }

    reset_stretch_timer();

    exit;
}


// ====================================================
// TALKING LOOP
// ====================================================

if (b1ll_state == "talking")
{
    image_index = 0;
    image_speed = 1;

    exit;
}


// ====================================================
// IDLE LOOP
// ====================================================

if (b1ll_state == "idle")
{
    image_index = 0;
    image_speed = 1;
}