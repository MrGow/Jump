/// oHoloSpike — Step


// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active = false;

    image_speed = 0;
    image_index = idle_frame;

    state = "retracted";

    retracted_timer =
        retracted_frames;

    exit;
}


// ====================================================
// KEEP ROTATION VALID
// ====================================================

update_spike_rotation();


// ====================================================
// STATE MACHINE
// ====================================================

switch (state)
{
    // ------------------------------------------------
    // SAFE / RETRACTED
    // ------------------------------------------------
    case "retracted":
    {
        active = false;

        image_speed = 0;
        image_index = idle_frame;

        retracted_timer--;

        if (retracted_timer <= 0)
        {
            state = "extending";

            // Lethal immediately as extension begins.
            active = true;

            image_index = idle_frame;
            image_speed = 0;
        }
    }
    break;


    // ------------------------------------------------
    // EXTENDING
    //
    // Entire extension is lethal.
    // Stop on the sixth sprite frame.
    // ------------------------------------------------
    case "extending":
    {
        active = true;

        image_speed = 0;

        image_index +=
            spike_anim_speed;

        if (image_index >= up_hold_frame)
        {
            image_index =
                up_hold_frame;

            state =
                "extended";

            up_timer =
                up_frames;
        }
    }
    break;


    // ------------------------------------------------
    // FULLY EXTENDED
    //
    // Hold on sixth animation frame.
    // ------------------------------------------------
    case "extended":
    {
        active = true;

        image_speed = 0;
        image_index = up_hold_frame;

        up_timer--;

        if (up_timer <= 0)
        {
            state =
                "retracting";

            image_index =
                up_hold_frame;
        }
    }
    break;


    // ------------------------------------------------
    // RETRACTING
    //
    // Remains lethal until fully retracted.
    // ------------------------------------------------
    case "retracting":
    {
        active = true;

        image_speed = 0;

        image_index -=
            spike_anim_speed;

        if (image_index <= idle_frame)
        {
            image_index =
                idle_frame;

            state =
                "retracted";

            active = false;

            retracted_timer =
                retracted_frames;
        }
    }
    break;
}


// ====================================================
// PLAYER COLLISION
// ====================================================

if (!active)
{
    exit;
}


var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}


if (
    variable_instance_exists(
        p,
        "state"
    )
    &&
    p.state == "dead"
)
{
    exit;
}


// ----------------------------------------------------
// Slightly forgiving overlap
// ----------------------------------------------------

var pad =
    max(
        0,
        hit_pad
    );


var hit =
    p.bbox_right >
        bbox_left + pad
    &&
    p.bbox_left <
        bbox_right - pad
    &&
    p.bbox_bottom >
        bbox_top + pad
    &&
    p.bbox_top <
        bbox_bottom - pad;


if (hit)
{
    with (p)
    {
        scr_player_died();
    }
}