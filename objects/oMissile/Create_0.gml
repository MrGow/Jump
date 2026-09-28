/// oMissile — Create


// ====================================================
// GENERAL
// ====================================================

depth = -1000;

sprite_index =
    spriteMissile;

image_index = 0;
image_speed = 0.22;


// ====================================================
// MOVEMENT
// ====================================================

if (!variable_instance_exists(id, "launch_speed"))
{
    launch_speed = 7.0;
}

vsp =
    -launch_speed;


// ====================================================
// OWNER
// ====================================================

if (!variable_instance_exists(id, "owner_launcher"))
{
    owner_launcher =
        noone;
}


// ====================================================
// SAFETY
//
// Allows it to travel comfortably beyond the room
// before being destroyed.
// ====================================================

destroy_margin = 128;