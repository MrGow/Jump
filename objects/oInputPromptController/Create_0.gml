/// oInputPromptController — Create


// ====================================================
// SINGLE PERSISTENT INSTANCE
// ====================================================

persistent = true;

if (instance_number(oInputPromptController) > 1)
{
    instance_destroy();
    exit;
}


// ====================================================
// CURRENT INPUT DEVICE
//
// "keyboard"
// "controller"
//
// Start on keyboard. As soon as the player touches the
// controller, this changes automatically.
// ====================================================

global.input_prompt_device =
    "keyboard";


// ====================================================
// KEYBOARD SPRITES
// ====================================================

spr_keyboard_all =
    asset_get_index(
        "spriteKeyboardAll"
    );

spr_keyboard_extra =
    asset_get_index(
        "spriteKeyboardExtra"
    );


// ====================================================
// CONTROLLER SPRITES
// ====================================================

spr_controller_a =
    asset_get_index(
        "spriteControllerA"
    );

spr_controller_b =
    asset_get_index(
        "spriteControllerB"
    );

spr_controller_x =
    asset_get_index(
        "spriteControllerX"
    );

spr_controller_y =
    asset_get_index(
        "spriteControllerY"
    );


spr_controller_lb =
    asset_get_index(
        "spriteControllerLB"
    );

spr_controller_rb =
    asset_get_index(
        "spriteControllerRB"
    );

spr_controller_lt =
    asset_get_index(
        "spriteControllerLT"
    );

spr_controller_rt =
    asset_get_index(
        "spriteControllerRT"
    );


spr_controller_left =
    asset_get_index(
        "spriteControllerDirectionLeft"
    );

spr_controller_right =
    asset_get_index(
        "spriteControllerDirectionRight"
    );

spr_controller_up =
    asset_get_index(
        "spriteControllerDirectionUp"
    );

spr_controller_down =
    asset_get_index(
        "spriteControllerDirectionDown"
    );


// ====================================================
// KEYBOARD FRAME MAP
//
// spriteKeyboardAll:
//
// Frames are zero-based in GameMaker.
//
// Your sheet runs:
//
// arrows
// F1-F12
// number row
// letters
// punctuation
//
// These constants mean the rest of the game never
// needs to know sprite-sheet frame numbers.
// ====================================================


// ----------------------------------------------------
// ARROWS
// ----------------------------------------------------

key_up =
    0;

key_down =
    1;

key_left =
    2;

key_right =
    3;


// ----------------------------------------------------
// FUNCTION KEYS
// ----------------------------------------------------

key_f1  = 4;
key_f2  = 5;
key_f3  = 6;
key_f4  = 7;
key_f5  = 8;
key_f6  = 9;
key_f7  = 10;
key_f8  = 11;
key_f9  = 12;
key_f10 = 13;
key_f11 = 14;
key_f12 = 15;


// ----------------------------------------------------
// NUMBER ROW
// ----------------------------------------------------

key_1 = 16;
key_2 = 17;
key_3 = 18;
key_4 = 19;
key_5 = 20;
key_6 = 21;
key_7 = 22;
key_8 = 23;
key_9 = 24;
key_0 = 25;


// ----------------------------------------------------
// LETTERS
//
// These are assigned below through the lookup function
// rather than requiring other objects to know indexes.
// ----------------------------------------------------


// ====================================================
// EXTRA KEYBOARD FRAME MAP
//
// spriteKeyboardExtra
//
// White set only.
//
// Based on your supplied sheet:
//
// TAB
// ESC
// PRINT
// BACK
//
// SHIFT
// PCT
// PG
// ENTER
//
// CTRL
// ALT
// SPACE
// INS
//
// DEL
// END
// HM
// PAUSE
//
// GameMaker frames are zero-based.
// ====================================================

extra_tab =
    0;

extra_escape =
    1;

extra_print =
    2;

extra_backspace =
    3;

extra_shift =
    4;

extra_pct =
    5;

extra_page =
    6;

extra_enter =
    7;

extra_ctrl =
    8;

extra_alt =
    9;

extra_space =
    10;

extra_insert =
    11;

extra_delete =
    12;

extra_end =
    13;

extra_home =
    14;

extra_pause =
    15;


// ====================================================
// DEVICE HELPERS
// ====================================================

set_keyboard = function()
{
    global.input_prompt_device =
        "keyboard";
};


set_controller = function()
{
    global.input_prompt_device =
        "controller";
};


using_keyboard = function()
{
    return (
        global.input_prompt_device
        ==
        "keyboard"
    );
};


using_controller = function()
{
    return (
        global.input_prompt_device
        ==
        "controller"
    );
};


// ====================================================
// KEYBOARD LETTER LOOKUP
//
// Returns the frame of spriteKeyboardAll.
//
// This keeps letter frame knowledge inside this object.
//
// NOTE:
// Once we verify the exact frame order of the complete
// imported animation in GameMaker, this is also the
// single place we'd correct any unusual ordering.
// ====================================================

// ====================================================
// KEYBOARD LETTER FRAME LOOKUP
//
// spriteKeyboardAll uses the actual imported animation
// frame order.
//
// Keeping this lookup here means every UI prompt can
// simply request:
//
//     get_letter_frame("A")
//     get_letter_frame("D")
//     get_letter_frame("F")
//
// etc.
// ====================================================

// ====================================================
// KEYBOARD LETTER FRAME LOOKUP
//
// spriteKeyboardAll actual imported frame order.
//
// A begins at frame 16.
// Letters then continue alphabetically.
// ====================================================

