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
// TEXT WIDTH
// ====================================================

var left_w =
    string_width(
        prompt_text_left
    );


var right_w =
    string_width(
        prompt_text_right
    );


// ====================================================
// BUTTON SLOT
//
// Fixed width means switching between Space and A does
// not cause the whole sentence to jump horizontally.
// ====================================================

var button_slot_w =
    34 *
    prompt_scale;


var total_w =
    left_w +
    prompt_gap +
    button_slot_w +
    prompt_gap +
    right_w;


var start_x =
    cx -
    total_w *
    0.5;


// ====================================================
// BACKGROUND BOX
// ====================================================

var pad_x = 10;

var pad_y = 7;


var box_left =
    start_x -
    pad_x;


var box_right =
    start_x +
    total_w +
    pad_x;


var box_top =
    cy -
    12 -
    pad_y;


var box_bottom =
    cy +
    12 +
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


// ====================================================
// LEFT TEXT
// ====================================================

draw_set_color(
    prompt_colour
);


draw_text(
    round(start_x),
    cy,
    prompt_text_left
);


// ====================================================
// BUTTON
// ====================================================

var button_x =
    start_x +
    left_w +
    prompt_gap +
    button_slot_w *
    0.5;


ipc.draw_prompt(
    "jump",
    round(button_x),
    cy,
    prompt_scale
);


// ====================================================
// RIGHT TEXT
// ====================================================

var right_x =
    start_x +
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
    round(right_x),
    cy,
    prompt_text_right
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);

draw_set_color(c_white);

draw_set_font(-1);

draw_set_halign(fa_left);

draw_set_valign(fa_top);
