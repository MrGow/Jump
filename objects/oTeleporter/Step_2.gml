/// oTeleporter — End Step


// Unlocking does NOT lock the player.
//
// Only actual teleporting does.
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


if (player_hidden)
{
    sequence_player.image_alpha =
        0;
}