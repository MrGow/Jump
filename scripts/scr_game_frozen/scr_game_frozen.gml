/// scr_game_frozen

function scr_game_frozen()
{
    // ====================================================
    // HITSTOP
    // ====================================================

    if (
        variable_global_exists("hitstop_frames")
        &&
        global.hitstop_frames > 0
    )
    {
        return true;
    }


    // ====================================================
    // NORMAL GAME FREEZE STATES
    // ====================================================

    if (!variable_global_exists("game_phase"))
    {
        return false;
    }


    return (
        global.game_phase == "paused"      ||
        global.game_phase == "menu"        ||
        global.game_phase == "death_delay" ||
        global.game_phase == "death_menu"  ||
        global.game_phase == "codec"
    );
}