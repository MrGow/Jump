// ============================================================================
// oGame — Clean Up OPTIONAL MERGE BLOCK
// ============================================================================

/// oGame — Clean Up
//
// ONLY add this if oGame already has a Clean Up event;
// merge this section into it rather than replacing
// unrelated cleanup code.

if (
    variable_instance_exists(
        id,
        "teleporter_static_loop_instance"
    )
    &&
    teleporter_static_loop_instance != -1
    &&
    audio_is_playing(
        teleporter_static_loop_instance
    )
)
{
    audio_stop_sound(
        teleporter_static_loop_instance
    );

    teleporter_static_loop_instance =
        -1;
}
