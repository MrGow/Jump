/// oElectricCableLarge — Clean Up

if (variable_instance_exists(id, "electric_loop_instance"))
{
    if (electric_loop_instance != noone)
    {
        audio_stop_sound(electric_loop_instance);
        electric_loop_instance = noone;
    }
}

if (instance_exists(solid_inst))
{
    with (solid_inst)
    {
        instance_destroy();
    }
}