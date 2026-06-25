/// scr_game_frozen
/// Returns true when gameplay objects should freeze.

function scr_game_frozen()
{
    if (!variable_global_exists("game_phase")) {
        return false;
    }

    return (
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu"
    );
}