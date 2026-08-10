/// oMovingPlatformCrane — Step


// ====================================================
// RUN NORMAL MOVING PLATFORM STEP
// ====================================================

event_inherited();


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    visual_shake_x = 0;
    visual_shake_y = 0;

    engine_shake_timer = 0;

    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    visual_shake_x = 0;
    visual_shake_y = 0;

    engine_shake_timer = 0;

    exit;
}


// ====================================================
// IS THE CRANE ACTUALLY MOVING?
//
// dx/dy were calculated by oMovingPlatform Begin Step.
// ====================================================

var crane_moving =
    abs(dx) > 0.01 ||
    abs(dy) > 0.01;


// ====================================================
// ENGINE VIBRATION
// ====================================================

if (crane_moving)
{
    engine_shake_timer--;


    if (engine_shake_timer <= 0)
    {
        engine_shake_timer =
            engine_shake_interval;


        // Primarily vertical vibration.
        visual_shake_x =
            engine_shake_x > 0
            ? irandom_range(
                -engine_shake_x,
                engine_shake_x
            )
            : 0;


        visual_shake_y =
            engine_shake_y > 0
            ? irandom_range(
                -engine_shake_y,
                engine_shake_y
            )
            : 0;
    }
}
else
{
    // Platform is sitting at one of its endpoints.
    engine_shake_timer = 0;

    visual_shake_x = 0;
    visual_shake_y = 0;
}