/// oElectricCableLarge — Create

event_inherited();


// ====================================================
// BASIC SETUP
// ====================================================

sprite_index =
    spriteHazardElectricCableLarge;

mask_index =
    spriteHazardElectricCableLargeMask;


enabled =
    true;

// Begins switched off.
active =
    false;


solid_body =
    false;

solid_only_when_active =
    false;


// ====================================================
// FACING
//
// 1 = Up
// 2 = Northeast
// 3 = Right
// 4 = Southeast
// 5 = Down
// 6 = Southwest
// 7 = Left
// 8 = Northwest
//
// Sprite is authored facing UP.
// ====================================================

if (!variable_instance_exists(id, "facing_direction"))
{
    facing_direction = 1;
}


facing_direction =
    clamp(
        round(facing_direction),
        1,
        8
    );


image_angle =
    (facing_direction - 1)
    *
    45;


// ====================================================
// ANIMATION
// ====================================================

cable_anim_speed =
    0.35;


// We control image_index ourselves so that we can
// cleanly pause on the OFF and ON frames.
image_speed =
    0;

image_index =
    0;


// ====================================================
// DANGEROUS FRAMES
// ====================================================

if (!variable_instance_exists(id, "active_from"))
{
    active_from = 6;
}


if (!variable_instance_exists(id, "active_to"))
{
    active_to = 13;
}


// ====================================================
// HOLD TIMES
//
// How long the cable waits completely OFF before
// beginning another activation.
//
// How long it remains held on the final dangerous
// frame before beginning the shut-down animation.
// ====================================================

if (!variable_instance_exists(id, "off_hold_frames"))
{
    off_hold_frames = 60;
}


if (!variable_instance_exists(id, "on_hold_frames"))
{
    on_hold_frames = 0;
}


off_hold_frames =
    max(
        0,
        round(off_hold_frames)
    );


on_hold_frames =
    max(
        0,
        round(on_hold_frames)
    );


// ====================================================
// CYCLE STATE
//
// "off_hold"
// "turning_on"
// "on_hold"
// "turning_off"
// ====================================================

cable_state =
    "off_hold";


cable_state_timer =
    off_hold_frames;


// ====================================================
// PLAYER HIT
// ====================================================

player_hit_lock_frames =
    6;


// ====================================================
// DEBUG
// ====================================================

debug_draw =
    false;


// ====================================================
// ELECTRIC LOOP SFX
// ====================================================

snd_electric_loop =
    asset_get_index(
        "LargeElectricCableSound"
    );


electric_loop_instance =
    noone;


electric_loop_gain =
    0.35;

electric_loop_pitch =
    1.0;


electric_loop_inner_dist =
    90;

electric_loop_outer_dist =
    320;


// ====================================================
// PHYSICAL CABLE COLLISION
// ====================================================

solid_inst =
    instance_create_layer(
        x,
        y,
        layer,
        oElectricCableLargeSolid
    );


if (instance_exists(solid_inst))
{
    solid_inst.image_angle =
        image_angle;
}