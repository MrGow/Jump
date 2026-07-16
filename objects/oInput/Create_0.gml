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
// Gamepad settings
// ----------------------------------------------------
gamepad_index  = 0;
stick_deadzone = 0.25;


// ----------------------------------------------------
// Initialise global input actions
// ----------------------------------------------------
global.inp_move        = 0;
global.inp_jump_held   = false;
global.inp_jump_press  = false;
global.inp_pause_press = false;


// ----------------------------------------------------
// Jump-input consumption
//
// When true, jump is completely suppressed until every
// physical jump control has been released.
//
// Used after:
// - death-menu confirmation
// - pause-menu confirmation
// - any other menu that uses jump as its confirm button
// ----------------------------------------------------
if (!variable_global_exists("inp_jump_block_until_release"))
{
    global.inp_jump_block_until_release = false;
}
