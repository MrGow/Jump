/// oHoloPlatformTrigger — Create

visible = false;

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "one_use"))
{
    one_use = true;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

used = false;