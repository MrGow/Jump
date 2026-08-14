/// oTeleporterSolid — Step


// ====================================================
// OWNER LOST
// ====================================================

if (
    owner_teleporter != noone
    &&
    !instance_exists(
        owner_teleporter
    )
)
{
    instance_destroy();
    exit;
}