/// oTeleporter — Step


// ====================================================
// ONE-FRAME ERROR TRIGGER
// ====================================================

key_required_triggered =
    false;


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
    var player_dead_now =
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead";


    if (
        player_dead_now
        &&
        (
            teleporter_state == "unlocking"
            ||
            teleporter_state == "unlocked"
            ||
            teleporter_state == "activating"
        )
    )
    {
        if (player_hidden)
        {
            p.image_alpha =
                1;
        }


        reset_teleporter_puzzle();

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

    exit;
}


if (!enabled)
{
    image_speed =
        0;

    show_key_required =
        false;

    exit;
}


// ====================================================
// UNLOCK MESSAGE
// ====================================================

if (unlock_world_timer > 0)
{
    unlock_world_timer--;


    unlock_world_bob_phase +=
        unlock_world_bob_speed;


    unlock_world_pop =
        min(
            1,
            unlock_world_pop +
            unlock_world_pop_speed
        );
}
else
{
    unlock_world_pop =
        0;
}


// ====================================================
// INACTIVE
// ====================================================

if (teleporter_state == "inactive")
{
    sprite_index =
        spriteTeleporter;

    image_index =
        inactive_frame;

    image_speed =
        0;


    if (p == noone)
    {
        show_key_required =
            false;

        key_required_was_showing =
            false;

        key_required_pop =
            0;

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


    // =================================================
    // MATCHING CARRIED KEY
    // ====================================================

    var carried_key =
        find_matching_key(
            "carried"
        );


    var has_key =
        carried_key != noone;


    var dist_to_player =
        point_distance(
            x,
            y,
            p.x,
            p.y
        );


    // =================================================
    // KEY NEAR TELEPORTER
    // ====================================================

    if (
        has_key
        &&
        dist_to_player <=
            key_accept_distance
    )
    {
        begin_unlock();

        exit;
    }


    // =================================================
    // NO KEY WARNING
    // ====================================================

    var should_show_warning =
        !has_key
        &&
        dist_to_player <=
            key_required_distance;


    show_key_required =
        should_show_warning;


    if (
        show_key_required
        &&
        !key_required_was_showing
    )
    {
        key_required_triggered =
            true;


        key_required_pop =
            0;

        key_required_bob_phase =
            0;


        // Future error sound goes here.
    }


    if (show_key_required)
    {
        key_required_bob_phase +=
            key_required_bob_speed;


        key_required_pop =
            min(
                1,
                key_required_pop +
                key_required_pop_speed
            );
    }
    else
    {
        key_required_pop =
            0;
    }


    key_required_was_showing =
        show_key_required;


    exit;
}


// ====================================================
// UNLOCKING
// ====================================================

if (teleporter_state == "unlocking")
{
    show_key_required =
        false;

    key_required_was_showing =
        false;

    key_required_pop =
        0;


    if (key_arrived)
    {
        complete_unlock();
    }


    exit;
}


// ====================================================
// UNLOCKED
//
// IMPORTANT:
//
// Do NOT use teleporter bbox for activation.
//
// The sprite frame is intentionally huge because it
// contains the teleport effect.
//
// The trigger is based entirely on:
//     teleporter x
//     teleporter y
//     explicit surface offset
// ====================================================

if (teleporter_state == "unlocked")
{
    show_key_required =
        false;


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


    // ------------------------------------------------
    // Actual physical top of the pad
    // ------------------------------------------------

    var pad_surface_y =
        y +
        teleport_surface_offset_y;


    // ------------------------------------------------
    // Player must be centred horizontally
    // ------------------------------------------------

    var centered_x =
        abs(
            p.x - x
        )
        <=
        teleport_center_tolerance;


    // ------------------------------------------------
    // Player FEET must be on the pad
    // ------------------------------------------------

    var feet_on_pad =
        abs(
            p.bbox_bottom -
            pad_surface_y
        )
        <=
        teleport_feet_tolerance;


    // ------------------------------------------------
    // Trigger
    // ------------------------------------------------

    if (
        centered_x
        &&
        feet_on_pad
    )
    {
        begin_teleport(p);
    }


    exit;
}


// ====================================================
// ACTIVATING
// ====================================================

if (teleporter_state == "activating")
{
    show_key_required =
        false;


    sprite_index =
        spriteTeleporter;

    image_speed =
        0;


    var previous_frame =
        image_index;


    image_index +=
        activation_anim_speed;


    // ------------------------------------------------
    // Player disappears into effect
    // ------------------------------------------------

    if (
        !player_hidden
        &&
        previous_frame <
            player_hide_frame
        &&
        image_index >=
            player_hide_frame
    )
    {
        player_hidden =
            true;


        if (instance_exists(sequence_player))
        {
            sequence_player.image_alpha =
                0;
        }
    }


    // ------------------------------------------------
    // Animation finished
    // ------------------------------------------------

    if (
        image_index >=
        activation_end_frame
    )
    {
        image_index =
            activation_end_frame;


        request_teleport_fade();
    }


    exit;
}


// ====================================================
// WAIT FOR FADE
// ====================================================

if (teleporter_state == "waiting_for_fade")
{
    image_speed =
        0;

    exit;
}