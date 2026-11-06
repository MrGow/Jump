/// oScrapChiefElevatorStartTrigger — Create

activated = false;


// ====================================================
// TRIGGER SIZE
// ====================================================

if (!variable_instance_exists(id, "trigger_width"))
{
    trigger_width = 160;
}

if (!variable_instance_exists(id, "trigger_height"))
{
    trigger_height = 96;
}


// ====================================================
// REQUIRE PLAYER STANDING ON PLATFORM
// ====================================================

require_platform = true;


// ====================================================
// REFERENCES
// ====================================================

controller = noone;
platform = noone;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;