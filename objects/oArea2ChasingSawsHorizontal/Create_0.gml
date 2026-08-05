/// oArea2ChasingSawsHorizontal — Create


// ====================================================
// ROOM-EDITOR STARTING POSITION
// ====================================================

start_x = x;
start_y = y;


// ====================================================
// CAMERA-RELATIVE POSITION
//
// Calculated automatically from the room-editor
// placement and the vertical chase controller's
// starting camera position.
// ====================================================

screen_offset_x = 0;
screen_offset_y = 0;

screen_offsets_initialized = false;


// ====================================================
// BURST MOVEMENT
//
// Positive burst_offset moves the top saw downward
// into the playable area.
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

// ====================================================
// CONTROLLER RUMBLE
//
// The chase uses short low-frequency pulses rather than
// continuous vibration. Pulse frequency and strength
// increase as the saw approaches the player.
// ====================================================

chase_rumble_timer = 0;

// Distance at which warning pulses begin.
chase_rumble_max_distance = 520;

// Burst activation produces one distinct mechanical jolt.
chase_burst_rumble_low    = 0.30;
chase_burst_rumble_high   = 0.10;
chase_burst_rumble_frames = 7;