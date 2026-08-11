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
    // RETRACTED
    //
    // Completely safe.
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

            // Still safe while extending.
            active = false;

            image_index =
                idle_frame;

            image_speed = 0;
        }
    }
    break;


    // ------------------------------------------------
    // EXTENDING
    //
    // Frames leading up to the fully raised sixth
    // frame are visual warning only.
    // ------------------------------------------------
    case "extending":
    {
        active = false;

        image_speed = 0;

        image_index +=
            spike_anim_speed;


        // --------------------------------------------
        // REACHED FULL EXTENSION
        // --------------------------------------------
        if (image_index >= up_hold_frame)
        {
            // Snap EXACTLY to visible sixth frame.
            image_index =
                up_hold_frame;

            // Now lethal.
            active = true;

            state =
                "extended";

            up_timer =
                up_frames;
        }
    }
    break;


    // ------------------------------------------------
    // EXTENDED
    //
    // Stay visibly locked on frame 6.
    // ------------------------------------------------
    case "extended":
    {
        active = true;

        image_speed = 0;

        // Force the visible fully-extended frame.
        image_index =
            up_hold_frame;

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
    // Remains lethal while the physical spike is
    // retracting.
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
// ONLY CHECK PLAYER WHILE LETHAL
// ====================================================

if (!active)
{
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

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


// ====================================================
// COLLISION
// ====================================================

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