/// oPinballSmacker — Create

depth = -15000;

sprite_index = spritePinballSmacker;


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

// Additional force directed away from the centre of the
// smacker. This makes glancing impacts feel less flat.
if (!variable_instance_exists(id, "radial_kick"))
{
    radial_kick = 1.25;
}

// Brief player-wide guard preventing several overlapping
// smackers from reversing momentum on the same instant.
if (!variable_instance_exists(id, "hit_lock_ms"))
{
    hit_lock_ms = 70;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// ANIMATION
// ====================================================

// Idle permanently on the first sprite frame.
image_index = 0;
image_speed = 0;

// Animation plays only after an impact.
hit_animation_speed = 1;
hit_animating       = false;


// ====================================================
// COLLISION
// ====================================================

// Circular collision size as a fraction of sprite size.
collision_radius_scale = 0.63;

// This instance only triggers once per continuous overlap.
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

// Maximum copies of PinballSmacker1 playing together.
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