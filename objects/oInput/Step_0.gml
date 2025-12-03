/// oInput — Step

// Reset “press” flags each frame
global.inp_jump_press  = false;
global.inp_pause_press = false;

// --------- KEYBOARD ---------
var kb_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var kb_right = keyboard_check(vk_right) || keyboard_check(ord("D"));

var kb_jump_hold  = keyboard_check(vk_space) || keyboard_check(vk_up);
var kb_jump_press = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up);

var kb_pause_press = keyboard_check_pressed(vk_escape);

// --------- GAMEPAD ---------
var gp_active = gamepad_is_connected(gamepad_index);

var gp_axis_h    = 0;
var gp_jump_hold = false;
var gp_jump_press = false;
var gp_pause_p    = false;

if (gp_active) {
    gp_axis_h = gamepad_axis_value(gamepad_index, gp_axislh);

    // Deadzone
    if (abs(gp_axis_h) < stick_deadzone) gp_axis_h = 0;

    gp_jump_hold  = gamepad_button_check(gamepad_index, gp_face1);          // A
    gp_jump_press = gamepad_button_check_pressed(gamepad_index, gp_face1);  // A
    gp_pause_p    = gamepad_button_check_pressed(gamepad_index, gp_start);
}

// --------- COMBINE INPUTS ---------
// Move axis: keyboard overrides stick if pressed
var move = 0;

if (kb_left)  move -= 1;
if (kb_right) move += 1;

if (move == 0) move = gp_axis_h; // use stick if no keys

global.inp_move = clamp(move, -1, 1);

// Jump / pause
global.inp_jump_held   = kb_jump_hold  || gp_jump_hold;
global.inp_jump_press  = kb_jump_press || gp_jump_press;
global.inp_pause_press = kb_pause_press || gp_pause_p;
