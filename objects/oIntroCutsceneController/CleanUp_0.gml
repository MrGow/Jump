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