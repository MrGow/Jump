/// oElectricCable — Clean Up

if (variable_instance_exists(id, "electric_small_loop_instance"))
{
    if (electric_small_loop_instance != noone)
    {
        audio_stop_sound(electric_small_loop_instance);

        electric_small_loop_instance =
            noone;
    }
}