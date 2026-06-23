/// oMovingPlatform — Clean Up

if (variable_instance_exists(id, "moving_platform_loop_instance"))
{
    if (moving_platform_loop_instance != noone)
    {
        audio_stop_sound(moving_platform_loop_instance);
        moving_platform_loop_instance = noone;
    }
}