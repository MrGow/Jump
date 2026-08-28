/// oTutorialPopup — Create


// ====================================================
// SETUP
// ====================================================

// Must remain visible so Draw runs.
//
// The trigger sprite itself will NOT be drawn because
// our custom Draw event never calls draw_self().
visible =
    true;


// ====================================================
// POPUP STATE
// ====================================================

popup_active =
    false;


popup_alpha =
    0;


// ====================================================
// FADE
// ====================================================

if (!variable_instance_exists(id, "fade_speed"))
{
    fade_speed =
        0.10;
}


// ====================================================
// SCREEN POSITION
//
// Because this is drawn in the normal Draw event,
// Step calculates a WORLD position corresponding to a
// fixed location inside the current camera.
//
// 0.5 = horizontal centre
// 0.78 = lower portion of screen
// ====================================================

if (!variable_instance_exists(id, "popup_screen_x"))
{
    popup_screen_x =
        0.5;
}


if (!variable_instance_exists(id, "popup_screen_y"))
{
    popup_screen_y =
        0.78;
}


popup_draw_x =
    x;


popup_draw_y =
    y;


// ====================================================
// BOB
// ====================================================

bob_phase =
    0;


if (!variable_instance_exists(id, "bob_height"))
{
    bob_height =
        3;
}


if (!variable_instance_exists(id, "bob_speed"))
{
    bob_speed =
        0.055;
}


// ====================================================
// PROMPT APPEARANCE
// ====================================================

if (!variable_instance_exists(id, "prompt_scale"))
{
    prompt_scale =
        1;
}


if (!variable_instance_exists(id, "prompt_gap"))
{
    prompt_gap =
        7;
}


// Same cool-white family as B1LL-E dialogue.
prompt_colour =
    make_color_rgb(
        225,
        232,
        235
    );


prompt_bg_colour =
    make_color_rgb(
        8,
        12,
        20
    );


if (!variable_instance_exists(id, "prompt_bg_alpha"))
{
    prompt_bg_alpha =
        0.88;
}


// ====================================================
// FONT
// ====================================================

prompt_font =
    asset_get_index(
        "PIXELOPERATORBOLD14"
    );


// ====================================================
// TEXT
// ====================================================

prompt_text_left =
    "HOLD";


prompt_text_right =
    "TO CHARGE JUMP";