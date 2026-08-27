/// oInput — Step

scr_controls_ensure_defaults();


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
// NPC DIALOGUE HOT-RELOAD SAFETY
// ====================================================

if (!variable_global_exists("npc_dialogue_active"))
{
    global.npc_dialogue_active = false;
}


// ====================================================
// RUMBLE HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "rumble_timer"))
{
    rumble_timer = 0;
}

if (!variable_instance_exists(id, "rumble_low_motor"))
{
    rumble_low_motor = 0;
}

if (!variable_instance_exists(id, "rumble_high_motor"))
{
    rumble_high_motor = 0;
}

if (!variable_global_exists("controller_vibration"))
{
    global.controller_vibration = 2;
}


// ====================================================
// FIND OR VALIDATE ACTIVE CONTROLLER
// ====================================================

if (
    gamepad_index != -1 &&
    !gamepad_is_connected(gamepad_index)
)
{
    rumble_timer      = 0;
    rumble_low_motor  = 0;
    rumble_high_motor = 0;

    gamepad_index = -1;
}


// ----------------------------------------------------
// Find first available controller
// ----------------------------------------------------

if (gamepad_index == -1)
{
    for (
        var slot = 0;
        slot < gamepad_slot_count;
        slot++
    )
    {
        if (gamepad_is_connected(slot))
        {
            gamepad_index = slot;

            gamepad_set_vibration(
                gamepad_index,
                0,
                0
            );

            rumble_timer      = 0;
            rumble_low_motor  = 0;
            rumble_high_motor = 0;

            break;
        }
    }
}


// ====================================================
// CONTROLLER RUMBLE UPDATE
// ====================================================

if (
    gamepad_index != -1 &&
    gamepad_is_connected(gamepad_index)
)
{
    if (global.controller_vibration <= 0)
    {
        rumble_timer      = 0;
        rumble_low_motor  = 0;
        rumble_high_motor = 0;

        gamepad_set_vibration(
            gamepad_index,
            0,
            0
        );
    }
    else if (rumble_timer > 0)
    {
        gamepad_set_vibration(
            gamepad_index,
            rumble_low_motor,
            rumble_high_motor
        );

        rumble_timer--;

        if (rumble_timer <= 0)
        {
            rumble_timer      = 0;
            rumble_low_motor  = 0;
            rumble_high_motor = 0;

            gamepad_set_vibration(
                gamepad_index,
                0,
                0
            );
        }
    }
    else
    {
        rumble_timer      = 0;
        rumble_low_motor  = 0;
        rumble_high_motor = 0;

        gamepad_set_vibration(
            gamepad_index,
            0,
            0
        );
    }
}
else
{
    rumble_timer      = 0;
    rumble_low_motor  = 0;
    rumble_high_motor = 0;
}


// ====================================================
// KEYBOARD
// ====================================================

var kb_left_held =
    keyboard_check(vk_left) ||
    keyboard_check(global.control_key_left);

var kb_right_held =
    keyboard_check(vk_right) ||
    keyboard_check(global.control_key_right);


// Gameplay jump binding.
var kb_jump_hold =
    keyboard_check(global.control_key_jump);

var kb_jump_press =
    keyboard_check_pressed(global.control_key_jump);


var kb_pause_press =
    keyboard_check_pressed(vk_escape);


// ----------------------------------------------------
// Keyboard menu navigation
// ----------------------------------------------------

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


// ----------------------------------------------------
// Gameplay D-pad held state
// ----------------------------------------------------

var gp_dpad_left_held  = false;
var gp_dpad_right_held = false;


// ----------------------------------------------------
// Menu D-pad pressed state
// ----------------------------------------------------

var gp_dpad_up_press    = false;
var gp_dpad_down_press  = false;
var gp_dpad_left_press  = false;
var gp_dpad_right_press = false;


// ----------------------------------------------------
// Buttons
// ----------------------------------------------------

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
    // Gameplay D-pad
    // ------------------------------------------------

    gp_dpad_left_held =
        gamepad_button_check(
            gamepad_index,
            global.control_pad_left
        );

    gp_dpad_right_held =
        gamepad_button_check(
            gamepad_index,
            global.control_pad_right
        );


    // ------------------------------------------------
    // Menu D-pad
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
    // Gameplay jump
    // ------------------------------------------------

    gp_jump_hold =
        gamepad_button_check(
            gamepad_index,
            global.control_pad_jump
        );

    gp_jump_press =
        gamepad_button_check_pressed(
            gamepad_index,
            global.control_pad_jump
        );


    // ------------------------------------------------
    // Back / pause
    // ------------------------------------------------

    gp_back_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_face2
        );

    gp_pause_press =
        gamepad_button_check_pressed(
            gamepad_index,
            gp_start
        );
}

// ====================================================
// LAST USED INPUT DEVICE
//
// UI prompts follow whichever device the player most
// recently interacted with.
//
// IMPORTANT:
// We use real recognised input rather than merely
// checking whether a controller is connected.
// ====================================================

