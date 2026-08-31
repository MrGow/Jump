/// oTeleportKey — Step


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


// ====================================================
// DEATH RESET
// ====================================================

if (p != noone)
{
    var player_dead =
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead";


    if (
        player_dead
        &&
        (
            key_state == "carried"
            ||
            key_state == "to_teleporter"
        )
    )
    {
        reset_key();
        exit;
    }
}


// ====================================================
// PAUSE / FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed =
        0;

    key_stop_loop();

    exit;
}


if (!enabled)
{
    image_speed =
        0;

    key_stop_loop();

    exit;
}


// ====================================================
// WAITING FOR PICKUP
// ====================================================

if (key_state == "waiting")
{
    visible =
        true;

    image_alpha =
        1;

    image_speed =
        0.18;


    // =================================================
    // AMBIENT KEY LOOP
    //
    // Plays as a normal looping sound.
    // Distance is handled manually with gain.
    // =================================================

    if (
        p == noone
        ||
        snd_key_loop == -1
    )
    {
        key_stop_loop();
    }
    else
    {
        var loop_dist_gain =
            key_distance_gain(
                p
            );


        if (loop_dist_gain <= 0)
        {
            key_stop_loop();
        }
        else
        {
            var loop_target_gain =
                key_loop_gain
                *
                loop_dist_gain;


            key_loop_current_gain =
                lerp(
                    key_loop_current_gain,
                    loop_target_gain,
                    key_loop_gain_lerp
                );


            // -----------------------------------------
            // Start loop if needed
            // -----------------------------------------

            if (
                key_loop_instance == -1
                ||
                !audio_is_playing(
                    key_loop_instance
                )
            )
            {
                key_loop_instance =
                    audio_play_sound(
                        snd_key_loop,
                        5,
                        true
                    );


                if (
                    key_loop_instance != -1
                )
                {
                    audio_sound_gain(
                        key_loop_instance,
                        0,
                        0
                    );
                }
            }


            // -----------------------------------------
            // Distance gain
            // -----------------------------------------

            if (
                key_loop_instance != -1
            )
            {
                audio_sound_gain(
                    key_loop_instance,
                    key_loop_current_gain,
                    100
                );
            }
        }
    }


    if (p == noone)
    {
        exit;
    }


    var player_dead =
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead";


    if (player_dead)
    {
        exit;
    }


    // ------------------------------------------------
    // PICKUP OVERLAP
    // ------------------------------------------------

    var overlap =
        p.bbox_right >
            bbox_left - pickup_pad
        &&
        p.bbox_left <
            bbox_right + pickup_pad
        &&
        p.bbox_bottom >
            bbox_top - pickup_pad
        &&
        p.bbox_top <
            bbox_bottom + pickup_pad;


    if (overlap)
    {
        // Stop ambient immediately.
        key_stop_loop();


        // Pickup sound.
        key_play_pickup();


        key_state =
            "carried";


        carrier =
            p;


        variable_struct_set(
            global.teleport_room_keys,
            link_id,
            true
        );


        // Start bob cleanly.
        bob_phase =
            0;
    }


    exit;
}


// ====================================================
// CARRIED
// ====================================================

if (key_state == "carried")
{
    // No ambient loop once player owns the key.
    key_stop_loop();


    if (!instance_exists(carrier))
    {
        reset_key();

        exit;
    }


    bob_phase +=
        bob_speed;


    var carrier_facing =
        variable_instance_exists(
            carrier,
            "facing"
        )
        ? carrier.facing
        : 1;


    // ------------------------------------------------
    // FLOAT BESIDE / ABOVE PLAYER
    // ------------------------------------------------

    x =
        carrier.x
        +
        (
            carry_offset_x
            *
            carrier_facing
        );


    y =
        carrier.bbox_top
        +
        carry_offset_y
        +
        sin(
            bob_phase
        )
        *
        bob_amount;


    visible =
        true;

    image_alpha =
        1;

    image_speed =
        0.18;


    exit;
}


// ====================================================
// FLY INTO TELEPORTER
// ====================================================

if (key_state == "to_teleporter")
{
    key_stop_loop();


    if (!instance_exists(target_teleporter))
    {
        reset_key();

        exit;
    }


    image_speed =
        0.25;


    var target_x =
        target_teleporter.x;


    var target_y =
        target_teleporter.y;


    x =
        lerp(
            x,
            target_x,
            unlock_fly_speed
        );


    y =
        lerp(
            y,
            target_y,
            unlock_fly_speed
        );


    // ------------------------------------------------
    // ARRIVED
    // ------------------------------------------------

    if (
        point_distance(
            x,
            y,
            target_x,
            target_y
        )
        <= 3
    )
    {
        x =
            target_x;

        y =
            target_y;


        key_state =
            "consumed";


        visible =
            false;

        image_alpha =
            0;

        image_speed =
            0;


        variable_struct_set(
            global.teleport_room_keys,
            link_id,
            false
        );


        // Tell teleporter that key reached it.
        if (
            variable_instance_exists(
                target_teleporter,
                "key_arrived"
            )
        )
        {
            target_teleporter.key_arrived =
                true;
        }
    }


    exit;
}


// ====================================================
// CONSUMED
// ====================================================

if (key_state == "consumed")
{
    key_stop_loop();


    visible =
        false;

    image_speed =
        0;


    exit;
}