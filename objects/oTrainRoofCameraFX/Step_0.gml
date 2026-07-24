/// oTrainRoofCameraFX — Step

// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    offset_x = 0;
    offset_y = 0;

    exit;
}


// ====================================================
// FREEZE
//
// Keep the camera at its current offset when the rest
// of the game freezes.
//
// This prevents the train continuing to sway behind the
// death screen or pause menu.
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// SLOW TRAIN SWAY
// ====================================================

sway_time += 1;


var sway_x =
    sin(
        sway_time *
        sway_speed_x
    )
    *
    sway_amount_x;


var sway_y =
    sin(
        sway_time *
        sway_speed_y
    )
    *
    sway_amount_y;


// ====================================================
// CONSTANT TRACK VIBRATION
//
// Uses different frequencies so it doesn't look like
// one perfectly repeating sine wave.
// ====================================================

vibration_time +=
    vibration_speed;


var vibration_x =
    sin(
        vibration_time *
        1.71
    )
    *
    vibration_amount_x;


var vibration_y =
    sin(
        vibration_time *
        2.43
    )
    *
    vibration_amount_y;


// ====================================================
// OCCASIONAL MICRO JITTER
// ====================================================

micro_jitter_timer--;


if (micro_jitter_timer <= 0)
{
    micro_jitter_timer =
        irandom_range(
            micro_jitter_interval_min,
            micro_jitter_interval_max
        );


    micro_jitter_x =
        random_range(
            -0.45,
            0.45
        );


    micro_jitter_y =
        random_range(
            -0.65,
            0.65
        );
}
else
{
    // Gradually settle instead of generating completely
    // new random camera noise every frame.
    micro_jitter_x *= 0.82;
    micro_jitter_y *= 0.82;
}


// ====================================================
// AUTOMATIC LARGE JOLTS
// ====================================================

if (
    auto_jolts &&
    jolt_timer <= 0
)
{
    next_jolt_timer--;


    if (next_jolt_timer <= 0)
    {
        do_big_jolt();
    }
}


// ====================================================
// LARGE JOLT
// ====================================================

var big_jolt_x = 0;
var big_jolt_y = 0;


if (jolt_timer > 0)
{
    // 1 at beginning -> 0 at end.
    var progress =
        jolt_timer /
        max(
            1,
            jolt_duration
        );


    // Strong initial impact which rapidly loses power.
    var strength =
        progress *
        progress;


    var elapsed =
        jolt_duration -
        jolt_timer;


    // Oscillating settling motion.
    var wave =
        cos(
            elapsed *
            jolt_wave_speed
        );


    big_jolt_x =
        jolt_current_x *
        strength *
        wave;


    big_jolt_y =
        jolt_current_y *
        strength *
        wave;


    jolt_timer--;
}


// ====================================================
// FINAL TRAIN OFFSET
// ====================================================

offset_x =
    sway_x +
    vibration_x +
    micro_jitter_x +
    big_jolt_x;


offset_y =
    sway_y +
    vibration_y +
    micro_jitter_y +
    big_jolt_y;