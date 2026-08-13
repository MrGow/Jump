/// oZeroGravityZone — Create

sprite_index =
    spriteZeroGravityZone;

image_speed = 0;

enabled = true;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// VISUAL
//
// Your actual animated zero-gravity tiles are placed
// separately in the room.
//
// This sprite only defines the gameplay zone.
// ====================================================

visible = true;
image_alpha = 0;