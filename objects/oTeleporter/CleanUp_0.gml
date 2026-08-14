/// oTeleporter — Clean Up


// ====================================================
// RESTORE PLAYER IF TELEPORT WAS ABORTED
// ====================================================

if (
    !room_change_started
    &&
    instance_exists(sequence_player)
)
{
    sequence_player.image_alpha =
        1;
}


// ====================================================
// REMOVE SOLID HELPER
// ====================================================

if (
    variable_instance_exists(
        id,
        "solid_inst"
    )
    &&
    instance_exists(
        solid_inst
    )
)
{
    with (solid_inst)
    {
        instance_destroy();
    }
}


// ====================================================
// REMOVE TEXT HELPER
// ====================================================

if (
    variable_instance_exists(
        id,
        "text_inst"
    )
    &&
    instance_exists(
        text_inst
    )
)
{
    with (text_inst)
    {
        instance_destroy();
    }
}