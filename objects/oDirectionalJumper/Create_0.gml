/// oDirectionalJumper — Create

depth = -20000;

sprite_index = spriteDirectionalJumper;

image_speed = 0;
image_index = 0;

enabled = true;
debug_draw = false;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Direction
//
// 0 = right
// 1 = up-right
// 2 = up
// 3 = up-left
// 4 = left
// 5 = down-left
// 6 = down
// 7 = down-right
// ----------------------------------------------------
if (!variable_instance_exists(id, "jump_direction"))
{
    jump_direction = 2;
}


// ----------------------------------------------------
// Strength
//
// 1 = very weak
// 10 = extremely powerful
// ----------------------------------------------------
if (!variable_instance_exists(id, "jump_strength"))
{
    jump_strength = 5;
}


// ----------------------------------------------------
// On-use animation speed
// ----------------------------------------------------
if (!variable_instance_exists(id, "use_anim_speed"))
{
    use_anim_speed = 1;
}


// ====================================================
// STRENGTH TUNING
//
// Level 1  = 5.5 speed
// Level 5  = 9.5 speed
// Level 10 = 14.5 speed
// ====================================================

minimum_launch_speed = 5.5;
speed_per_level      = 1.0;


// ====================================================
// CONTACT / INPUT STATE
// ====================================================

used_this_contact = false;
was_jump_held     = false;


// ====================================================
// ANIMATION STATE
// ====================================================

use_anim_playing = false;


// ====================================================
// ROTATION
//
// Source sprite is authored pointing RIGHT.
//
// GameMaker direction angles already match our
// jump_direction numbering:
//
// 0 = right       =   0°
// 1 = up-right    =  45°
// 2 = up          =  90°
// 3 = up-left     = 135°
// 4 = left        = 180°
// 5 = down-left   = 225°
// 6 = down        = 270°
// 7 = down-right  = 315°
// ====================================================

update_rotation = function()
{
    jump_direction =
        ((round(jump_direction) mod 8) + 8) mod 8;

    jump_strength =
        clamp(
            round(jump_strength),
            1,
            10
        );

    var launch_angle =
        jump_direction * 45;

    // spriteDirectionalJumper points RIGHT by default,
    // so no rotational offset is required.
    image_angle =
        launch_angle;
};

update_rotation();

update_rotation();