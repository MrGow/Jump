/// oConveyorLeft - Clean Up

if (variable_instance_exists(id, "conveyor_loop_instance"))
{
    if (conveyor_loop_instance != noone)
    {
        audio_stop_sound(conveyor_loop_instance);
        conveyor_loop_instance = noone;
    }
}