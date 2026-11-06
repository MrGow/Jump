/// oScrapChiefElevator — Create

// ====================================================
// PARENT FLOOR SURFACE
// ====================================================

event_inherited();

visible = true;


// ====================================================
// SPRITE
// ====================================================

sprite_index = spriteArea1Elevator;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_alpha = 1;
image_blend = c_white;

depth = -100;


// ====================================================
// START POSITION
// ====================================================

start_x = x;
start_y = y;

prev_x = x;
prev_y = y;

dx = 0;
dy = 0;


// ====================================================
// FLOOR SURFACE
// ====================================================

enabled = true;

surface_y = bbox_top;

surface_inset_left = 8;
surface_inset_right = 8;


// ====================================================
// CONTROLLER
// ====================================================

controller = noone;


// ====================================================
// VISUAL ENGINE SHAKE
// ====================================================

visual_shake_x = 0;
visual_shake_y = 0;

engine_shake_x = 0;
engine_shake_y = 1;

engine_shake_timer = 0;
engine_shake_interval = 3;


// ====================================================
// TEMPORARY JOLTS
// ====================================================

jolt_timer = 0;
jolt_strength = 0;


// ====================================================
// MOVEMENT AUDIO
// ====================================================

snd_elevator_loop = RisingElevatorSoundLoop;

elevator_loop_instance = noone;
elevator_loop_paused = false;

elevator_loop_gain = 0.75;
elevator_loop_priority = -50;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;