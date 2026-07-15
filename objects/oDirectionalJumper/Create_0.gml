/// oDirectionalJumper — Create

depth = -20000;

sprite_index = spriteDirectionalJumper;
image_speed  = 0;

enabled    = true;
debug_draw = false;

// ----------------------------------------------------
// Editor variables
// ----------------------------------------------------

// 0 = right
// 1 = up-right
// 2 = up
// 3 = up-left
// 4 = left
// 5 = down-left
// 6 = down
// 7 = down-right
if (!variable_instance_exists(id, "jump_direction"))
{
    jump_direction = 2;
}

// 1 = very weak
// 10 = extremely powerful
if (!variable_instance_exists(id, "jump_strength"))
{
    jump_strength = 5;
}

// ----------------------------------------------------
// Strength tuning
//
// Level 1  = 5.5 speed
// Level 5  = 9.5 speed
// Level 10 = 14.5 speed
// ----------------------------------------------------
minimum_launch_speed = 5.5;
speed_per_level      = 1.0;

// ----------------------------------------------------
// Contact/input state
// ----------------------------------------------------
used_this_contact = false;
was_jump_held     = false;

// ----------------------------------------------------
// Rotate upward-facing source artwork
// ----------------------------------------------------
update_rotation = function()
{
    jump_direction =
        ((round(jump_direction) mod 8) + 8) mod 8;

    jump_strength =
        clamp(round(jump_strength), 1, 10);

    var launch_angle = jump_direction * 45;

    // Source sprite points upward at 90 degrees.
    image_angle = launch_angle - 90;
};

update_rotation();