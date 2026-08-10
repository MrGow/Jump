/// oArea1ElevatorController — Step


// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    platform_move_y = 0;
    exit;
}


// ====================================================
// REFRESH PLATFORM
// ====================================================

if (!instance_exists(platform))
{
    platform =
        instance_find(
            oArea1ElevatorPlatform,
            0
        );
}


if (!instance_exists(platform))
{
    platform_move_y = 0;
    exit;
}


// ====================================================
// WAITING
// ====================================================

if (elevator_state == 0)
{
    platform_move_y = 0;
    exit;
}


// ====================================================
// STARTUP PAUSE
// ====================================================

if (elevator_state == 1)
{
    platform_move_y = 0;

    startup_timer--;


    if (startup_timer <= 0)
    {
        elevator_state = 2;

        target_speed =
            base_speed;


        // --------------------------------------------
        // Machinery engages and the lift begins moving.
        // --------------------------------------------

        if (instance_exists(platform))
        {
            platform.jolt_strength =
                engage_jolt_strength;

            platform.jolt_timer =
                engage_jolt_frames;
        }
    }

    exit;
}


// ====================================================
// ASCENDING
// ====================================================

if (elevator_state == 2)
{
    var distance_remaining =
        platform.y -
        end_platform_y;


    // ------------------------------------------------
    // Begin final slowdown
    // ------------------------------------------------

    if (
        distance_remaining <=
        finish_slow_distance
    )
    {
        elevator_state = 3;

        target_speed =
            finish_speed;
    }
    else
    {
        target_speed =
            base_speed;
    }


    // ------------------------------------------------
    // Smooth acceleration
    // ------------------------------------------------

    current_speed =
        lerp(
            current_speed,
            target_speed,
            speed_lerp
        );


    // ------------------------------------------------
    // Move upward
    // ------------------------------------------------

    platform_move_y =
        -current_speed;

    exit;
}


// ====================================================
// FINISHING
// ====================================================

if (elevator_state == 3)
{
    current_speed =
        lerp(
            current_speed,
            finish_speed,
            0.05
        );


    var move_amount =
        current_speed;


    var remaining =
        platform.y -
        end_platform_y;


    // ------------------------------------------------
    // Stop exactly at destination
    // ------------------------------------------------

    if (
        remaining <=
        move_amount
    )
    {
        platform_move_y =
            -remaining;

        elevator_state = 4;

        sequence_complete = true;
    }
    else
    {
        platform_move_y =
            -move_amount;
    }

    exit;
}


// ====================================================
// COMPLETE
// ====================================================

if (elevator_state == 4)
{
    platform_move_y = 0;

    current_speed = 0;
    target_speed  = 0;
}