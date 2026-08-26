/// oB1LL — Animation End


// ====================================================
// STRETCH COMPLETE
// ====================================================

if (b1ll_state == "stretching")
{
    b1ll_state =
        "idle";


    sprite_index =
        spr_idle;


    image_index =
        0;


    image_speed =
        1;


    reset_stretch_timer();


    exit;
}


// ====================================================
// TALKING LOOP
// ====================================================

if (
    dialogue_active &&
    !text_line_complete
)
{
    b1ll_state =
        "talking";


    if (spr_talking != -1)
    {
        sprite_index =
            spr_talking;


        image_index =
            0;


        image_speed =
            1;
    }


    exit;
}


// ====================================================
// COMPLETED DIALOGUE LINE
//
// Freeze talking animation.
//
// Bob continues independently.
// ====================================================

if (
    dialogue_active &&
    text_line_complete
)
{
    freeze_talking_pose();


    exit;
}


// ====================================================
// WAITING FOR PLAYER TO LAND
// ====================================================

if (b1ll_state == "waiting_for_land")
{
    sprite_index =
        spr_idle;


    image_index =
        0;


    image_speed =
        1;


    exit;
}


// ====================================================
// WAITING FOR TALK TRANSITION
// ====================================================

if (b1ll_state == "waiting_for_talk_pose")
{
    sprite_index =
        spr_idle;


    image_index =
        0;


    image_speed =
        1;


    exit;
}


// ====================================================
// NORMAL IDLE
// ====================================================

if (b1ll_state == "idle")
{
    sprite_index =
        spr_idle;


    image_index =
        0;


    image_speed =
        1;
}