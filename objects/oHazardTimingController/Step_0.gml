/// oHazardTimingController — Step

if (!enabled)
{
    exit;
}

if (!started)
{
    exit;
}

if (scr_game_frozen())
{
    exit;
}

clock_frames++;