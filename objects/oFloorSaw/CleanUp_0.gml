// ============================================================================
// oFloorSaw — Clean Up
// ============================================================================

/// oFloorSaw — Clean Up

stop_saw_audio();

if (saw_emitter >= 0)
{
    audio_emitter_free(saw_emitter);
    saw_emitter = -1;
}