/// oFlames — Clean Up

if (variable_instance_exists(id, "flame_loop_instance"))
{
    if (flame_loop_instance != noone)
    {
        audio_stop_sound(flame_loop_instance);
        flame_loop_instance = noone;
    }
}