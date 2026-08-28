/// oTutorialPopup — Draw


// IMPORTANT:
//
// Do NOT call draw_self().
//
// The object's sprite is only the invisible rectangular
// trigger used in the room editor.


// ====================================================
// NOTHING TO DRAW
// ====================================================

if (popup_alpha <= 0.001)
{
    exit;
}


// ====================================================
// INPUT PROMPT CONTROLLER
// ====================================================

if (!instance_exists(oInputPromptController))
{
    exit;
}


var ipc =
    instance_find(
        oInputPromptController,
        0
    );


if (ipc == noone)
{
    exit;
}


// ====================================================
// POSITION + BOB
// ====================================================

var bob_y =
    sin(
        bob_phase
    )
    *
    bob_height;


var cx =
    round(
        popup_draw_x
    );


var cy =
    round(
        popup_draw_y +
        bob_y
    );


// ====================================================
// FONT
// ====================================================

if (prompt_font != -1)
{
    draw_set_font(
        prompt_font
    );
}


draw_set_halign(
    fa_left
);


draw_set_valign(
    fa_middle
);


// ====================================================
// SHARED LAYOUT
// ====================================================

// Jump uses a wider slot because keys such as Space
// and Enter are wider than ordinary keycaps.
var button_slot_w =
    34 *
    prompt_scale;


// Direction buttons use two smaller fixed slots.
var button_small_slot_w =
    20 *
    prompt_scale;


var line_gap =
    22;


var prompt_y =
    cy -
    line_gap * 0.5;


var direction_y =
    cy +
    line_gap * 0.5;


// ====================================================
// LINE 1
//
// HOLD [CURRENT JUMP BINDING] TO CHARGE JUMP
// ====================================================

var left_w =
    string_width(
        prompt_text_left
    );


var right_w =
    string_width(
        prompt_text_right
    );


var line1_w =
    left_w +
    prompt_gap +
    button_slot_w +
    prompt_gap +
    right_w;


// ====================================================
// LINE 2
//
// [CURRENT LEFT] [CURRENT RIGHT] CHANGE DIRECTION
// ====================================================

var direction_text =
    "CHANGE DIRECTION";


var direction_text_w =
    string_width(
        direction_text
    );


var direction_icon_gap =
    3;


var direction_text_gap =
    6;


var direction_icons_w =
    button_small_slot_w * 2 +
    direction_icon_gap;


var line2_w =
    direction_icons_w +
    direction_text_gap +
    direction_text_w;


// ====================================================
// OVERALL WIDTH
// ====================================================

var total_w =
    max(
        line1_w,
        line2_w
    );


var line1_x =
    cx -
    line1_w * 0.5;


var line2_x =
    cx -
    line2_w * 0.5;


// ====================================================
// BACKGROUND BOX
// ====================================================

var pad_x =
    10;


var pad_y =
    8;


var box_left =
    cx -
    total_w * 0.5 -
    pad_x;


var box_right =
    cx +
    total_w * 0.5 +
    pad_x;


var box_top =
    prompt_y -
    10 -
    pad_y;


var box_bottom =
    direction_y +
    10 +
    pad_y;


draw_set_alpha(
    prompt_bg_alpha *
    popup_alpha
);


draw_set_color(
    prompt_bg_colour
);


draw_rectangle(
    round(box_left),
    round(box_top),
    round(box_right),
    round(box_bottom),
    false
);


// ====================================================
// OUTLINE
// ====================================================

draw_set_alpha(
    popup_alpha
);


draw_set_color(
    make_color_rgb(
        110,
        125,
        135
    )
);


draw_rectangle(
    round(box_left),
    round(box_top),
    round(box_right),
    round(box_bottom),
    true
);


// ============================================================================
// LINE 1 — CHARGE JUMP
// ============================================================================


// ====================================================
// LEFT TEXT
// ====================================================

draw_set_alpha(
    popup_alpha
);


draw_set_color(
    prompt_colour
);


draw_text(
    round(line1_x),
    round(prompt_y),
    prompt_text_left
);


// ====================================================
// CURRENT JUMP BINDING
//
// IMPORTANT:
//
// popup_alpha is passed into the prompt controller,
// meaning the actual key/controller sprite fades at
// exactly the same speed as the surrounding popup.
// ====================================================

var jump_button_x =
    line1_x +
    left_w +
    prompt_gap +
    button_slot_w * 0.5;


ipc.draw_prompt(
    "jump",
    round(jump_button_x),
    round(prompt_y),
    prompt_scale,
    popup_alpha
);


// ====================================================
// RIGHT TEXT
// ====================================================

var jump_right_x =
    line1_x +
    left_w +
    prompt_gap +
    button_slot_w +
    prompt_gap;


draw_set_alpha(
    popup_alpha
);


draw_set_color(
    prompt_colour
);


draw_text(
    round(jump_right_x),
    round(prompt_y),
    prompt_text_right
);


// ============================================================================
// LINE 2 — CHANGE DIRECTION
// ============================================================================


// ====================================================
// ICON POSITIONS
// ====================================================

var direction_left_x =
    line2_x +
    button_small_slot_w * 0.5;


var direction_right_x =
    line2_x +
    button_small_slot_w +
    direction_icon_gap +
    button_small_slot_w * 0.5;


// ====================================================
// CURRENT LEFT BINDING
// ====================================================

ipc.draw_prompt(
    "left",
    round(direction_left_x),
    round(direction_y),
    prompt_scale,
    popup_alpha
);


// ====================================================
// CURRENT RIGHT BINDING
// ====================================================

ipc.draw_prompt(
    "right",
    round(direction_right_x),
    round(direction_y),
    prompt_scale,
    popup_alpha
);


// ====================================================
// CHANGE DIRECTION TEXT
// ====================================================

var direction_text_x =
    line2_x +
    direction_icons_w +
    direction_text_gap;


draw_set_alpha(
    popup_alpha
);


draw_set_color(
    prompt_colour
);


draw_text(
    round(direction_text_x),
    round(direction_y),
    direction_text
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(
    1
);


draw_set_color(
    c_white
);


draw_set_font(
    -1
);


draw_set_halign(
    fa_left
);


draw_set_valign(
    fa_top
);