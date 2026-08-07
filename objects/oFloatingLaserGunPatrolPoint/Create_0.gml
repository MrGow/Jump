/// oFloatingLaserGunPatrolPoint — Create

visible = false;

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

// Must match the patrol_id on the floating laser gun.
if (!variable_instance_exists(id, "patrol_id"))
{
    patrol_id = "";
}