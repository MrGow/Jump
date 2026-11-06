/// oScrapChiefElevator — Clean Up

if (elevator_loop_instance != noone)
{
    audio_stop_sound(
        elevator_loop_instance
    );

    elevator_loop_instance = noone;
}