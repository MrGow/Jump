/// oCodec — Clean Up


// ====================================================
// STOP CALL AUDIO
// ====================================================

if (
    variable_instance_exists(
        id,
        "codec_call_voice"
    ) &&
    codec_call_voice != noone
)
{
    audio_stop_sound(
        codec_call_voice
    );

    codec_call_voice =
        noone;
}


// ====================================================
// SAFETY — RELEASE GAME
// ====================================================

if (
    variable_global_exists(
        "game_phase"
    ) &&
    global.game_phase == "codec"
)
{
    global.game_phase =
        "playing";
}