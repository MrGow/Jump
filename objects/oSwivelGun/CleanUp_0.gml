/// oSwivelGun — Clean Up

if (patrol_loop_instance != noone)
{
    audio_stop_sound(
        patrol_loop_instance
    );

    patrol_loop_instance = noone;
}