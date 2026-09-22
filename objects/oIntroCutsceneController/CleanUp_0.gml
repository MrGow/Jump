/// oIntroCutsceneController — Clean Up


// ====================================================
// SIGNAL-LOSS STATIC
// ====================================================

if (signal_static_voice != -1)
{
    audio_stop_sound(
        signal_static_voice
    );

    signal_static_voice = -1;
}


// ====================================================
// ALERT BEEP LOOP
// ====================================================

if (
    variable_instance_exists(
        id,
        "alert_beep_voice"
    )
    &&
    alert_beep_voice != -1
)
{
    audio_stop_sound(
        alert_beep_voice
    );

    alert_beep_voice = -1;
}


// ====================================================
// CRT HUM LOOP
// ====================================================

if (
    variable_instance_exists(
        id,
        "crt_hum_voice"
    )
    &&
    crt_hum_voice != -1
)
{
    audio_stop_sound(
        crt_hum_voice
    );

    crt_hum_voice = -1;
}