if (instance_exists(oInputPromptController))
{
    var prompt_controller =
        instance_find(
            oInputPromptController,
            0
        );


    // =================================================
    // KEYBOARD ACTIVITY
    // =================================================

    var keyboard_used =
        false;


    // Movement
    if (
        kb_left_held ||
        kb_right_held
    )
    {
        keyboard_used =
            true;
    }


    // Gameplay buttons
    if (
        kb_jump_hold ||
        kb_jump_press ||
        kb_pause_press
    )
    {
        keyboard_used =
            true;
    }


    // Menu buttons
    if (
        kb_menu_up_press ||
        kb_menu_down_press ||
        kb_menu_left_press ||
        kb_menu_right_press ||
        kb_menu_back_press
    )
    {
        keyboard_used =
            true;
    }


    // Space / Enter menu confirmation.
    if (
        keyboard_check_pressed(vk_space) ||
        keyboard_check_pressed(vk_enter)
    )
    {
        keyboard_used =
            true;
    }


    // Current traversal / ability keyboard controls.
    if (
        keyboard_check(vk_shift) ||
        keyboard_check(ord("F"))
    )
    {
        keyboard_used =
            true;
    }


    // =================================================
    // CONTROLLER ACTIVITY
    // =================================================

    var controller_used =
        false;


    if (gp_active)
    {
        // ---------------------------------------------
        // Analogue stick
        // ---------------------------------------------

        if (
            abs(gp_axis_h) > 0 ||
            abs(gp_axis_v) > 0
        )
        {
            controller_used =
                true;
        }


        // ---------------------------------------------
        // D-pad
        // ---------------------------------------------

        if (
            gp_dpad_left_held ||
            gp_dpad_right_held ||
            gp_dpad_up_press ||
            gp_dpad_down_press ||
            gp_dpad_left_press ||
            gp_dpad_right_press
        )
        {
            controller_used =
                true;
        }


        // ---------------------------------------------
        // Known buttons
        // ---------------------------------------------

        if (
            gp_jump_hold ||
            gp_jump_press ||
            gp_back_press ||
            gp_pause_press
        )
        {
            controller_used =
                true;
        }


        // ---------------------------------------------
        // Shoulder / trigger / face buttons
        //
        // This also means pressing an ability button
        // immediately switches the UI even if that
        // particular action isn't being used in the
        // current game state.
        // ---------------------------------------------

        if (
            gamepad_button_check(
                gamepad_index,
                gp_face1
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_face2
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_face3
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_face4
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_shoulderl
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_shoulderr
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_shoulderlb
            )
            ||
            gamepad_button_check(
                gamepad_index,
                gp_shoulderrb
            )
        )
        {
            controller_used =
                true;
        }
    }


    // =================================================
    // APPLY DEVICE
    //
    // Only change when one device actually receives
    // input. Merely plugging in a controller does not
    // suddenly replace all keyboard prompts.
    // =================================================

    if (
        controller_used &&
        !keyboard_used
    )
    {
        prompt_controller.set_controller();
    }
    else if (
        keyboard_used &&
        !controller_used
    )
    {
        prompt_controller.set_keyboard();
    }
}

// ====================================================
// RAW INPUT
//
// Keep these BEFORE dialogue suppression because
// dialogue still needs to know whether Space/A is
// physically held/released.
// ====================================================

var raw_jump_held =
    kb_jump_hold ||
    gp_jump_hold;

var raw_jump_press =
    kb_jump_press ||
    gp_jump_press;


// ====================================================
// MENU / DIALOGUE INPUT
//
// These remain available during NPC dialogue.
// ====================================================

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


// Space / Enter / controller A.
//
// IMPORTANT:
// This is what B1LL dialogue should use.
global.inp_menu_confirm_press =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter) ||
    (
        gp_active &&
        gamepad_button_check_pressed(
            gamepad_index,
            gp_face1
        )
    );


global.inp_menu_back_press =
    kb_menu_back_press ||
    gp_back_press;


// ====================================================
// GAMEPLAY INPUT LOCK
//
// Dialogue keeps menu/confirm input alive but completely
// suppresses movement and jump input seen by gameplay,
// the player, the bird, abilities, etc.
// ====================================================

var gameplay_input_locked =
    global.npc_dialogue_active;


// ====================================================
// GAMEPLAY MOVEMENT
// ====================================================

if (gameplay_input_locked)
{
    global.inp_move = 0;
}
else
{
    var move = 0;

    // Keyboard
    if (kb_left_held)
    {
        move -= 1;
    }

    if (kb_right_held)
    {
        move += 1;
    }


    // D-pad
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


    // Analogue stick
    if (move == 0)
    {
        move =
            gp_axis_h;
    }


    global.inp_move =
        clamp(
            move,
            -1,
            1
        );
}


// ====================================================
// BLOCK JUMP UNTIL PHYSICAL RELEASE
// ====================================================

if (!variable_global_exists("inp_jump_block_until_release"))
{
    global.inp_jump_block_until_release = false;
}


// ----------------------------------------------------
// NPC dialogue ALWAYS wins over gameplay jump.
// ----------------------------------------------------

if (gameplay_input_locked)
{
    global.inp_jump_held  = false;
    global.inp_jump_press = false;
}


// ----------------------------------------------------
// Normal post-cutscene / post-menu release lock
// ----------------------------------------------------

else if (global.inp_jump_block_until_release)
{
    global.inp_jump_held  = false;
    global.inp_jump_press = false;

    if (!raw_jump_held)
    {
        global.inp_jump_block_until_release = false;
    }
}


// ----------------------------------------------------
// Normal gameplay
// ----------------------------------------------------

else
{
    global.inp_jump_held =
        raw_jump_held;

    global.inp_jump_press =
        raw_jump_press;
}


// ====================================================
// PAUSE
// ====================================================

// Don't allow pause input while an NPC is actively
// speaking. Remove this condition if you later decide
// dialogue should itself be pausable.
if (global.npc_dialogue_active)
{
    global.inp_pause_press = false;
}
else
{
    global.inp_pause_press =
        kb_pause_press ||
        gp_pause_press;
}