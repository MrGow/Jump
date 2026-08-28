/// oArea1ElevatorPlatform — Clean Up


// ====================================================
// STOP MOVEMENT LOOP
// ====================================================

if (
    rising_loop_instance != noone
)
{
    audio_stop_sound(
        rising_loop_instance
    );

    rising_loop_instance =
        noone;
}