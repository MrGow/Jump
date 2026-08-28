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
// KEYBOARD ARROW FRAMES
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
// EXTRA KEYBOARD FRAMES
//
// spriteKeyboardExtra — white set
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
    return
        !variable_global_exists(
            "input_prompt_device"
        )
        ||
        global.input_prompt_device ==
            "keyboard";
};


using_controller = function()
{
    return
        variable_global_exists(
            "input_prompt_device"
        )
        &&
        global.input_prompt_device ==
            "controller";
};


// ====================================================
// LETTER LOOKUP
//
// IMPORTANT:
//
// Current spriteKeyboardAll mapping:
//
// A = 16
// B = 17
// ...
// Z = 41
// ====================================================

get_letter_frame = function(_letter)
{
    var s =
        string_upper(
            string(_letter)
        );


    if (string_length(s) <= 0)
    {
        return -1;
    }


    var code =
        ord(
            string_char_at(
                s,
                1
            )
        );


    var code_a =
        ord("A");


    var code_z =
        ord("Z");


    if (
        code >= code_a &&
        code <= code_z
    )
    {
        return
            16 +
            (
                code -
                code_a
            );
    }


    return -1;
};


// ====================================================
// DRAW RAW KEYBOARD FRAME
//
// _alpha is OPTIONAL.
//
// Existing menu calls that only provide four arguments
// therefore continue working exactly as before.
// ====================================================

