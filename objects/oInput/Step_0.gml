/// oInput — Step

// ----------------------------------------------------
// Reset one-frame input actions
// ----------------------------------------------------
global.inp_jump_press  = false;
global.inp_pause_press = false;

global.inp_menu_up_press    = false;
global.inp_menu_down_press  = false;
global.inp_menu_left_press  = false;
global.inp_menu_right_press = false;

global.inp_menu_confirm_press = false;
global.inp_menu_back_press    = false;


// ====================================================
// FIND OR VALIDATE ACTIVE CONTROLLER
// ====================================================

// Forget the assigned controller if it was disconnected.
if (
    gamepad_index != -1 &&
    !gamepad_is_connected(gamepad_index)
)
{
    gamepad_index = -1;
}


// Find the first available controller.
if (gamepad_index == -1)
{
    for (var slot = 0; slot < gamepad_slot_count; slot++)
    {
        if (gamepad_is_connected(slot))
        {
            gamepad_index = slot;
            break;
        }
    }
}


// ====================================================
// KEYBOARD
// ====================================================

var kb_left_held =
    keyboard_check(vk_left) ||
    keyboard_check(ord("A"));

var kb_right_held =
    keyboard_check(vk_right) ||
    keyboard_check(ord("D"));


// Space is the only keyboard jump/confirm button.
var kb_jump_hold =
    keyboard_check(vk_space);

var kb_jump_press =
    keyboard_check_pressed(vk_space);


var kb_pause_press =
    keyboard_check_pressed(vk_escape);


// Keyboard menu navigation
var kb_menu_up_press =
    keyboard_check_pressed(vk_up) ||
    keyboard_check_pressed(ord("W"));

var kb_menu_down_press =
    keyboard_check_pressed(vk_down) ||
    keyboard_check_pressed(ord("S"));

var kb_menu_left_press =
    keyboard_check_pressed(vk_left) ||
    keyboard_check_pressed(ord("A"));

var kb_menu_right_press =
    keyboard_check_pressed(vk_right) ||
    keyboard_check_pressed(ord("D"));

var kb_menu_back_press =
    keyboard_check_pressed(vk_escape) ||
    keyboard_check_pressed(vk_backspace);


// ====================================================
// GAMEPAD DEFAULTS
// ====================================================

var gp_active = false;

var gp_axis_h = 0;
var gp_axis_v = 0;


// Gameplay D-pad held state
var gp_dpad_left_held  = false;
var gp_dpad_right_held = false;


// Menu D-pad pressed state
var gp_dpad_up_press    = false;
var gp_dpad_down_press  = false;
var gp_dpad_left_press  = false;
var gp_dpad_right_press = false;


// Buttons
var gp_jump_hold  = false;
var gp_jump_press = false;

var gp_back_press  = false;
var gp_pause_press = false;


// ====================================================
// GAMEPAD INPUT
// ====================================================

if (
    gamepad_index != -1 &&
    gamepad_is_connected(gamepad_index)
)
{
    gp_active = true;


    // ------------------------------------------------
    // Analogue stick
    // ------------------------------------------------
    gp_axis_h =
        gamepad_axis_value(
            gamepad_index,
            gp_axislh
        );

    gp_axis_v =
        gamepad_axis_value(
            gamepad_index,
            gp_axislv
        );


    if (abs(gp_axis_h) < stick_deadzone)
    {
        gp_axis_h = 0;
    }

    if (abs(gp_axis_v) < stick_deadzone)
    {
        gp_axis_v = 0;
    }


    // ------------------------------------------------
    // D-pad held
    //
    // Used during gameplay so the player can face left
    // or right and choose a jump direction.
    // ------------------------------------------------
    gp_dpad_left_held =
        gamepad_button_check(
            gamepad_index,
            gp_padl
        );

    gp_dpad_right_held =
        gamepad_button_check(
            gamepad_index,
            gp_padr
        );


    // ------------------------------------------------
    // D-pad pressed
    //
    // Used for one-step menu navigation.
    // ------------------------------------------------
    gp_dpad_up_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_padu
        );

    gp_dpad_down_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_padd
        );

    gp_dpad_left_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_padl
        );

    gp_dpad_right_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_padr
        );


    // ------------------------------------------------
    // Face buttons
    // ------------------------------------------------

    // Xbox A / Steam Input face button 1
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


    // Xbox B / Steam Input face button 2
    gp_back_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_face2
        );


    // Xbox Menu / controller Start
    gp_pause_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_start
        );
}


// ====================================================
// GAMEPLAY MOVEMENT
// ====================================================

var move = 0;


// Keyboard has first priority.
if (kb_left_held)
{
    move -= 1;
}

if (kb_right_held)
{
    move += 1;
}


// D-pad has second priority.
if (move == 0)
{
    if (gp_dpad_left_held)
    {
        move -= 1;
    }

    if (gp_dpad_right_held)
    {
        move += 1;
    }
}


// Use analogue stick if neither keyboard nor D-pad is held.
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
    global.inp_jump_held  = false;
    global.inp_jump_press = false;

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


// ====================================================
// MENU INPUT
// ====================================================

// D-pad and keyboard arrows/WASD.
global.inp_menu_up_press =
    kb_menu_up_press ||
    gp_dpad_up_press;

global.inp_menu_down_press =
    kb_menu_down_press ||
    gp_dpad_down_press;

global.inp_menu_left_press =
    kb_menu_left_press ||
    gp_dpad_left_press;

global.inp_menu_right_press =
    kb_menu_right_press ||
    gp_dpad_right_press;


// Space or Xbox A / Steam face button 1.
global.inp_menu_confirm_press =
    kb_jump_press ||
    gp_jump_press;


// Escape, Backspace, or Xbox B / Steam face button 2.
global.inp_menu_back_press =
    kb_menu_back_press ||
    gp_back_press;


// ====================================================
// PAUSE
// ====================================================

global.inp_pause_press =
    kb_pause_press ||
    gp_pause_press;