/// oArea1ElevatorActivationTrigger — Create


// ====================================================
// STATE
// ====================================================

activated = false;


// ====================================================
// TRIGGER SIZE
//
// Place this rectangle around the section of platform
// where the player must stand to begin.
//
// Origin effectively acts as Middle Centre.
// ====================================================

if (!variable_instance_exists(id, "trigger_width"))
{
    trigger_width = 160;
}

if (!variable_instance_exists(id, "trigger_height"))
{
    trigger_height = 96;
}


// Require the player to actually be standing on the
// elevator instead of merely passing through trigger.
if (!variable_instance_exists(id, "require_platform"))
{
    require_platform = true;
}


// ====================================================
// REFERENCES
// ====================================================

controller =
    instance_find(
        oArea1ElevatorController,
        0
    );

platform =
    instance_find(
        oArea1ElevatorPlatform,
        0
    );


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;