draw_keyboard_all =
function(
    _frame,
    _x,
    _y,
    _scale,
    _alpha
)
{
    if (spr_keyboard_all == -1)
    {
        return;
    }


    if (is_undefined(_alpha))
    {
        _alpha =
            1;
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

        clamp(
            _alpha,
            0,
            1
        )
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
    _scale,
    _alpha
)
{
    if (spr_keyboard_extra == -1)
    {
        return;
    }


    if (is_undefined(_alpha))
    {
        _alpha =
            1;
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

        clamp(
            _alpha,
            0,
            1
        )
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
    _scale,
    _alpha
)
{
    if (_sprite == -1)
    {
        return;
    }


    if (is_undefined(_alpha))
    {
        _alpha =
            1;
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

        clamp(
            _alpha,
            0,
            1
        )
    );
};


// ====================================================
// KEYBOARD FALLBACK TEXT
//
// Used if someone remaps to a key for which we do not
// currently have a graphical keycap.
// ====================================================

draw_keyboard_text_fallback =
function(
    _key,
    _x,
    _y,
    _scale,
    _alpha
)
{
    if (is_undefined(_alpha))
    {
        _alpha =
            1;
    }


    var txt =
        scr_controls_keyboard_name(
            _key
        );


    draw_set_alpha(
        clamp(
            _alpha,
            0,
            1
        )
    );


    draw_set_color(
        c_white
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


    draw_set_alpha(
        1
    );
};


// ====================================================
// CONTROLLER FALLBACK TEXT
// ====================================================

draw_controller_text_fallback =
function(
    _button,
    _x,
    _y,
    _scale,
    _alpha
)
{
    if (is_undefined(_alpha))
    {
        _alpha =
            1;
    }


    var txt =
        scr_controls_gamepad_name(
            _button
        );


    draw_set_alpha(
        clamp(
            _alpha,
            0,
            1
        )
    );


    draw_set_color(
        c_white
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


    draw_set_alpha(
        1
    );
};


// ====================================================
// DRAW A CURRENT KEYBOARD BINDING
// ====================================================

draw_keyboard_binding =
function(
    _key,
    _x,
    _y,
    _scale,
    _alpha
)
{
    if (is_undefined(_alpha))
    {
        _alpha =
            1;
    }


    // ------------------------------------------------
    // SPECIAL KEYS
    // ------------------------------------------------

    switch (_key)
    {
        case vk_space:

            draw_keyboard_extra(
                extra_space,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_enter:

            draw_keyboard_extra(
                extra_enter,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_shift:

            draw_keyboard_extra(
                extra_shift,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_control:

            draw_keyboard_extra(
                extra_ctrl,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_alt:

            draw_keyboard_extra(
                extra_alt,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_tab:

            draw_keyboard_extra(
                extra_tab,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_escape:

            draw_keyboard_extra(
                extra_escape,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_backspace:

            draw_keyboard_extra(
                extra_backspace,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_delete:

            draw_keyboard_extra(
                extra_delete,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_home:

            draw_keyboard_extra(
                extra_home,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_end:

            draw_keyboard_extra(
                extra_end,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_left:

            draw_keyboard_all(
                key_left,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_right:

            draw_keyboard_all(
                key_right,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_up:

            draw_keyboard_all(
                key_up,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case vk_down:

            draw_keyboard_all(
                key_down,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;
    }


    // ------------------------------------------------
    // A-Z
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
                _scale,
                _alpha
            );


            return;
        }
    }


    // ------------------------------------------------
    // NO SPRITE AVAILABLE
    // ------------------------------------------------

    draw_keyboard_text_fallback(
        _key,
        _x,
        _y,
        _scale,
        _alpha
    );
};


// ====================================================
// DRAW CURRENT CONTROLLER BINDING
// ====================================================

draw_controller_binding =
function(
    _button,
    _x,
    _y,
    _scale,
    _alpha
)
{
    if (is_undefined(_alpha))
    {
        _alpha =
            1;
    }


    switch (_button)
    {
        case gp_face1:

            draw_controller_sprite(
                spr_controller_a,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_face2:

            draw_controller_sprite(
                spr_controller_b,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_face3:

            draw_controller_sprite(
                spr_controller_x,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_face4:

            draw_controller_sprite(
                spr_controller_y,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_shoulderl:

            draw_controller_sprite(
                spr_controller_lb,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_shoulderr:

            draw_controller_sprite(
                spr_controller_rb,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_shoulderlb:

            draw_controller_sprite(
                spr_controller_lt,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_shoulderrb:

            draw_controller_sprite(
                spr_controller_rt,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_padl:

            draw_controller_sprite(
                spr_controller_left,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_padr:

            draw_controller_sprite(
                spr_controller_right,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_padu:

            draw_controller_sprite(
                spr_controller_up,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;


        case gp_padd:

            draw_controller_sprite(
                spr_controller_down,
                _x,
                _y,
                _scale,
                _alpha
            );

            return;
    }


    draw_controller_text_fallback(
        _button,
        _x,
        _y,
        _scale,
        _alpha
    );
};


// ====================================================
// CURRENT REMAPPABLE KEYBOARD BINDING
// ====================================================

get_keyboard_action_binding =
function(_action)
{
    scr_controls_ensure_defaults();


    switch (_action)
    {
        case "jump":

            return
                global.control_key_jump;


        case "left":

            return
                global.control_key_left;


        case "right":

            return
                global.control_key_right;
    }


    return -1;
};


// ====================================================
// CURRENT REMAPPABLE CONTROLLER BINDING
// ====================================================

get_controller_action_binding =
function(_action)
{
    scr_controls_ensure_defaults();


    switch (_action)
    {
        case "jump":

            return
                global.control_pad_jump;


        case "left":

            return
                global.control_pad_left;


        case "right":

            return
                global.control_pad_right;
    }


    return -1;
};


// ====================================================
// GENERAL PROMPT DRAW
//
// _alpha is OPTIONAL.
//
// Therefore all existing calls such as:
//
//     draw_prompt("back", x, y, 0.75);
//
// remain valid.
//
// Tutorial popups can now use:
//
//     draw_prompt("jump", x, y, 1, popup_alpha);
// ====================================================

draw_prompt =
function(
    _action,
    _x,
    _y,
    _scale,
    _alpha
)
{
    if (is_undefined(_alpha))
    {
        _alpha =
            1;
    }


    _alpha =
        clamp(
            _alpha,
            0,
            1
        );


    var action =
        string_lower(
            string(_action)
        );


    // =================================================
    // REMAPPABLE GAMEPLAY CONTROLS
    // ====================================================

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
                _scale,
                _alpha
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
                _scale,
                _alpha
            );
        }


        return;
    }


    // =================================================
    // FIXED KEYBOARD PROMPTS
    // ====================================================

    if (using_keyboard())
    {
        switch (action)
        {
            case "confirm":

                draw_keyboard_extra(
                    extra_space,
                    _x,
                    _y,
                    _scale,
                    _alpha
                );

                break;


            case "back":
            case "pause":

                draw_keyboard_extra(
                    extra_escape,
                    _x,
                    _y,
                    _scale,
                    _alpha
                );

                break;


            case "up":

                draw_keyboard_all(
                    key_up,
                    _x,
                    _y,
                    _scale,
                    _alpha
                );

                break;


            case "down":

                draw_keyboard_all(
                    key_down,
                    _x,
                    _y,
                    _scale,
                    _alpha
                );

                break;


            case "traversal":

                draw_keyboard_extra(
                    extra_shift,
                    _x,
                    _y,
                    _scale,
                    _alpha
                );

                break;


            case "dash":

                draw_keyboard_binding(
                    ord("F"),
                    _x,
                    _y,
                    _scale,
                    _alpha
                );

                break;
        }


        return;
    }


    // =================================================
    // FIXED CONTROLLER PROMPTS
    // ====================================================

    switch (action)
    {
        case "confirm":

            draw_controller_sprite(
                spr_controller_a,
                _x,
                _y,
                _scale,
                _alpha
            );

            break;


        case "back":

            draw_controller_sprite(
                spr_controller_b,
                _x,
                _y,
                _scale,
                _alpha
            );

            break;


        case "up":

            draw_controller_sprite(
                spr_controller_up,
                _x,
                _y,
                _scale,
                _alpha
            );

            break;


        case "down":

            draw_controller_sprite(
                spr_controller_down,
                _x,
                _y,
                _scale,
                _alpha
            );

            break;


        case "pause":

            draw_controller_sprite(
                spr_controller_b,
                _x,
                _y,
                _scale,
                _alpha
            );

            break;


        case "traversal":
        case "dash":

            draw_controller_sprite(
                spr_controller_lb,
                _x,
                _y,
                _scale,
                _alpha
            );

            break;
    }
};