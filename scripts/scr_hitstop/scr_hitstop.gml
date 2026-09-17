/// scr_hitstop(_frames)

function scr_hitstop(_frames)
{
    if (!variable_global_exists("hitstop_frames"))
    {
        global.hitstop_frames = 0;
    }

    _frames = max(0, round(_frames));

    // Don't let a weaker hit shorten an existing stronger hitstop.
    global.hitstop_frames =
        max(
            global.hitstop_frames,
            _frames
        );
}