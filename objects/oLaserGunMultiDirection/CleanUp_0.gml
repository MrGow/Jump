// ============================================================================
// CLEAN UP
// ============================================================================

/// oLaserGunMultiDirection — Clean Up

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