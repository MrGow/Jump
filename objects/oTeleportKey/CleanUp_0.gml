/// oTeleportKey — Clean Up

if (
    variable_instance_exists(
        id,
        "key_stop_loop"
    )
)
{
    key_stop_loop();
}


if (
    variable_instance_exists(
        id,
        "key_audio_emitter"
    )
    &&
    key_audio_emitter >= 0
)
{
    audio_emitter_free(
        key_audio_emitter
    );

    key_audio_emitter =
        -1;
}