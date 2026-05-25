/// oInput — Create

persistent = true;

/// oInput — Create

if (instance_number(oInput) > 1) {
    instance_destroy();
    exit;
}

// Gamepad settings
gamepad_index = 0;
stick_deadzone = 0.25;

// Initialise global input actions
global.inp_move        = 0;     // -1..1
global.inp_jump_held   = false;
global.inp_jump_press  = false;
global.inp_pause_press = false;
