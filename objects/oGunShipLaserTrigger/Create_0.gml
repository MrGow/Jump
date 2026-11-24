
/// oGunShipLaserTrigger — Create

// ====================================================
// BASIC SETUP
// ====================================================

depth = -10000;

visible = true;
image_alpha = 0;
image_speed = 0;


// ====================================================
// EDITOR SETTINGS
//
// These can be overridden using Variable Definitions.
// ====================================================

// If false, Gunship position is relative to trigger.
// If true, use absolute room coordinates.

if (!variable_instance_exists(id, "use_absolute_position"))
{
    use_absolute_position = false;
}


// ====================================================
// RELATIVE POSITION
// ====================================================

// Gunship destination relative to trigger origin.

if (!variable_instance_exists(id, "target_offset_x"))
{
    target_offset_x = -180;
}

if (!variable_instance_exists(id, "target_offset_y"))
{
    target_offset_y = -90;
}


// ====================================================
// ABSOLUTE POSITION
// ====================================================

// Only used when use_absolute_position = true.

if (!variable_instance_exists(id, "target_x"))
{
    target_x = 0;
}

if (!variable_instance_exists(id, "target_y"))
{
    target_y = 0;
}


// ====================================================
// FIRING DIRECTION
// ====================================================

//  1 = fire towards right
// -1 = fire towards left

if (!variable_instance_exists(id, "fire_direction"))
{
    fire_direction = 1;
}

fire_direction = (fire_direction < 0) ? -1 : 1;


// ====================================================
// ATTACK TIMINGS
//
// Durations in seconds.
// ====================================================

// Time spent charging after reaching position.

if (!variable_instance_exists(id, "charge_duration"))
{
    charge_duration = 1.15;
}

// Time beam remains active.

if (!variable_instance_exists(id, "fire_duration"))
{
    fire_duration = 0.65;
}

// Time Gunship remains in cooldown afterwards.

if (!variable_instance_exists(id, "recovery_duration"))
{
    recovery_duration = 1.20;
}


// ====================================================
// MOVEMENT
// ====================================================

// Maximum movement speed while travelling
// towards the chosen firing position.

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 5;
}

// Distance from target considered close enough.

if (!variable_instance_exists(id, "arrival_tolerance"))
{
    arrival_tolerance = 3;
}


// ====================================================
// TRIGGER OPTIONS
// ====================================================

// Usually true for the Holotrain.
// Prevents the same trigger firing repeatedly.

if (!variable_instance_exists(id, "trigger_once"))
{
    trigger_once = true;
}

// Show trigger rectangle, target position and
// direction while testing.

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// INTERNAL STATE
// ====================================================

requested = false;
accepted = false;
completed = false;

trigger_ship = noone;

player_was_inside = false;


// ====================================================
// REQUEST DATA
//
// These are calculated on activation.
// ====================================================

request_target_x = x;
request_target_y = y;

request_direction = fire_direction;

request_charge_frames = 0;
request_fire_frames = 0;
request_recovery_frames = 0;

request_move_speed = move_speed;
request_arrival_tolerance = arrival_tolerance;


// ====================================================
// FUNCTIONS
// ====================================================

calculate_target = function()
{
    if (use_absolute_position)
    {
        request_target_x = target_x;
        request_target_y = target_y;
    }
    else
    {
        request_target_x = x + target_offset_x;
        request_target_y = y + target_offset_y;
    }
};
