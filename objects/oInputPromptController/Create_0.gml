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
// CONTROLS SAFETY
// ====================================================

scr_controls_ensure_defaults();


// ====================================================
// CURRENT INPUT DEVICE
//
// "keyboard"
// "controller"
// ====================================================

if (!variable_global_exists("input_prompt_device"))
{
    global.input_prompt_device =
        "keyboard";
}


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
// KEYBOARD — ARROW FRAMES
// ====================================================

key_up =
    0;

key_down =
    1;

key_left =
    2;

key_right =
    3;


// ====================================================
// KEYBOARD — EXTRA FRAMES
//
// spriteKeyboardExtra
//
// White versions only.
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
        global.input_prompt_device ==
        "keyboard"
    );
};


using_controller = function()
{
    return (
        global.input_prompt_device ==
        "controller"
    );
};


// ====================================================
// LETTER FRAME LOOKUP
//
// Confirmed:
//
// A = 16
// B = 17
// ...
// Z = 41
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
    if (
        spr_keyboard_all == -1 ||
        _frame < 0
    )
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
    if (
        spr_keyboard_extra == -1 ||
        _frame < 0
    )
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
// FALLBACK KEY TEXT
//
// Used only if a rebound keyboard key does not yet
// have an assigned glyph in our sprite map.
//
// This prevents a valid remap from producing no prompt.
// ====================================================

draw_keyboard_text_fallback =
function(
    _key,
    _x,
    _y,
    _scale
)
{
    var txt =
        scr_controls_keyboard_name(
            _key
        );


    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );


    draw_text_transformed(
        _x,
        _y,
        txt,
        _scale,
        _scale,
        0
    );


    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );
};


// ====================================================
// DRAW KEYBOARD BINDING
//
// Converts an actual GameMaker keycode into the
// matching keyboard glyph.
// ====================================================

