/// oPendulumSaw — Create

event_inherited();

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;


// ====================================================
// SPRITES
// ====================================================

base_sprite =
    spritePendulumSawBase;

chain_sprite =
    spritePendulumSawChain;

saw_sprite =
    spritePendulumSawSaw;


// We draw everything manually.
sprite_index = -1;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Chain length
// ----------------------------------------------------
if (!variable_instance_exists(id, "chain_length"))
{
    chain_length = 120;
}


// ----------------------------------------------------
// Swing arc
//
// Maximum degrees either side of straight down.
//
// Examples:
// 25 = mild
// 45 = normal
// 65 = aggressive
// ----------------------------------------------------
if (!variable_instance_exists(id, "swing_arc"))
{
    swing_arc = 45;
}


// ----------------------------------------------------
// Swing speed
//
// 1.0 = normal
// ----------------------------------------------------
if (!variable_instance_exists(id, "swing_speed"))
{
    swing_speed = 1.0;
}


// ----------------------------------------------------
// Swing starting phase in degrees.
//
// Useful for offsetting multiple pendulums.
//
// 0   = centre, moving one way
// 90  = one extreme
// 180 = centre, opposite motion
// 270 = other extreme
// ----------------------------------------------------
if (!variable_instance_exists(id, "swing_start_phase"))
{
    swing_start_phase = 0;
}


// ----------------------------------------------------
// Horizontal rail movement
// ----------------------------------------------------
if (!variable_instance_exists(id, "rail_enabled"))
{
    rail_enabled = false;
}


// Total horizontal travel width.
//
// Example:
// 160 means 80 px left and 80 px right
// from the placed position.
// ----------------------------------------------------
if (!variable_instance_exists(id, "rail_distance"))
{
    rail_distance = 160;
}


// Rail speed multiplier.
if (!variable_instance_exists(id, "rail_speed"))
{
    rail_speed = 1.0;
}


// Rail starting phase in degrees.
if (!variable_instance_exists(id, "rail_start_phase"))
{
    rail_start_phase = 0;
}


// ----------------------------------------------------
// Saw lethal radius
// ----------------------------------------------------
if (!variable_instance_exists(id, "saw_hit_radius"))
{
    saw_hit_radius = 18;
}


// ----------------------------------------------------
// Small visual offset from anchor to where the chain
// actually begins under the ceiling base.
// ----------------------------------------------------
if (!variable_instance_exists(id, "chain_start_offset"))
{
    chain_start_offset = 4;
}


// ----------------------------------------------------
// Small visual offset from saw centre to where chain
// should stop so it looks attached instead of running
// through the saw.
// ----------------------------------------------------
if (!variable_instance_exists(id, "chain_end_offset"))
{
    chain_end_offset = 24;
}


// ----------------------------------------------------
// Saw animation
//
// If spritePendulumSawSaw has multiple frames,
// this lets it spin/animate.
// ----------------------------------------------------
if (!variable_instance_exists(id, "saw_anim_speed"))
{
    saw_anim_speed = 0.30;
}


// ----------------------------------------------------
// Debug
// ----------------------------------------------------
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// ORIGINAL PLACED POSITION
// ====================================================

origin_x = x;
origin_y = y;


// ====================================================
// PHASES
// ====================================================

swing_phase =
    degtorad(
        swing_start_phase
    );

rail_phase =
    degtorad(
        rail_start_phase
    );


// ====================================================
// PHASE SPEEDS
//
// These values are deliberately fairly gentle.
// Tune swing_speed / rail_speed in the editor.
// ====================================================

swing_phase_speed =
    (2 * pi / room_speed) *
    0.75;

rail_phase_speed =
    (2 * pi / room_speed) *
    0.50;


// ====================================================
// INITIAL POSITIONS
// ====================================================

anchor_x = origin_x;
anchor_y = origin_y;

swing_angle = 0;

saw_x = anchor_x;
saw_y = anchor_y + chain_length;


// ====================================================
// SAW ANIMATION
// ====================================================

saw_image_index = 0;