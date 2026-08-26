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
//
// Only loop while text is actually being revealed.
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
// Normally the talking animation will already be frozen
// before Animation End can happen, but keep this guard
// for safety.
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
// END OF WHOLE CONVERSATION
//
// Frame 0 is commonly the neutral talking pose.
//
// If that's our configured neutral frame, reaching the
// end of the animation is the cleanest possible point
// to return to idle.
// ====================================================

if (b1ll_state == "ending_talk_pose")
{
    if (talk_end_talking_frame == 0)
    {
        b1ll_state =
            "idle";


        sprite_index =
            spr_idle;


        image_index =
            talk_start_idle_frame;


        image_speed =
            1;


        reset_stretch_timer();
    }
    else
    {
        // Continue looping until Step sees the requested
        // neutral talking frame.
        image_index =
            0;


        image_speed =
            1;
    }


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
// WAITING FOR NEUTRAL IDLE POSE
//
// Allow idle animation to loop normally.
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
// NORMAL IDLE LOOP
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