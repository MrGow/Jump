/// oMissileLauncher — Clean Up

if (instance_exists(silo_solid))
{
    with (silo_solid)
    {
        instance_destroy();
    }
}

if (instance_exists(plate_solid))
{
    with (plate_solid)
    {
        instance_destroy();
    }
}