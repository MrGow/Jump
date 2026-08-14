/// oTeleporter — Step


// ====================================================
// KEEP / RECREATE SOLID HELPER
// ====================================================

if (
    !variable_instance_exists(
        id,
        "solid_inst"
    )
    ||
    !instance_exists(
        solid_inst
    )
)
{
    solid_inst =
        instance_create_layer(
            x + solid_offset_x,
            y + solid_offset_y,
            "Instances",
            oTeleporterSolid
        );


    if (solid_inst != noone)
    {
        solid_inst.owner_teleporter =
            id;
    }
}


if (instance_exists(solid_inst))
{
    solid_inst.x =
        x +
        solid_offset_x;


    solid_inst.y =
        y +
        solid_offset_y;


    solid_inst.debug_draw =
        solid_debug_draw;
}


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
            teleporter_state == "magnetizing"
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


        if (instance_exists(sequence_bird))
        {
            sequence_bird.image_alpha =
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
    // KEY ENTERS ACCEPT RANGE
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
// Whole teleporter bbox starts magnetic pull.
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


    var overlap =
        p.bbox_right >
            bbox_left
        &&
        p.bbox_left <
            bbox_right
        &&
        p.bbox_bottom >
            bbox_top
        &&
        p.bbox_top <
            bbox_bottom;


    if (overlap)
    {
        begin_magnetize(p);
    }


    exit;
}


// ====================================================
// MAGNETIZING
//
// Pull player AND bird toward teleporter.
// ====================================================

if (teleporter_state == "magnetizing")
{
    show_key_required =
        false;


    if (!instance_exists(sequence_player))
    {
        reset_teleporter_puzzle();

        exit;
    }


    // ------------------------------------------------
    // Kill player movement
    // ------------------------------------------------

    if (
        variable_instance_exists(
            sequence_player,
            "hsp"
        )
    )
    {
        sequence_player.hsp =
            0;
    }


    if (
        variable_instance_exists(
            sequence_player,
            "vsp"
        )
    )
    {
        sequence_player.vsp =
            0;
    }


    // ------------------------------------------------
    // Pull player
    // ------------------------------------------------

    sequence_player.x =
        lerp(
            sequence_player.x,
            lock_player_x,
            teleport_magnet_speed
        );


    sequence_player.y =
        lerp(
            sequence_player.y,
            lock_player_y,
            teleport_magnet_speed
        );


    // ------------------------------------------------
    // Pull bird toward player
    // ------------------------------------------------

    if (instance_exists(sequence_bird))
    {
        var bird_target_x =
            sequence_player.x +
            teleport_bird_offset_x;


        var bird_target_y =
            sequence_player.y +
            teleport_bird_offset_y;


        sequence_bird.x =
            lerp(
                sequence_bird.x,
                bird_target_x,
                teleport_bird_magnet_speed
            );


        sequence_bird.y =
            lerp(
                sequence_bird.y,
                bird_target_y,
                teleport_bird_magnet_speed
            );
    }


    // ------------------------------------------------
    // Fixed timer
    // ------------------------------------------------

    magnet_timer--;


    if (magnet_timer <= 0)
    {
        sequence_player.x =
            lock_player_x;


        sequence_player.y =
            lock_player_y;


        if (instance_exists(sequence_bird))
        {
            sequence_bird.x =
                sequence_player.x +
                teleport_bird_offset_x;


            sequence_bird.y =
                sequence_player.y +
                teleport_bird_offset_y;
        }


        begin_teleport();
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
    // Keep player and bird together during animation
    // ------------------------------------------------

    if (instance_exists(sequence_player))
    {
        sequence_player.x =
            lock_player_x;


        sequence_player.y =
            lock_player_y;
    }


    if (
        instance_exists(sequence_player)
        &&
        instance_exists(sequence_bird)
    )
    {
        sequence_bird.x =
            sequence_player.x +
            teleport_bird_offset_x;


        sequence_bird.y =
            sequence_player.y +
            teleport_bird_offset_y;
    }


    // ------------------------------------------------
    // Player AND bird disappear together
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


        if (instance_exists(sequence_bird))
        {
            sequence_bird.image_alpha =
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
// WAIT FOR VORTEX / ROOM CHANGE
// ====================================================

if (teleporter_state == "waiting_for_fade")
{
    image_speed =
        0;


    if (instance_exists(sequence_player))
    {
        sequence_player.x =
            lock_player_x;

        sequence_player.y =
            lock_player_y;

        sequence_player.image_alpha =
            0;
    }


    if (
        instance_exists(sequence_player)
        &&
        instance_exists(sequence_bird)
    )
    {
        sequence_bird.x =
            sequence_player.x +
            teleport_bird_offset_x;


        sequence_bird.y =
            sequence_player.y +
            teleport_bird_offset_y;


        sequence_bird.image_alpha =
            0;
    }


    exit;
}
 