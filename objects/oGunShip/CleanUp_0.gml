/// oGunShip — Clean Up

if (
    flying_loop_instance != noone
)
{
    audio_stop_sound(
        flying_loop_instance
    );

    flying_loop_instance =
        noone;
}