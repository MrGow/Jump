/// oElectricCableLarge — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "facing_direction"))
{
    facing_direction = 1;
}

if (!variable_instance_exists(id, "cable_anim_speed"))
{
    cable_anim_speed = 0.35;
}

if (!variable_instance_exists(id, "active_from"))
{
    active_from = 6;
}

if (!variable_instance_exists(id, "active_to"))
{
    active_to = 13;
}

if (!variable_instance_exists(id, "off_hold_frames"))
{
    off_hold_frames = 60;
}

if (!variable_instance_exists(id, "on_hold_frames"))
{
    on_hold_frames = 0;
}

if (!variable_instance_exists(id, "cable_state"))
{
    cable_state = "off_hold";
}

if (!variable_instance_exists(id, "cable_state_timer"))
{
    cable_state_timer = off_hold_frames;
}

if (!variable_instance_exists(id, "snd_electric_loop"))
{
    snd_electric_loop =
        asset_get_index(
            "LargeElectricCableSound"
        );
}

if (!variable_instance_exists(id, "electric_loop_instance"))
{
    electric_loop_instance = noone;
}

if (!variable_instance_exists(id, "electric_loop_gain"))
{
    electric_loop_gain = 0.35;
}

if (!variable_instance_exists(id, "electric_loop_pitch"))
{
    electric_loop_pitch = 1.0;
}

if (!variable_instance_exists(id, "electric_loop_inner_dist"))
{
    electric_loop_inner_dist = 90;
}

if (!variable_instance_exists(id, "electric_loop_outer_dist"))
{
    electric_loop_outer_dist = 320;
}


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    if (electric_loop_instance != noone)
    {
        audio_stop_sound(
            electric_loop_instance
        );

        electric_loop_instance = noone;
    }

    exit;
}


// ====================================================
// FACING
// ====================================================

facing_direction =
    clamp(
        round(facing_direction),
        1,
        8
    );

image_angle =
    (facing_direction - 1)
    *
    45;


// Keep physical helper aligned.
if (instance_exists(solid_inst))
{
    solid_inst.x = x;
    solid_inst.y = y;

    solid_inst.image_angle =
        image_angle;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active = false;

    image_index = 0;
    image_speed = 0;

    cable_state =
        "off_hold";

    cable_state_timer =
        off_hold_frames;


    if (electric_loop_instance != noone)
    {
        audio_stop_sound(
            electric_loop_instance
        );

        electric_loop_instance =
            noone;
    }

    exit;
}


// ====================================================
// MANUAL ANIMATION
// ====================================================

image_speed = 0;


// ====================================================
// OFF HOLD
// ====================================================

if (cable_state == "off_hold")
{
    active = false;

    image_index = 0;


    if (cable_state_timer > 0)
    {
        cable_state_timer--;
    }
    else
    {
        cable_state =
            "turning_on";
    }
}


// ====================================================
// TURNING ON
// ====================================================

else if (cable_state == "turning_on")
{
    image_index +=
        cable_anim_speed;


    // Becomes lethal at active_from.
    active =
        image_index >= active_from;


    // -----------------------------------------------
    // Reached final lethal frame.
    // -----------------------------------------------

    if (image_index >= active_to)
    {
        image_index =
            active_to;

        active =
            true;


        // Optional hold.
        if (on_hold_frames > 0)
        {
            cable_state =
                "on_hold";

            cable_state_timer =
                on_hold_frames;
        }
        else
        {
            // No hold:
            // immediately enter shutdown sequence.
            cable_state =
                "turning_off";
        }
    }
}


// ====================================================
// ON HOLD
//
// While fully powered, loop the electrical animation
// through GameMaker frames 6-13.
//
// Visible sprite frames:
// 7-14
// ====================================================

else if (cable_state == "on_hold")
{
    active =
        true;


    // Continue animating through the lethal frames.
    image_index +=
        cable_anim_speed;


    // Loop back to the first lethal frame.
    if (image_index >= active_to + 1)
    {
        image_index =
            active_from
            +
            (
                image_index
                -
                (active_to + 1)
            );
    }


    // Count down how long the cable remains fully ON.
    if (cable_state_timer > 0)
    {
        cable_state_timer--;
    }
    else
    {
        // Make sure shutdown begins from the final
        // ON frame rather than wherever the loop
        // happened to be.
        image_index =
            active_to;

        cable_state =
            "turning_off";
    }
}


// ====================================================
// TURNING OFF
// ====================================================

else if (cable_state == "turning_off")
{
    // IMPORTANT:
    // Keep advancing the animation rather than
    // remaining frozen on active_to.
    image_index +=
        cable_anim_speed;


    // The cable stops killing as soon as the
    // animation moves beyond active_to.
    if (image_index > active_to)
    {
        active =
            false;
    }
    else
    {
        active =
            true;
    }


    // -----------------------------------------------
    // END OF ANIMATION
    // -----------------------------------------------

    if (image_index >= image_number)
    {
        image_index =
            0;

        active =
            false;

        cable_state =
            "off_hold";

        cable_state_timer =
            max(
                0,
                round(off_hold_frames)
            );
    }
}


// ====================================================
// ELECTRIC LOOP
//
// Sound only plays while cable is lethal.
// ====================================================

var target_gain =
    0;


var p_audio =
    instance_find(
        oPlayer,
        0
    );


if (
    active
    &&
    p_audio != noone
)
{
    var my_dist =
        point_distance(
            x,
            y,
            p_audio.x,
            p_audio.y
        );


    if (
        my_dist <
        electric_loop_outer_dist
    )
    {
        if (
            my_dist <=
            electric_loop_inner_dist
        )
        {
            target_gain =
                electric_loop_gain;
        }
        else
        {
            var tdist =
                (
                    my_dist
                    -
                    electric_loop_inner_dist
                )
                /
                max(
                    1,
                    electric_loop_outer_dist
                    -
                    electric_loop_inner_dist
                );


            target_gain =
                electric_loop_gain
                *
                (
                    1
                    -
                    clamp(
                        tdist,
                        0,
                        1
                    )
                );
        }
    }
}


// ====================================================
// STOP ELECTRIC LOOP
// ====================================================

if (target_gain <= 0)
{
    if (electric_loop_instance != noone)
    {
        audio_stop_sound(
            electric_loop_instance
        );

        electric_loop_instance =
            noone;
    }
}


// ====================================================
// START / UPDATE ELECTRIC LOOP
// ====================================================

else
{
    if (
        snd_electric_loop != -1
        &&
        audio_group_is_loaded(
            audiogroupsfx
        )
    )
    {
        if (electric_loop_instance == noone)
        {
            electric_loop_instance =
                audio_play_sound(
                    snd_electric_loop,
                    -60,
                    true
                );


            if (electric_loop_instance != noone)
            {
                audio_sound_gain(
                    electric_loop_instance,
                    0,
                    0
                );

                audio_sound_pitch(
                    electric_loop_instance,
                    electric_loop_pitch
                );
            }
        }


        if (electric_loop_instance != noone)
        {
            audio_sound_gain(
                electric_loop_instance,
                target_gain,
                100
            );
        }
    }
}