/// oArea3ChasingCaterpillar — Create


// ====================================================
// SPRITES
// ====================================================

head_sprite =
    asset_get_index(
        "spriteChasingMillipedeHead"
    );

body_sprite =
    asset_get_index(
        "spriteChasingMillipedeBody"
    );


// The object draws the complete creature manually.
sprite_index = -1;
mask_index   = -1;

image_speed = 0;


// ====================================================
// ROOM-EDITOR STARTING POSITION
//
// Place the object at the top-centre position of the
// caterpillar head.
// ====================================================

start_x = x;
start_y = y;


// ====================================================
// CAMERA-RELATIVE POSITION
//
// Calculated automatically from the room-editor
// position and upward chase controller.
// ====================================================

screen_offset_x = 0;
screen_offset_y = 0;

screen_offsets_initialized = false;


// ====================================================
// COMPOSITE BODY
// ====================================================

// Number of repeated body sections.
body_segment_count = 8;


// ----------------------------------------------------
// Head positioning
// ----------------------------------------------------

head_draw_offset_x = 0;
head_draw_offset_y = 0;


// ----------------------------------------------------
// First body section positioning
//
// This controls only the connection between the head
// and the first body section.
// ----------------------------------------------------

body_draw_offset_x = 0;
body_draw_offset_y = -24;


// ----------------------------------------------------
// Body-to-body spacing
//
// This is the distance from the top of one body section
// to the top of the next.
//
// It does not use the complete sprite height because
// the exported artwork contains transparent vertical
// space.
//
// Lower value = tighter overlap.
// Higher value = farther apart.
// ----------------------------------------------------

body_segment_step = 48;


// ====================================================
// MANUAL ANIMATION
// ====================================================

head_anim_position = 0;
body_anim_position = 0;


// Normal animation speeds.
head_anim_speed_normal = 0.30;
body_anim_speed_normal = 0.22;


// Faster during bursts.
head_anim_speed_burst = 0.55;
body_anim_speed_burst = 0.38;


// Current animation speeds.
head_anim_speed_current =
    head_anim_speed_normal;

body_anim_speed_current =
    body_anim_speed_normal;


// Smooth speed changes.
anim_speed_lerp = 0.15;


// Different body sections use different frames so all
// legs do not move in perfect synchronisation.
body_phase_offset = 2;


// ====================================================
// BURST MOVEMENT
//
// Positive burst_offset moves the creature upward into
// the visible play area.
// ====================================================

burst_offset = 0;

burst_active = false;
burst_speed  = 0;
burst_target = 0;

burst_was_active = false;


// ====================================================
// BURST VISUAL VIBRATION
// ====================================================

visual_shake_x = 0;
visual_shake_y = 0;

burst_visual_shake_pixels = 2;


// ====================================================
// CAMERA SHAKE
// ====================================================

burst_start_shake_strength = 5;
burst_start_shake_frames   = 10;

burst_rumble_strength = 2;
burst_rumble_frames   = 2;


// ====================================================
// CHASE STATE
// ====================================================

enabled = false;

// Visible and lethal before activation.
visible = true;


// ====================================================
// COLLISION TUNING
//
// The creature is drawn manually, so collision is also
// calculated manually.
// ====================================================

// Head trimming.
head_collision_inset_left   = 10;
head_collision_inset_right  = 10;
head_collision_inset_top    = 3;
head_collision_inset_bottom = 4;


// Body trimming.
body_collision_inset_left   = 12;
body_collision_inset_right  = 12;
body_collision_inset_top    = 2;
body_collision_inset_bottom = 2;


// Debug collision boxes.
debug_draw = false;