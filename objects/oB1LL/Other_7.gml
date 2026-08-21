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

        image_index =
            0;

        image_speed =
            1;
    }

    reset_stretch_timer();

    exit;
}


// ====================================================
// DIALOGUE
// ====================================================

if (
    b1ll_state == "talking" &&
    dialogue_active
)
{
    // ------------------------------------------------
    // Text is still appearing:
    // loop talking animation.
    // ------------------------------------------------

    if (!text_line_complete)
    {
        if (spr_talking != -1)
        {
            sprite_index =
                spr_talking;

            image_index =
                0;

            image_speed =
                1;
        }
    }


    // ------------------------------------------------
    // Line is complete:
    // loop idle while waiting for confirm.
    // ------------------------------------------------

    else
    {
        if (spr_idle != -1)
        {
            sprite_index =
                spr_idle;

            image_index =
                0;

            image_speed =
                1;
        }
    }

    exit;
}


// ====================================================
// IDLE LOOP
// ====================================================

if (b1ll_state == "idle")
{
    if (spr_idle != -1)
    {
        sprite_index =
            spr_idle;
    }

    image_index =
        0;

    image_speed =
        1;
}