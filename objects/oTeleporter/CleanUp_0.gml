/// oTeleporter — Clean Up

if (
    !room_change_started
    &&
    instance_exists(sequence_player)
)
{
    sequence_player.image_alpha =
        1;
}