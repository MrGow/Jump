/// oDoubleJumper — Create

depth = -2000;

sprite_index =
    spriteDoubleJumper;

image_speed = 0;
image_index = 0;

enabled = true;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// Upward launch speed.
//
// Higher number = stronger jump.
// Applied internally as negative vsp.
if (!variable_instance_exists(id, "double_jump_power"))
{
    double_jump_power = 6.5;
}


// Animation playback speed.
if (!variable_instance_exists(id, "use_anim_speed"))
{
    use_anim_speed = 0.4;
}


// Debug collision / state.
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// CONTACT / INPUT STATE
// ====================================================

used_this_contact = false;
was_jump_held     = false;


// ====================================================
// ANIMATION STATE
// ====================================================

use_anim_playing = false;