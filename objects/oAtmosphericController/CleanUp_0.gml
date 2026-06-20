/// oAtmosphereController - Clean Up

if (atmo_instance != noone)
{
    audio_stop_sound(atmo_instance);
    atmo_instance = noone;
}