/// oSpinner — Clean Up


// ====================================================
// STOP LOOP AUDIO
// ====================================================

if (
    variable_instance_exists(
        id,
        "spinner_loop_instance"
    )
)
{
    if (spinner_loop_instance != noone)
    {
        audio_stop_sound(
            spinner_loop_instance
        );


        spinner_loop_instance =
            noone;
    }
}


// ====================================================
// DESTROY OWNED PLATFORMS
// ====================================================

if (
    variable_instance_exists(
        id,
        "platforms"
    )
)
{
    for (
        var i = 0;
        i < array_length(platforms);
        i++
    )
    {
        if (instance_exists(platforms[i]))
        {
            with (platforms[i])
            {
                instance_destroy();
            }
        }
    }
}