get_letter_frame = function(_letter)
{
    var key =
        string_upper(
            string(_letter)
        );


    switch (key)
    {
        case "A": return 16;
        case "B": return 17;
        case "C": return 18;
        case "D": return 19;
        case "E": return 20;
        case "F": return 21;
        case "G": return 22;
        case "H": return 23;
        case "I": return 24;
        case "J": return 25;
        case "K": return 26;
        case "L": return 27;
        case "M": return 28;
        case "N": return 29;
        case "O": return 30;
        case "P": return 31;
        case "Q": return 32;
        case "R": return 33;
        case "S": return 34;
        case "T": return 35;
        case "U": return 36;
        case "V": return 37;
        case "W": return 38;
        case "X": return 39;
        case "Y": return 40;
        case "Z": return 41;
    }


    return -1;
};

// ====================================================
// DRAW RAW KEYBOARD FRAME
// ====================================================

draw_keyboard_all =
function(
    _frame,
    _x,
    _y,
    _scale
)
{
    if (spr_keyboard_all == -1)
    {
        return;
    }


    draw_sprite_ext(
        spr_keyboard_all,
        _frame,

        _x,
        _y,

        _scale,
        _scale,

        0,

        c_white,
        1
    );
};


// ====================================================
// DRAW EXTRA KEYBOARD FRAME
// ====================================================

draw_keyboard_extra =
function(
    _frame,
    _x,
    _y,
    _scale
)
{
    if (spr_keyboard_extra == -1)
    {
        return;
    }


    draw_sprite_ext(
        spr_keyboard_extra,
        _frame,

        _x,
        _y,

        _scale,
        _scale,

        0,

        c_white,
        1
    );
};


// ====================================================
// DRAW CONTROLLER SPRITE
// ====================================================

draw_controller_sprite =
function(
    _sprite,
    _x,
    _y,
    _scale
)
{
    if (_sprite == -1)
    {
        return;
    }


    draw_sprite_ext(
        _sprite,
        0,

        _x,
        _y,

        _scale,
        _scale,

        0,

        c_white,
        1
    );
};


// ====================================================
// GENERAL PROMPT DRAW FUNCTION
//
// Eventually most UI should call:
//
// draw_prompt("jump", x, y, scale);
//
// rather than caring about Space/A itself.
// ====================================================

draw_prompt =
function(
    _action,
    _x,
    _y,
    _scale
)
{
    var action =
        string_lower(
            string(_action)
        );


    // =================================================
    // KEYBOARD
    // =================================================

    if (using_keyboard())
    {
        switch (action)
        {
            // -----------------------------------------
            // GAMEPLAY
            // -----------------------------------------

            case "jump":
            case "confirm":

                draw_keyboard_extra(
                    extra_space,
                    _x,
                    _y,
                    _scale
                );

                break;


            case "back":
            case "pause":

                draw_keyboard_extra(
                    extra_escape,
                    _x,
                    _y,
                    _scale
                );

                break;


            // -----------------------------------------
            // DIRECTIONS
            // -----------------------------------------

            case "up":

                draw_keyboard_all(
                    key_up,
                    _x,
                    _y,
                    _scale
                );

                break;


            case "down":

                draw_keyboard_all(
                    key_down,
                    _x,
                    _y,
                    _scale
                );

                break;


            case "left":

                draw_keyboard_all(
                    key_left,
                    _x,
                    _y,
                    _scale
                );

                break;


            case "right":

                draw_keyboard_all(
                    key_right,
                    _x,
                    _y,
                    _scale
                );

                break;


            // -----------------------------------------
            // TRAVERSAL
            //
            // Your current keyboard traversal button
            // is Shift.
            // -----------------------------------------

            case "traversal":

                draw_keyboard_extra(
                    extra_shift,
                    _x,
                    _y,
                    _scale
                );

                break;


            // -----------------------------------------
            // DASH
            //
            // Your current keyboard dash is F.
            // -----------------------------------------

            case "dash":

                var f_frame =
                    get_letter_frame(
                        "F"
                    );

                if (f_frame >= 0)
                {
                    draw_keyboard_all(
                        f_frame,
                        _x,
                        _y,
                        _scale
                    );
                }

                break;
        }


        return;
    }


    // =================================================
    // CONTROLLER
    // =================================================

    switch (action)
    {
        // ---------------------------------------------
        // GAMEPLAY / UI
        // ---------------------------------------------

        case "jump":
        case "confirm":

            draw_controller_sprite(
                spr_controller_a,
                _x,
                _y,
                _scale
            );

            break;


        case "back":

            draw_controller_sprite(
                spr_controller_b,
                _x,
                _y,
                _scale
            );

            break;


        case "pause":

            // No Start/Menu sprite supplied yet.
            // We deliberately draw nothing rather than
            // displaying the wrong button.
            break;


        // ---------------------------------------------
        // DIRECTIONS
        // ---------------------------------------------

        case "up":

            draw_controller_sprite(
                spr_controller_up,
                _x,
                _y,
                _scale
            );

            break;


        case "down":

            draw_controller_sprite(
                spr_controller_down,
                _x,
                _y,
                _scale
            );

            break;


        case "left":

            draw_controller_sprite(
                spr_controller_left,
                _x,
                _y,
                _scale
            );

            break;


        case "right":

            draw_controller_sprite(
                spr_controller_right,
                _x,
                _y,
                _scale
            );

            break;


        // ---------------------------------------------
        // TRAVERSAL
        // ---------------------------------------------

        case "traversal":

            draw_controller_sprite(
                spr_controller_lb,
                _x,
                _y,
                _scale
            );

            break;


        // ---------------------------------------------
        // DASH
        //
        // Change this if Dash is ultimately mapped to
        // another controller button.
        // ---------------------------------------------

        case "dash":

            draw_controller_sprite(
                spr_controller_lb,
                _x,
                _y,
                _scale
            );

            break;
    }
};