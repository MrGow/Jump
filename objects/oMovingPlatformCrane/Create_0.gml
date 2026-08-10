/// oMovingPlatformCrane — Create


// ====================================================
// PARENT MOVING PLATFORM
// ====================================================

event_inherited();


// ====================================================
// SPRITE / MASK
// ====================================================

sprite_index =
    spriteMovingPlatformCrane;

mask_index =
    spriteMovingPlatformCrane;

image_speed = 0;


// ====================================================
// CRANE PLATFORM LOOP SFX
// ====================================================

snd_moving_platform_loop =
    asset_get_index(
        "MovingPlatformCraneLoop1"
    );

moving_platform_loop_gain = 0.28;
moving_platform_loop_pitch = 1.0;

moving_platform_loop_inner_dist = 120;
moving_platform_loop_outer_dist = 420;


// ====================================================
// VISUAL ENGINE SHAKE
//
// VISUAL ONLY.
//
// The platform's real x/y and collision mask do not
// shake, so this cannot affect platforming.
// ====================================================

visual_shake_x = 0;
visual_shake_y = 0;


// ----------------------------------------------------
// Subtle vibration.
//
// Since this is pixel art, keep the strength at a
// whole pixel and control subtlety through frequency.
// ----------------------------------------------------

engine_shake_x = 0;
engine_shake_y = 1;


// Higher = calmer / less frequent.
engine_shake_interval = 5;

engine_shake_timer = 0;


// ====================================================
// REFRESH PREVIOUS BOUNDS AFTER SPRITE SWAP
// ====================================================

prev_left   = bbox_left;
prev_right  = bbox_right;
prev_top    = bbox_top;
prev_bottom = bbox_bottom;