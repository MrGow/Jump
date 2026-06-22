/// scr_pause_blocked

function scr_pause_blocked()
{
    return variable_global_exists("game_phase") && global.game_phase == "paused";
}