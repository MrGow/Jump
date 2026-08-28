/// oArea1ElevatorPlatform — Step


// ====================================================
// KEEP SURFACE CURRENT
// ====================================================

surface_y =
    bbox_top;


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    dx = 0;
    dy = 0;

    visual_shake_x = 0;
    visual_shake_y = 0;


    // ------------------------------------------------
    // Pause movement loop while game is frozen.
    // ------------------------------------------------

    if (
        rising_loop_instance != noone &&
        !rising_loop_paused
    )
    {
        audio_pause_sound(
            rising_loop_instance
        );

        rising_loop_paused = true;
    }


    exit;
}


// ====================================================
// RESUME LOOP AFTER FREEZE
// ====================================================

if (
    rising_loop_instance != noone &&
    rising_loop_paused
)
{
    audio_resume_sound(
        rising_loop_instance
    );

    rising_loop_paused = false;
}


// ====================================================
// IS ELEVATOR CURRENTLY MOVING?
// ====================================================

var elevator_moving =
    abs(dy) > 0.01;


// ====================================================
// ELEVATOR MOVEMENT AUDIO
// ====================================================

if (elevator_moving)
{
    // ------------------------------------------------
    // Start loop when movement begins.
    // ------------------------------------------------

    if (
        rising_loop_instance == noone &&
        snd_rising_loop != -1 &&
        audio_group_is_loaded(
            audiogroupsfx
        )
    )
    {
        rising_loop_instance =
            audio_play_sound(
                snd_rising_loop,
                rising_loop_priority,
                true
            );


        if (
            rising_loop_instance != noone
        )
        {
            audio_sound_gain(
                rising_loop_instance,
                rising_loop_gain,
                0
            );
        }
    }
}
else
{
    // ------------------------------------------------
    // Elevator stopped.
    // ------------------------------------------------

    if (
        rising_loop_instance != noone
    )
    {
        audio_stop_sound(
            rising_loop_instance
        );

        rising_loop_instance =
            noone;
    }


    rising_loop_paused =
        false;
}


// ====================================================
// TEMPORARY JOLT
//
// Startup / machinery engagement jolts take priority
// over the normal engine vibration.
// ====================================================

if (jolt_timer > 0)
{
    jolt_timer--;


    visual_shake_x =
        irandom_range(
            -jolt_strength,
            jolt_strength
        );


    visual_shake_y =
        irandom_range(
            -jolt_strength,
            jolt_strength
        );


    if (jolt_timer <= 0)
    {
        jolt_timer = 0;
        jolt_strength = 0;

        visual_shake_x = 0;
        visual_shake_y = 0;
    }


    exit;
}


// ====================================================
// NORMAL ENGINE VIBRATION
// ====================================================

if (elevator_moving)
{
    engine_shake_timer--;


    if (engine_shake_timer <= 0)
    {
        engine_shake_timer =
            engine_shake_interval;


        visual_shake_x =
            irandom_range(
                -engine_shake_x,
                engine_shake_x
            );


        visual_shake_y =
            irandom_range(
                -engine_shake_y,
                engine_shake_y
            );
    }
}
else
{
    engine_shake_timer = 0;

    visual_shake_x = 0;
    visual_shake_y = 0;
}