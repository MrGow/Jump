/// oAtmosphereController — Clean Up

// ====================================================
// STOP OWNED AUDIO ON ACTUAL DESTRUCTION
// ====================================================

if (
    variable_instance_exists(id, "atmo_instance")
)
{
    if (atmo_instance != noone)
    {
        if (audio_is_playing(atmo_instance))
        {
            audio_stop_sound(atmo_instance);
        }

        atmo_instance = noone;
    }
}