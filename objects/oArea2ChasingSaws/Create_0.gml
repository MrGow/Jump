/// oArea2ChasingSaws — Create

// ====================================================
// ROOM-EDITOR STARTING POSITION
//
// You can reposition the saw assembly in the room
// editor. Its camera-relative offset will be calculated
// automatically from this position.
// ====================================================

start_x = x;
start_y = y;


// ====================================================
// CAMERA-RELATIVE POSITION
//
// These will be calculated once the horizontal chase
// controller exists.
//
// Do not manually set these unless you specifically
// want an additional code-controlled offset.
// ====================================================

screen_offset_x = 0;
screen_offset_y = 0;

screen_offsets_initialized = false;


// ====================================================
// BURST MOVEMENT
//
// Positive burst_offset moves the left-side saw farther
// into the visible play area.
// ====================================================

burst_offset = 0;

burst_active = false;
burst_speed  = 0;
burst_target = 0;

burst_was_active = false;


// ====================================================
// CHASE STATE
// ====================================================

enabled = false;
visible = true;


// ====================================================
// BURST VISUAL SHAKE
// ====================================================

visual_shake_x     = 0;
visual_shake_y     = 0;
visual_shake_angle = 0;

burst_visual_shake_pixels = 2;
burst_visual_angle = 0.75;


// ====================================================
// CAMERA SHAKE
// ====================================================

burst_start_shake_strength = 5;
burst_start_shake_frames   = 10;

burst_rumble_strength = 2;
burst_rumble_frames   = 2;


// ====================================================
// SAW LOOP AUDIO
// ====================================================

saw_loop_asset =
    asset_get_index(
        "ChasingSawLoop1"
    );

saw_loop_id = noone;
saw_audio_paused = false;


// ----------------------------------------------------
// Base gain/pitch states
// ----------------------------------------------------

saw_idle_gain  = 0.18;
saw_chase_gain = 0.60;
saw_burst_gain = 0.90;

saw_idle_pitch  = 0.92;
saw_chase_pitch = 1.00;
saw_burst_pitch = 1.10;


// ----------------------------------------------------
// Current and target values
// ----------------------------------------------------

saw_current_gain  = saw_idle_gain;
saw_target_gain   = saw_idle_gain;

saw_current_pitch = saw_idle_pitch;
saw_target_pitch  = saw_idle_pitch;


// ----------------------------------------------------
// Smoothing
// ----------------------------------------------------

saw_gain_lerp  = 0.08;
saw_pitch_lerp = 0.08;