/// scr_pause_blocked


function scr_pause_blocked()
{
    // ====================================================
    // GLOBAL PHASE BLOCKS
    // ====================================================

    if (variable_global_exists("game_phase"))
    {
        if (
            global.game_phase == "paused"      ||
            global.game_phase == "menu"        ||
            global.game_phase == "main_menu"   ||
            global.game_phase == "death_delay" ||
            global.game_phase == "death_menu"  ||
            global.game_phase == "codec"
        )
        {
            return true;
        }
    }


    // ====================================================
    // B1LL-E DIALOGUE
    //
    // Regular B1LL-E conversations are deliberately short,
    // so pause is disabled until the conversation finishes.
    //
    // This avoids:
    //
    // - dialogue drawing over pause menu
    // - Space/A resuming and advancing dialogue together
    // - input ownership conflicts
    // ====================================================

    if (instance_exists(oB1LL))
    {
        var bille =
            instance_find(
                oB1LL,
                0
            );


        if (
            bille != noone &&
            variable_instance_exists(
                bille,
                "dialogue_active"
            ) &&
            bille.dialogue_active
        )
        {
            return true;
        }
    }


    return false;
}