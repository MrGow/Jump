/// oScrapChiefController — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    platform_move_x = 0;
    exit;
}


// ====================================================
// PLATFORM SAFETY
// ====================================================

if (!instance_exists(platform))
{
    platform = instance_find(
        oScrapChiefElevator,
        0
    );
}

if (!instance_exists(platform))
{
    platform_move_x = 0;
    exit;
}


// ====================================================
// WAITING
// ====================================================

if (elevator_state == 0)
{
    platform_move_x = 0;
    exit;
}


// ====================================================
// COMPLETE
//
// Elevator has finished docking.
// Normal player-following camera takes over.
// ====================================================

if (elevator_state == 11)
{
    platform_move_x = 0;
    exit;
}


// ====================================================
// TIMERS
// ====================================================

total_timer++;
state_timer--;


// ====================================================
// MOVEMENT STATES
// ====================================================

var should_move =
    elevator_state == 2 ||
    elevator_state == 3 ||
    elevator_state == 5 ||
    elevator_state == 7 ||
    elevator_state == 10;


// ====================================================
// MOVEMENT COMMAND
// ====================================================

if (should_move)
{
    target_speed = base_speed;
    current_speed = base_speed;

    var remaining =
        end_platform_x - platform.x;

    platform_move_x = min(
        current_speed,
        max(0, remaining)
    );
}
else
{
    target_speed = 0;
    current_speed = 0;

    platform_move_x = 0;
}


// ====================================================
// STARTUP ENGAGEMENT
// ====================================================

if (
    elevator_state == 1 &&
    state_timer <= 0
)
{
    platform.jolt_strength =
        engage_jolt_strength;

    platform.jolt_timer =
        engage_jolt_frames;
}


// ====================================================
// ADVANCE STAGES
// ====================================================

if (state_timer <= 0)
{
    if (elevator_state < 10)
    {
        set_state(elevator_state + 1);
    }
    else if (elevator_state == 10)
    {
        var remaining =
            end_platform_x - platform.x;

        if (remaining > 0.001)
        {
            // Finish the remaining distance first.
            platform_move_x = remaining;
        }
        else
        {
            platform_move_x = 0;

            sequence_complete = true;

            set_state(11);
        }
    }
}