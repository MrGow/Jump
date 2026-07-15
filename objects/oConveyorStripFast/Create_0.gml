/// oConveyorStripFast — Create

depth = -20000;

enabled    = true;
debug_draw = false;


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
if (!variable_instance_exists(id, "flow_direction"))
{
    flow_direction = 0;
}

auto_rotate_sprite = true;


// ----------------------------------------------------
// Animation
// ----------------------------------------------------
normal_image_speed = 0.35;
image_speed = normal_image_speed;


// ----------------------------------------------------
// Conveyor force
// ----------------------------------------------------
push_accel = 0.38;
entry_kick = 0.75;

max_forward_speed = 11.0;

// Lower values align the player more strongly
// with the strip's movement direction.
side_damping = 0.82;


// ----------------------------------------------------
// Contact state
// ----------------------------------------------------
player_inside_previous = false;


// ----------------------------------------------------
// Entry sound
// ----------------------------------------------------
snd_entry = asset_get_index("GravityStripGreen");

sfx_gain      = 0.35;
sfx_pitch_min = 0.96;
sfx_pitch_max = 1.04;

// Minimum frames between green-strip sounds globally.
sfx_global_cooldown_frames = 5;


// ----------------------------------------------------
// Shared green-strip sound state
// ----------------------------------------------------
if (!variable_global_exists("green_strip_sfx_cooldown"))
{
    global.green_strip_sfx_cooldown = 0;
}

if (!variable_global_exists("green_strip_sfx_ids"))
{
    // Maximum of two overlapping green sounds.
    global.green_strip_sfx_ids = [-1, -1];
}