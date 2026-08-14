/// oTeleporter — End Step


// ====================================================
// MAGNETIZING
//
// Player is still being pulled in Step.
// End Step kills normal player movement AND overrides
// the bird's own follow movement afterwards.
// ====================================================

if (teleporter_state == "magnetizing")
{
    if (!instance_exists(sequence_player))
    {
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


    if (
        variable_instance_exists(
            sequence_player,
            "jump_charging"
        )
    )
    {
        sequence_player.jump_charging =
            false;
    }


    if (
        variable_instance_exists(
            sequence_player,
            "jump_charge"
        )
    )
    {
        sequence_player.jump_charge =
            0;
    }


    if (
        variable_instance_exists(
            sequence_player,
            "jump_charge_level"
        )
    )
    {
        sequence_player.jump_charge_level =
            0;
    }


    // =================================================
    // HARD-LOCK BIRD AFTER ITS OWN FOLLOW LOGIC
    // =================================================

    if (instance_exists(sequence_bird))
    {
        sequence_bird.x =
            sequence_player.x +
            teleport_bird_offset_x;


        sequence_bird.y =
            sequence_player.y +
            teleport_bird_offset_y;


        sequence_bird.image_alpha =
            1;
    }


    exit;
}


// ====================================================
// ACTIVATING / WAITING FOR VORTEX
// ====================================================

if (
    teleporter_state != "activating"
    &&
    teleporter_state != "waiting_for_fade"
)
{
    exit;
}


if (!instance_exists(sequence_player))
{
    exit;
}


// ====================================================
// HARD LOCK PLAYER
// ====================================================

sequence_player.x =
    lock_player_x;

sequence_player.y =
    lock_player_y;


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


if (
    variable_instance_exists(
        sequence_player,
        "jump_charging"
    )
)
{
    sequence_player.jump_charging =
        false;
}


if (
    variable_instance_exists(
        sequence_player,
        "jump_charge"
    )
)
{
    sequence_player.jump_charge =
        0;
}


if (
    variable_instance_exists(
        sequence_player,
        "jump_charge_level"
    )
)
{
    sequence_player.jump_charge_level =
        0;
}


// ====================================================
// HARD LOCK BIRD
//
// This happens after the bird's own Step logic, so it
// cannot wander away just before teleport.
// ====================================================

if (instance_exists(sequence_bird))
{
    sequence_bird.x =
        sequence_player.x +
        teleport_bird_offset_x;


    sequence_bird.y =
        sequence_player.y +
        teleport_bird_offset_y;


    if (player_hidden)
    {
        sequence_bird.image_alpha =
            0;
    }
    else
    {
        sequence_bird.image_alpha =
            1;
    }
}


// ====================================================
// PLAYER VISIBILITY
// ====================================================

if (player_hidden)
{
    sequence_player.image_alpha =
        0;
}