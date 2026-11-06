/// oScrapChiefElevator — Step

surface_y = bbox_top;


// ====================================================
// GAME FREEZE
// ====================================================

if (scr_game_frozen())
{
    dx = 0;
    dy = 0;

    visual_shake_x = 0;
    visual_shake_y = 0;

    if (
        elevator_loop_instance != noone &&
        !elevator_loop_paused
    )
    {
        audio_pause_sound(
            elevator_loop_instance
        );

        elevator_loop_paused = true;
    }

    exit;
}


// ====================================================
// RESUME AUDIO
// ====================================================

if (
    elevator_loop_instance != noone &&
    elevator_loop_paused
)
{
    audio_resume_sound(
        elevator_loop_instance
    );

    elevator_loop_paused = false;
}


// ====================================================
// MOVEMENT CHECK
// ====================================================

var elevator_moving = abs(dx) > 0.01;


// ====================================================
// MOVEMENT SOUND
// ====================================================

if (elevator_moving)
{
    if (
        elevator_loop_instance == noone &&
        snd_elevator_loop != -1 &&
        audio_group_is_loaded(audiogroupsfx)
    )
    {
        elevator_loop_instance = audio_play_sound(
            snd_elevator_loop,
            elevator_loop_priority,
            true
        );

        if (elevator_loop_instance != noone)
        {
            audio_sound_gain(
                elevator_loop_instance,
                elevator_loop_gain,
                0
            );
        }
    }
}
else
{
    if (elevator_loop_instance != noone)
    {
        audio_stop_sound(
            elevator_loop_instance
        );

        elevator_loop_instance = noone;
    }

    elevator_loop_paused = false;
}


// ====================================================
// TEMPORARY JOLTS
// ====================================================

if (jolt_timer > 0)
{
    jolt_timer--;

    visual_shake_x = irandom_range(
        -jolt_strength,
        jolt_strength
    );

    visual_shake_y = irandom_range(
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
        engine_shake_timer = engine_shake_interval;

        visual_shake_x = irandom_range(
            -engine_shake_x,
            engine_shake_x
        );

        visual_shake_y = irandom_range(
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