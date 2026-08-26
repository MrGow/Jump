/// oB1LL — Animation End


// ====================================================
// STRETCH COMPLETE
// ====================================================

if (
    b1ll_state ==
    "stretching"
)
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
// TALKING ANIMATION LOOP
//
// If text is still typing, B1LL is still speaking.
//
// Reaching Animation End naturally wraps the talking
// animation back to frame 0.
//
// This DOES NOT overwrite talking_resume_frame.
// That variable is only updated when a dialogue line
// actually finishes.
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
// DIALOGUE LINE COMPLETE
//
// B1LL idles until the next line.
// ====================================================

if (
    dialogue_active &&
    text_line_complete
)
{
    b1ll_state =
        "idle";

    sprite_index =
        spr_idle;

    image_index =
        0;

    image_speed =
        1;


    exit;
}


// ====================================================
// WAITING FOR PLAYER TO LAND
// ====================================================

if (
    b1ll_state ==
    "waiting_for_land"
)
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

if (
    b1ll_state ==
    "idle"
)
{
    sprite_index =
        spr_idle;

    image_index =
        0;

    image_speed =
        1;
}