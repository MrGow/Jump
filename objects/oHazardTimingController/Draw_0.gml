/// oHazardTimingController — Draw

if (!debug_draw)
{
    exit;
}

draw_set_color(c_white);

draw_text(
    x,
    y,
    "Timing Group: " +
    string(timing_group) +
    "\nClock: " +
    string(clock_frames) +
    "\nStarted: " +
    string(started) +
    "\nGeneration: " +
    string(reset_generation)
);