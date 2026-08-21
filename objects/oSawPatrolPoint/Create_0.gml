// ============================================================================
// oSawPatrolPoint — Create
// ============================================================================

/// oSawPatrolPoint — Create

visible = false;

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "patrol_id"))
{
    patrol_id = "A";
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}