/// oHazardTimingController — Create

// ====================================================
// EDITOR VARIABLES
// ====================================================

// Hazards connect to a controller with the same group name.
if (!variable_instance_exists(id, "timing_group"))
{
    timing_group = "default";
}

// Start modes:
// "room_start"    = start immediately
// "player_trigger" = wait until another object starts it
// "continuous"     = runs normally and need not reset on death
if (!variable_instance_exists(id, "start_mode"))
{
    start_mode = "room_start";
}

// Most precision challenges should reset when the
// player respawns at the checkpoint.
if (!variable_instance_exists(id, "reset_on_respawn"))
{
    reset_on_respawn = true;
}

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// CLOCK STATE
// ====================================================

clock_frames = 0;

started =
    string_lower(string(start_mode)) !=
    "player_trigger";

// Increments whenever this controller is reset.
// Hazards can detect this and clear one-shot state.
reset_generation = 0;


// ====================================================
// PUBLIC FUNCTIONS
// ====================================================

start_clock = function()
{
    clock_frames = 0;
    reset_generation++;
    started = true;
};

stop_clock = function()
{
    started = false;
};

reset_clock = function()
{
    clock_frames = 0;
    reset_generation++;

    started =
        string_lower(string(start_mode)) !=
        "player_trigger";
};