/// oCodec — Clean Up


// ====================================================
// STOP RING AUDIO
// ====================================================

if (
    variable_instance_exists(
        id,
        "codec_call_voice"
    ) &&
    codec_call_voice != noone
)
{
    if (
        audio_is_playing(
            codec_call_voice
        )
    )
    {
        audio_stop_sound(
            codec_call_voice
        );
    }


    codec_call_voice =
        noone;
}


// ====================================================
// STOP OPEN AUDIO
// ====================================================

if (
    variable_instance_exists(
        id,
        "codec_open_voice"
    ) &&
    codec_open_voice != noone
)
{
    if (
        audio_is_playing(
            codec_open_voice
        )
    )
    {
        audio_stop_sound(
            codec_open_voice
        );
    }


    codec_open_voice =
        noone;
}


// ====================================================
// STOP CLOSE AUDIO
// ====================================================

if (
    variable_instance_exists(
        id,
        "codec_close_voice"
    ) &&
    codec_close_voice != noone
)
{
    if (
        audio_is_playing(
            codec_close_voice
        )
    )
    {
        audio_stop_sound(
            codec_close_voice
        );
    }


    codec_close_voice =
        noone;
}


// ====================================================
// STOP B1LL-E CODEC SPEECH
// ====================================================

if (
    variable_instance_exists(
        id,
        "bille_codec_voice"
    ) &&
    bille_codec_voice != noone
)
{
    if (
        audio_is_playing(
            bille_codec_voice
        )
    )
    {
        audio_stop_sound(
            bille_codec_voice
        );
    }


    bille_codec_voice =
        noone;
}


// ====================================================
// SAFETY — RELEASE GAME
// ====================================================

if (
    variable_global_exists(
        "game_phase"
    ) &&
    global.game_phase ==
        "codec"
)
{
    global.game_phase =
        "playing";
}