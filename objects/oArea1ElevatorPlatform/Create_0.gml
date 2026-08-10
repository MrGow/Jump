/// oArea1ElevatorPlatform — Create


// ====================================================
// PARENT FLOOR SURFACE
// ====================================================

event_inherited();


// ====================================================
// VISIBILITY
// ====================================================

visible = true;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spriteArea1Elevator;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_alpha = 1;
image_blend = c_white;


// Player draws in front.
depth = -100;


// ====================================================
// START POSITION
// ====================================================

start_x = x;
start_y = y;

prev_x = x;
prev_y = y;


// ====================================================
// MOVEMENT DELTA
// ====================================================

dx = 0;
dy = 0;


// ====================================================
// FLOOR SURFACE
// ====================================================

enabled = true;

surface_y =
    bbox_top;

surface_inset_left  = 8;
surface_inset_right = 8;


// ====================================================
// CONTROLLER
// ====================================================

controller =
    instance_find(
        oArea1ElevatorController,
        0
    );


// ====================================================
// VISUAL ENGINE SHAKE
//
// IMPORTANT:
// This affects drawing only.
//
// x/y and collision remain perfectly stable.
// ====================================================

visual_shake_x = 0;
visual_shake_y = 0;


// Subtle constant machinery vibration.
engine_shake_x = 0;
engine_shake_y = 1;


// Don't choose a new offset every frame.
// Gives a heavier mechanical judder.
engine_shake_timer = 0;
engine_shake_interval = 3;


// ====================================================
// TEMPORARY JOLTS
//
// Used when the machinery powers up or engages.
// ====================================================

jolt_timer = 0;
jolt_strength = 0;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;