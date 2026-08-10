/// oElevatorFallingScrapTrigger — Create


// ====================================================
// EDITOR VARIABLE SAFETY
// ====================================================

if (!variable_instance_exists(id, "scrap_type"))
{
    scrap_type = 1;
}


if (!variable_instance_exists(id, "spawn_offset_x"))
{
    spawn_offset_x = 0;
}


if (!variable_instance_exists(id, "spawn_height"))
{
    spawn_height = 80;
}


if (!variable_instance_exists(id, "initial_fall_speed"))
{
    initial_fall_speed = 1.5;
}


if (!variable_instance_exists(id, "fall_acceleration"))
{
    fall_acceleration = 0.08;
}


if (!variable_instance_exists(id, "max_fall_speed"))
{
    max_fall_speed = 7;
}


if (!variable_instance_exists(id, "rotation_speed"))
{
    rotation_speed = 0;
}


// ====================================================
// STATE
// ====================================================

activated = false;


// ====================================================
// TRIGGER VISIBILITY
//
// Invisible in-game.
// Still visible in the GameMaker room editor.
// ====================================================

visible = false;