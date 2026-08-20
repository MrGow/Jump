/// oInput — Create

// ----------------------------------------------------
// Single persistent input controller
// ----------------------------------------------------

persistent = true;

if (instance_number(oInput) > 1)
{
    instance_destroy();
    exit;
}


// ----------------------------------------------------
// Load and validate saved settings, including controls
// ----------------------------------------------------

scr_settings_init();
scr_controls_ensure_defaults();


// ----------------------------------------------------
// Gamepad settings
// ----------------------------------------------------

// -1 means no controller is currently assigned.
gamepad_index = -1;

stick_deadzone = 0.25;

// Maximum GameMaker gamepad slots to check.
gamepad_slot_count = 12;


// ====================================================
// CONTROLLER RUMBLE
//
// scr_rumble_play() writes to these values.
// oInput — Step owns the countdown and explicitly
// stops the motors when the timer expires.
//
// Vibration setting:
// 0 = Off
// 1 = Low
// 2 = High
// ====================================================

if (!variable_global_exists("controller_vibration"))
{
    global.controller_vibration = 2;
}

rumble_timer      = 0;
rumble_low_motor  = 0;
rumble_high_motor = 0;


// ----------------------------------------------------
// Initialise gameplay actions
// ----------------------------------------------------

global.inp_move        = 0;
global.inp_jump_held   = false;
global.inp_jump_press  = false;
global.inp_pause_press = false;


// ----------------------------------------------------
// Initialise menu actions
// ----------------------------------------------------

global.inp_menu_up_press    = false;
global.inp_menu_down_press  = false;
global.inp_menu_left_press  = false;
global.inp_menu_right_press = false;

global.inp_menu_confirm_press = false;
global.inp_menu_back_press    = false;


// ----------------------------------------------------
// Jump-input consumption
//
// When true, jump remains blocked until every physical
// jump control has been released.
// ----------------------------------------------------

if (!variable_global_exists("inp_jump_block_until_release"))
{
    global.inp_jump_block_until_release = false;
}
