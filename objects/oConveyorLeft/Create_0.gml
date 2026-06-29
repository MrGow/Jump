/// oConveyorLeft - Create

sprite_index = spriteArea2ConveyorLeft;

// ----------------------------------------------------
// Editor variable
// 1-10
// ----------------------------------------------------
if (!variable_instance_exists(id, "conveyor_speed"))
{
    conveyor_speed = 5;
}

conveyor_speed = clamp(conveyor_speed, 1, 10);

// ----------------------------------------------------
// Conveyor force
// ----------------------------------------------------
belt_speed = -lerp(0.35, 2.5, (conveyor_speed - 1) / 9);

// ----------------------------------------------------
// Animation speed
// ----------------------------------------------------
conveyor_anim_speed = lerp(0.25, 2.0, (conveyor_speed - 1) / 9);
image_speed = conveyor_anim_speed;

surface_offset = 0;

is_conveyor = true;

surface_inset_left  = 0;
surface_inset_right = 0;
surface_y           = bbox_top + surface_offset;

dx = belt_speed;
dy = 0;

enabled = true;
solid_body = false;

// ----------------------------------------------------
// Conveyor loop SFX
// ----------------------------------------------------
snd_conveyor_loop = asset_get_index("ConveyorBeltLoop1");
conveyor_loop_instance = noone;

conveyor_loop_gain = 0.16;
conveyor_loop_pitch = 1.0;

conveyor_loop_inner_dist = 100;
conveyor_loop_outer_dist = 320;