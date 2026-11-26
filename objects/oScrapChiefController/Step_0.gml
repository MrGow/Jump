
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

    reset_phase1_attacks();
    reset_phase1_spitting();

    exit;
}


// ====================================================
// COMPLETE
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
// ELEVATOR MOVEMENT
// ====================================================

var should_move =
    elevator_state == 2 ||
    elevator_state == 3 ||
    elevator_state == 5 ||
    elevator_state == 7 ||
    elevator_state == 10;

if (should_move)
{
    target_speed = base_speed;

    current_speed = base_speed;

    var remaining =
        end_platform_x -
        platform.x;

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
// STARTUP JOLT
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
// PHASE 1 — DEMOLITION AND SPITTING
// ====================================================

if (
    elevator_state == 3 &&
    boss_active
)
{
    update_phase1_attacks();

    update_phase1_spitting();
}


// ====================================================
// SHARED FORMATION MOVEMENT
// ====================================================

if (formation_active)
{
    update_formation();
}


// ====================================================
// STATE TRANSITIONS
// ====================================================

if (state_timer <= 0)
{
    if (elevator_state < 10)
    {
        if (elevator_state == 3)
        {
            formation_target_x = 0;

            if (!phase1_demolition_complete)
            {
                show_debug_message(
                    "SCRAP CHIEF: WARNING - Phase 1 ended before demolition routine completed."
                );
            }

            if (instance_exists(phase1_attacking_ball))
            {
                if (
                    phase1_attacking_ball.slam_state != 0 &&
                    phase1_attacking_ball.slam_state != 4
                )
                {
                    phase1_attacking_ball.begin_slam_retraction();
                }
            }


            // ------------------------------------
            // Spitting completion warning
            // ------------------------------------

            if (!phase1_spitting_complete)
            {
                show_debug_message(
                    "SCRAP CHIEF: WARNING - Phase 1 ended before spitting routine completed."
                );
            }
        }

        set_state(
            elevator_state + 1
        );
    }
    else if (elevator_state == 10)
    {
        var remaining =
            end_platform_x -
            platform.x;

        if (remaining > 0.001)
        {
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
