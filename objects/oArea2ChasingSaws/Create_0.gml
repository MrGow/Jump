/// oArea2ChasingSaws — Create

// ----------------------------------------------------
// Store original room-editor position
// ----------------------------------------------------
start_x = x;
start_y = y;


// ----------------------------------------------------
// Base position relative to camera
// ----------------------------------------------------
screen_offset_x = 0;
screen_offset_y = 0;


// ----------------------------------------------------
// Burst movement
//
// Positive X moves the left-side saw farther
// into the playable screen.
// ----------------------------------------------------
burst_offset = 0;

burst_active = false;
burst_speed  = 0;
burst_target = 0;


// Used to detect the frame on which a burst begins
burst_was_active = false;


// ----------------------------------------------------
// Chase state
// ----------------------------------------------------
enabled = false;
visible = true;


// ----------------------------------------------------
// Visual burst vibration
//
// These values only affect drawing.
// The object's real position and collision do not shake.
// ----------------------------------------------------
visual_shake_x     = 0;
visual_shake_y     = 0;
visual_shake_angle = 0;

burst_visual_shake_pixels = 2;
burst_visual_angle        = 1.25;


// ----------------------------------------------------
// Burst camera shake
// ----------------------------------------------------
burst_start_shake_strength = 6;
burst_start_shake_frames   = 8;

burst_rumble_strength = 1;
burst_rumble_frames   = 2;


// ----------------------------------------------------
// Saw-loop audio asset
// ----------------------------------------------------
saw_loop_asset =
    asset_get_index(
        "ChasingSawLoop1"
    );


// ----------------------------------------------------
// Playback instance
//
// The loop is not started immediately because a custom
// audio group may still be loading during this Create
// event when the room is launched directly.
// ----------------------------------------------------
saw_loop_id = noone;


// ----------------------------------------------------
// Audio levels
//
// These are additionally affected by audiogroupsfx,
// meaning master and SFX settings still apply.
// ----------------------------------------------------
saw_idle_gain  = 0.32;
saw_chase_gain = 0.72;
saw_burst_gain = 1.00;

saw_idle_pitch  = 0.90;
saw_chase_pitch = 1.00;
saw_burst_pitch = 1.12;


// ----------------------------------------------------
// Current and target audio values
// ----------------------------------------------------
saw_current_gain  = saw_idle_gain;
saw_current_pitch = saw_idle_pitch;

saw_target_gain  = saw_idle_gain;
saw_target_pitch = saw_idle_pitch;

saw_gain_lerp  = 0.08;
saw_pitch_lerp = 0.06;


// ----------------------------------------------------
// Pause state
// ----------------------------------------------------
saw_audio_paused = false;


// ----------------------------------------------------
// Restart the saw audio in its idle state
// ----------------------------------------------------
reset_saw_audio = function()
{
    saw_target_gain  = saw_idle_gain;
    saw_target_pitch = saw_idle_pitch;

    saw_current_gain  = saw_idle_gain;
    saw_current_pitch = saw_idle_pitch;

    if (saw_loop_id != noone)
    {
        audio_sound_gain(
            saw_loop_id,
            saw_idle_gain,
            150
        );

        audio_sound_pitch(
            saw_loop_id,
            saw_idle_pitch
        );
    }
};