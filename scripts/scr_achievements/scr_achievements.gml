/// scr_achievements

function scr_achievements_available()
{
    return steam_initialised();
}

function scr_achievement_unlock(_api_name)
{
    if (!scr_achievements_available()) {
        return false;
    }

    steam_set_achievement(_api_name);
    steam_store_stats();

    return true;
}

function scr_achievement_clear(_api_name)
{
    // Debug/testing only. Do not use in the finished game.
    if (!scr_achievements_available()) {
        return false;
    }

    steam_clear_achievement(_api_name);
    steam_store_stats();

    return true;
}