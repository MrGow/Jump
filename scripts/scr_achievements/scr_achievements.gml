/// scr_achievements

function scr_achievements_available()
{
    // Keep achievements disabled until Steam integration is ready.
    return false;
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
    // Debug/testing only.
    if (!scr_achievements_available()) {
        return false;
    }

    steam_clear_achievement(_api_name);
    steam_store_stats();

    return true;
}