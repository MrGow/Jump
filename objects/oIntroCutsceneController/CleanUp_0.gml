/// oIntroCutsceneController — Clean Up

if (signal_static_voice != -1) audio_stop_sound(signal_static_voice);
if (variable_instance_exists(id, "alert_beep_voice") && alert_beep_voice != -1) audio_stop_sound(alert_beep_voice);
if (variable_instance_exists(id, "crt_hum_voice") && crt_hum_voice != -1) audio_stop_sound(crt_hum_voice);

// Stop only voices owned by this controller; preserve scrapyard ambience.
if (variable_instance_exists(id, "intro_sfx_voices"))
{
    for (var i = 0; i < array_length(intro_sfx_voices); i++)
    {
        if (intro_sfx_voices[i] != -1) audio_stop_sound(intro_sfx_voices[i]);
    }
}
