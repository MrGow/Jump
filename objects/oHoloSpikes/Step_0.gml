/// oHoloSpike — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "retract_safe_frame"))
{
    retract_safe_frame =
        2;
}


retract_safe_frame =
    clamp(
        retract_safe_frame,
        idle_frame,
        up_hold_frame
    );


if (!variable_instance_exists(id, "snd_holo_extend"))
{
    snd_holo_extend =
        asset_get_index(
            "HoloSpikesExtend1"
        );
}


if (!variable_instance_exists(id, "snd_holo_retract"))
{
    snd_holo_retract =
        asset_get_index(
            "HoloSpikesRetract1"
        );
}


if (!variable_instance_exists(id, "holo_spike_sound_gain"))
{
    holo_spike_sound_gain =
        0.65;
}


if (!variable_instance_exists(id, "holo_spike_sound_inner_dist"))
{
    holo_spike_sound_inner_dist =
        90;
}


if (!variable_instance_exists(id, "holo_spike_sound_outer_dist"))
{
    holo_spike_sound_outer_dist =
        420;
}


if (!variable_instance_exists(id, "holo_spike_sound_falloff_curve"))
{
    holo_spike_sound_falloff_curve =
        1.35;
}


if (!variable_instance_exists(id, "holo_spike_sound_max_voices"))
{
    holo_spike_sound_max_voices =
        4;
}


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

    image_index =
        idle_frame;


    state =
        "retracted";


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

        image_index =
            idle_frame;


        retracted_timer--;


        if (retracted_timer <= 0)
        {
            state =
                "extending";


            // Still safe while extending.
            active =
                false;


            image_index =
                idle_frame;


            image_speed =
                0;


            // ----------------------------------------
            // EXTEND SOUND
            // ----------------------------------------

            holo_spike_play_sound(
                snd_holo_extend
            );
        }
    }
    break;


    // ------------------------------------------------
    // EXTENDING
    //
    // Extension is visual warning only.
    // It does not become lethal until fully raised.
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
            image_index =
                up_hold_frame;


            // Fully raised = lethal.
            active =
                true;


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
    // Fully raised and lethal.
    // ------------------------------------------------

    case "extended":
    {
        active = true;

        image_speed = 0;


        image_index =
            up_hold_frame;


        up_timer--;


        if (up_timer <= 0)
        {
            state =
                "retracting";


            image_index =
                up_hold_frame;


            // ----------------------------------------
            // RETRACT SOUND
            // ----------------------------------------

            holo_spike_play_sound(
                snd_holo_retract
            );
        }
    }
    break;


    // ------------------------------------------------
    // RETRACTING
    //
    // Lethal only while enough of the spike remains
    // visibly exposed.
    //
    // Once image_index reaches retract_safe_frame
    // or lower, it becomes harmless even though the
    // remaining visual retraction continues.
    // ------------------------------------------------

    case "retracting":
    {
        image_speed = 0;


        image_index -=
            spike_anim_speed;


        // --------------------------------------------
        // LETHAL CUTOFF
        // --------------------------------------------

        active =
            image_index >
            retract_safe_frame;


        // --------------------------------------------
        // FULLY RETRACTED
        // --------------------------------------------

        if (image_index <= idle_frame)
        {
            image_index =
                idle_frame;


            state =
                "retracted";


            active =
                false;


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


// ====================================================
// KILL PLAYER
// ====================================================

if (hit)
{
    with (p)
    {
        scr_player_died();
    }
}