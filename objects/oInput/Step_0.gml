/// oInput — Step

// ----------------------------------------------------
// Reset one-frame press flags
// ----------------------------------------------------
global.inp_jump_press  = false;
global.inp_pause_press = false;


// ====================================================
// KEYBOARD
// ====================================================

var kb_left =
    keyboard_check(vk_left) ||
    keyboard_check(ord("A"));

var kb_right =
    keyboard_check(vk_right) ||
    keyboard_check(ord("D"));

var kb_jump_hold =
    keyboard_check(vk_space) ||
    keyboard_check(vk_up);

var kb_jump_press =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_up);

var kb_pause_press =
    keyboard_check_pressed(vk_escape);


// ====================================================
// GAMEPAD
// ====================================================

var gp_active =
    gamepad_is_connected(gamepad_index);

var gp_axis_h     = 0;
var gp_jump_hold  = false;
var gp_jump_press = false;
var gp_pause_p    = false;

if (gp_active)
{
    gp_axis_h =
        gamepad_axis_value(
            gamepad_index,
            gp_axislh
        );

    if (abs(gp_axis_h) < stick_deadzone)
    {
        gp_axis_h = 0;
    }

    gp_jump_hold =
        gamepad_button_check(
            gamepad_index,
            gp_face1
        );

    gp_jump_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_face1
        );

    gp_pause_p =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_start
        );
}


// ====================================================
// MOVEMENT INPUT
// ====================================================

var move = 0;

if (kb_left)
{
    move -= 1;
}

if (kb_right)
{
    move += 1;
}

// Use analogue stick when keyboard movement is absent.
if (move == 0)
{
    move = gp_axis_h;
}

global.inp_move =
    clamp(
        move,
        -1,
        1
    );


// ====================================================
// RAW JUMP INPUT
// ====================================================

var raw_jump_held =
    kb_jump_hold ||
    gp_jump_hold;

var raw_jump_press =
    kb_jump_press ||
    gp_jump_press;


// ====================================================
// BLOCK JUMP UNTIL PHYSICAL RELEASE
// ====================================================

if (!variable_global_exists("inp_jump_block_until_release"))
{
    global.inp_jump_block_until_release = false;
}

if (global.inp_jump_block_until_release)
{
    // Do not expose held or pressed jump input to the
    // player while the confirmation button remains held.
    global.inp_jump_held  = false;
    global.inp_jump_press = false;

    // Only release the block once every jump input has
    // genuinely been released.
    if (!raw_jump_held)
    {
        global.inp_jump_block_until_release = false;
    }
}
else
{
    global.inp_jump_held  = raw_jump_held;
    global.inp_jump_press = raw_jump_press;
}


// ----------------------------------------------------
// Pause
// ----------------------------------------------------
global.inp_pause_press =
    kb_pause_press ||
    gp_pause_p;