draw_keyboard_binding =
function(
    _key,
    _x,
    _y,
    _scale
)
{
    // ------------------------------------------------
    // SPECIAL / EXTRA KEYS
    // ------------------------------------------------

    switch (_key)
    {
        case vk_space:
        {
            draw_keyboard_extra(
                extra_space,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_enter:
        {
            draw_keyboard_extra(
                extra_enter,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_shift:
        {
            draw_keyboard_extra(
                extra_shift,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_control:
        {
            draw_keyboard_extra(
                extra_ctrl,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_alt:
        {
            draw_keyboard_extra(
                extra_alt,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_tab:
        {
            draw_keyboard_extra(
                extra_tab,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_backspace:
        {
            draw_keyboard_extra(
                extra_backspace,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_delete:
        {
            draw_keyboard_extra(
                extra_delete,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_home:
        {
            draw_keyboard_extra(
                extra_home,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_end:
        {
            draw_keyboard_extra(
                extra_end,
                _x,
                _y,
                _scale
            );

            return;
        }


        // ------------------------------------------------
        // ARROWS
        // ------------------------------------------------

        case vk_up:
        {
            draw_keyboard_all(
                key_up,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_down:
        {
            draw_keyboard_all(
                key_down,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_left:
        {
            draw_keyboard_all(
                key_left,
                _x,
                _y,
                _scale
            );

            return;
        }


        case vk_right:
        {
            draw_keyboard_all(
                key_right,
                _x,
                _y,
                _scale
            );

            return;
        }
    }


    // ------------------------------------------------
    // LETTERS A-Z
    // ------------------------------------------------

    if (
        _key >= ord("A") &&
        _key <= ord("Z")
    )
    {
        var letter =
            chr(
                _key
            );


        var frame =
            get_letter_frame(
                letter
            );


        if (frame >= 0)
        {
            draw_keyboard_all(
                frame,
                _x,
                _y,
                _scale
            );

            return;
        }
    }


    // ------------------------------------------------
    // FALLBACK
    // ------------------------------------------------

    draw_keyboard_text_fallback(
        _key,
        _x,
        _y,
        _scale
    );
};


// ====================================================
// DRAW CONTROLLER BINDING
//
// Converts an actual GameMaker gamepad button constant
// into its glyph.
// ====================================================

draw_controller_binding =
function(
    _button,
    _x,
    _y,
    _scale
)
{
    var spr =
        -1;


    switch (_button)
    {
        case gp_face1:
        {
            spr =
                spr_controller_a;
        }
        break;


        case gp_face2:
        {
            spr =
                spr_controller_b;
        }
        break;


        case gp_face3:
        {
            spr =
                spr_controller_x;
        }
        break;


        case gp_face4:
        {
            spr =
                spr_controller_y;
        }
        break;


        case gp_shoulderl:
        {
            spr =
                spr_controller_lb;
        }
        break;


        case gp_shoulderr:
        {
            spr =
                spr_controller_rb;
        }
        break;


        case gp_shoulderlb:
        {
            spr =
                spr_controller_lt;
        }
        break;


        case gp_shoulderrb:
        {
            spr =
                spr_controller_rt;
        }
        break;


        case gp_padl:
        {
            spr =
                spr_controller_left;
        }
        break;


        case gp_padr:
        {
            spr =
                spr_controller_right;
        }
        break;


        case gp_padu:
        {
            spr =
                spr_controller_up;
        }
        break;


        case gp_padd:
        {
            spr =
                spr_controller_down;
        }
        break;
    }


    if (spr != -1)
    {
        draw_controller_sprite(
            spr,
            _x,
            _y,
            _scale
        );

        return;
    }


    // No glyph exists for this particular controller
    // binding yet, e.g. L3/R3/View.
    //
    // Fall back to its normal controls-menu name.
    var txt =
        scr_controls_gamepad_name(
            _button
        );


    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );


    draw_text_transformed(
        _x,
        _y,
        txt,
        _scale,
        _scale,
        0
    );


    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );
};


// ====================================================
// GET CURRENT GAMEPLAY BINDING
// ====================================================

get_keyboard_action_binding =
function(_action)
{
    scr_controls_ensure_defaults();


    switch (_action)
    {
        case "jump":
        {
            return
                global.control_key_jump;
        }


        case "left":
        {
            return
                global.control_key_left;
        }


        case "right":
        {
            return
                global.control_key_right;
        }
    }


    return -1;
};


get_controller_action_binding =
function(_action)
{
    scr_controls_ensure_defaults();


    switch (_action)
    {
        case "jump":
        {
            return
                global.control_pad_jump;
        }


        case "left":
        {
            return
                global.control_pad_left;
        }


        case "right":
        {
            return
                global.control_pad_right;
        }
    }


    return -1;
};


// ====================================================
// GENERAL PROMPT DRAW
//
// REMAPPABLE GAMEPLAY ACTIONS:
//
//     "jump"
//     "left"
//     "right"
//
// FIXED MENU ACTIONS:
//
//     "confirm"
//     "back"
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
    // REMAPPABLE GAMEPLAY ACTIONS
    // =================================================

    if (
        action == "jump" ||
        action == "left" ||
        action == "right"
    )
    {
        if (using_keyboard())
        {
            var key =
                get_keyboard_action_binding(
                    action
                );


            draw_keyboard_binding(
                key,
                _x,
                _y,
                _scale
            );
        }
        else
        {
            var button =
                get_controller_action_binding(
                    action
                );


            draw_controller_binding(
                button,
                _x,
                _y,
                _scale
            );
        }


        return;
    }


    // =================================================
    // FIXED MENU PROMPTS
    // =================================================

    if (using_keyboard())
    {
        switch (action)
        {
            case "confirm":
            {
                draw_keyboard_extra(
                    extra_space,
                    _x,
                    _y,
                    _scale
                );
            }
            break;


            case "back":
            case "pause":
            {
                draw_keyboard_extra(
                    extra_escape,
                    _x,
                    _y,
                    _scale
                );
            }
            break;


            case "traversal":
            {
                draw_keyboard_extra(
                    extra_shift,
                    _x,
                    _y,
                    _scale
                );
            }
            break;


            case "dash":
            {
                draw_keyboard_binding(
                    ord("F"),
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
    // FIXED CONTROLLER PROMPTS
    // =================================================

    switch (action)
    {
        case "confirm":
        {
            draw_controller_sprite(
                spr_controller_a,
                _x,
                _y,
                _scale
            );
        }
        break;


        case "back":
        {
            draw_controller_sprite(
                spr_controller_b,
                _x,
                _y,
                _scale
            );
        }
        break;


        case "traversal":
        case "dash":
        {
            draw_controller_sprite(
                spr_controller_lb,
                _x,
                _y,
                _scale
            );
        }
        break;
    }
};