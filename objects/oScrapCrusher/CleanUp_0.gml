/// oScrapCrusher — Clean Up

if (variable_instance_exists(id, "crusher_loop_instance"))
{
    if (crusher_loop_instance != noone)
    {
        audio_stop_sound(crusher_loop_instance);
        crusher_loop_instance = noone;
    }
}