/// oSpringPlatform — Clean Up

if (instance_exists(solid_inst))
{
    with (solid_inst)
    {
        instance_destroy();
    }
}

solid_inst = noone;