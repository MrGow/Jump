/// oTrainRoofCameraFX — Create

visible = false;


// ====================================================
// ENABLE
// ====================================================

enabled = true;


// ====================================================
// OUTPUT
//
// oCamera reads these values.
//
// These are VISUAL camera offsets only.
// They do not move the player, platforms or collision.
// ====================================================

offset_x = 0;
offset_y = 0;


// ====================================================
// SLOW TRAIN SWAY
//
// Keep this subtle because JumpBot requires precision.
// ====================================================

sway_time = random(1000);

sway_speed_x = 0.025;
sway_speed_y = 0.041;

sway_amount_x = 1.25;
sway_amount_y = 0.75;


// ====================================================
// SMALL MECHANICAL VIBRATION
//
// This represents the train constantly rattling along
// the track.
//
// Because the camera is pixel based, we accumulate
// mostly sub-pixel-looking movement and round the final
// result.
// ====================================================

vibration_time = random(1000);

vibration_speed = 0.32;

vibration_amount_x = 0.40;
vibration_amount_y = 0.65;


// Random tiny impulses.
//
// Do not change every frame or it will look like
// conventional screen shake.
micro_jitter_x = 0;
micro_jitter_y = 0;

micro_jitter_timer = 0;

micro_jitter_interval_min = 5;
micro_jitter_interval_max = 11;


// ====================================================
// LARGE TRACK JOLTS
// ====================================================

auto_jolts = true;


// Roughly every 4–9 seconds.
jolt_interval_min =
    room_speed * 9;

jolt_interval_max =
    room_speed * 16;


next_jolt_timer =
    irandom_range(
        jolt_interval_min,
        jolt_interval_max
    );


// ----------------------------------------------------
// Jolt strength
// ----------------------------------------------------

jolt_strength_x = 6.0;
jolt_strength_y = 11.0;


// Duration in frames.
jolt_duration = 20;

jolt_timer = 0;


// Current jolt amplitude.
jolt_current_x = 0;
jolt_current_y = 0;


// Initial direction.
jolt_direction_x = 1;
jolt_direction_y = 1;


// Oscillation during settling.
jolt_wave_speed = 0.90;


// ====================================================
// SOUND
// ====================================================

snd_train_bump =
    TrainExteriorBump;

train_bump_gain = 0.80;


// ====================================================
// MANUAL JOLT FUNCTION
//
// Later a trigger/scripted train event can call:
//
// train_fx.do_big_jolt();
//
// without waiting for the random timer.
// ====================================================

do_big_jolt = function()
{
    jolt_timer =
        jolt_duration;


    // Usually a strong vertical track bump with a
    // smaller sideways kick.
    jolt_direction_x =
        choose(
            -1,
            1
        );

    jolt_direction_y =
        choose(
            -1,
            1
        );


    jolt_current_x =
        jolt_strength_x *
        jolt_direction_x;

    jolt_current_y =
        jolt_strength_y *
        jolt_direction_y;


    // ------------------------------------------------
    // Sound
    // ------------------------------------------------

    if (
        snd_train_bump != -1 &&
        audio_group_is_loaded(
            audiogroupsfx
        )
    )
    {
        scr_play_sfx(
            snd_train_bump,
            train_bump_gain,
            random_range(
                0.97,
                1.03
            )
        );
    }


    // ------------------------------------------------
    // Choose next irregular bump
    // ------------------------------------------------

    next_jolt_timer =
        irandom_range(
            jolt_interval_min,
            jolt_interval_max
        );
};