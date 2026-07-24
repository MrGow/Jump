/// oGunShipMine — Clean Up

if (
    beep_instance != noone
)
{
    audio_stop_sound(
        beep_instance
    );

    beep_instance =
        noone;
}