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
// TALKING LOOP
//
// Only loop the talking animation while the current
// dialogue line is still actively typing.
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
// Current line has finished.
// B1LL sits in idle until Space/A starts the next line.
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