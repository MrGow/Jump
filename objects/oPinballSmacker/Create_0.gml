/// oPinballSmacker — Create

depth = -15000;

// ----------------------------------------------------
// Visual sprite and permanent collision mask
// ----------------------------------------------------
sprite_index = spritePinballSmacker;
mask_index   = spritePinballSmackerMaskSolid;

// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

// Multiplies the player's reversed incoming speed.
if (!variable_instance_exists(id, "reverse_multiplier"))
{
    reverse_multiplier = 1.10;
}

// Minimum total rebound speed.
if (!variable_instance_exists(id, "minimum_launch_speed"))
{
    minimum_launch_speed = 3.5;
}

// Maximum total rebound speed.
if (!variable_instance_exists(id, "maximum_launch_speed"))
{
    maximum_launch_speed = 11;
}

// Additional force directed away from the centre of the smacker.
if (!variable_instance_exists(id, "radial_kick"))
{
    radial_kick = 1.25;
}

// Prevents several overlapping smackers from reversing
// the player repeatedly during the same instant.
if (!variable_instance_exists(id, "hit_lock_ms"))
{
    hit_lock_ms = 70;
}

// Set true to display the permanent collision mask.
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

// Optional mask display opacity.
if (!variable_instance_exists(id, "debug_mask_alpha"))
{
    debug_mask_alpha = 0.35;
}

// ====================================================
// ANIMATION
// ====================================================

// Rest permanently on frame zero until hit.
image_index = 0;
image_speed = 0;

hit_animation_speed = 1;
hit_animating       = false;

// ====================================================
// COLLISION STATE
// ====================================================

// Trigger only once during each continuous overlap.
player_was_inside = false;

// ====================================================
// VISUAL FEEDBACK
// ====================================================

hit_flash     = 0;
hit_flash_max = 5;

// ====================================================
// SOUND
// ====================================================

snd_hit =
    asset_get_index("PinballSmacker1");

sfx_gain      = 0.55;
sfx_pitch_min = 0.96;
sfx_pitch_max = 1.04;

// Minimum time between smacker sounds globally.
sfx_shared_gap_ms = 55;

// Maximum copies playing simultaneously.
sfx_max_instances = 3;

// ----------------------------------------------------
// Shared sound state
// ----------------------------------------------------
if (!variable_global_exists("pinball_sfx_next_time"))
{
    global.pinball_sfx_next_time = 0;
}

if (!variable_global_exists("pinball_sfx_ids"))
{
    global.pinball_sfx_ids =
        array_create(
            sfx_max_instances,
            -1
        );
}