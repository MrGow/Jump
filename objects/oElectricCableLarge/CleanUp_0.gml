/// oElectricCableLarge — Clean Up


// ====================================================
// AUDIO
// ====================================================

if (
    variable_instance_exists(
        id,
        "electric_loop_instance"
    )
)
{
    if (electric_loop_instance != noone)
    {
        audio_stop_sound(
            electric_loop_instance
        );


        electric_loop_instance =
            noone;
    }
}


// ====================================================
// PHYSICAL HELPER
// ====================================================

if (
    variable_instance_exists(
        id,
        "solid_inst"
    )
    &&
    instance_exists(
        solid_inst
    )
)
{
    instance_destroy(
        solid_inst
    );
}