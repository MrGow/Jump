/// oChipCollectable — Clean Up

if (variable_instance_exists(id, "chip_loop_voice"))
{
    if (chip_loop_voice != -1)
    {
        audio_stop_sound(chip_loop_voice);
        chip_loop_voice = -1;
    }
}