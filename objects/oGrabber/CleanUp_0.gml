/// oGrabber — Clean Up

grabber_stop_move_loop();

if (
    variable_instance_exists(id, "grabber_audio_emitter")
    &&
    grabber_audio_emitter >= 0
)
{
    audio_emitter_free(
        grabber_audio_emitter
    );

    grabber_audio_emitter = -1;
}

if (
    variable_instance_exists(id, "grabbed_player")
    &&
    instance_exists(grabbed_player)
    &&
    variable_instance_exists(
        grabbed_player,
        "grabbed_by"
    )
    &&
    grabbed_player.grabbed_by == id
)
{
    grabbed_player.grabbed_by = noone;
}
