/// oConveyorStripBrake — Create

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
// Braking force
// ----------------------------------------------------

// Controlled movement speed that the strip tries
// to bring the player toward.
brake_target_speed = 2.5;

// Continuous braking strength.
brake_lerp = 0.16;

// Stronger initial braking when entering a new strip.
entry_brake_lerp = 0.30;

// Align player with strip direction.
side_damping = 0.78;


// ----------------------------------------------------
// Contact state
// ----------------------------------------------------
player_inside_previous = false;


// ----------------------------------------------------
// Entry sound
// ----------------------------------------------------
snd_entry = asset_get_index("GravityStripRed");

sfx_gain      = 0.35;
sfx_pitch_min = 0.96;
sfx_pitch_max = 1.04;

sfx_global_cooldown_frames = 5;


// ----------------------------------------------------
// Shared red-strip sound state
// ----------------------------------------------------
if (!variable_global_exists("red_strip_sfx_cooldown"))
{
    global.red_strip_sfx_cooldown = 0;
}

if (!variable_global_exists("red_strip_sfx_ids"))
{
    // Maximum of two overlapping red sounds.
    global.red_strip_sfx_ids = [-1, -1];
}