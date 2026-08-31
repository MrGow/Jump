/// oElectricCable — Create

event_inherited();


// ====================================================
// BASIC HAZARD SETUP
// ====================================================

mask_index =
    spriteHazardElectricCableMask;

enabled =
    true;

active =
    true;

solid_body =
    false;

solid_only_when_active =
    false;


sprite_index =
    spriteHazardElectricCable;


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


// GameMaker positive rotation is clockwise visually
// for normal screen coordinates.
//
// Up is our 0-degree authored direction.
image_angle =
    (facing_direction - 1)
    *
    45;


// ====================================================
// ANIMATION
// ====================================================

electric_small_anim_speed =
    0.35;

image_speed =
    electric_small_anim_speed;


// ====================================================
// AUDIO
// ====================================================

snd_electric_small_loop =
    asset_get_index(
        "SmallEelectricCable1"
    );

electric_small_loop_instance =
    noone;

electric_small_loop_gain =
    0.22;

electric_small_loop_pitch =
    1.0;

electric_small_loop_inner_dist =
    80;

electric_small_loop_outer_dist =
    260;


// Only this many closest cables may play at once.
electric_small_loop_max_voices =
    2;


// ====================================================
// HURTBOX
//
// Defined for the DEFAULT UPWARD orientation.
//
// The four corners are rotated for all 8 directions.
// ====================================================

hurt_left =
    -8;

hurt_right =
    8;

hurt_top =
    -22;

hurt_bottom =
    -4;

hurt_inset =
    1;


// ====================================================
// DEBUG
// ====================================================

debug_draw =
    true;


// ====================================================
// HIT LOCK
// ====================================================

player_hit_lock_frames =
    6;


// ====================================================
// GET ROTATED HURT RECT
//
// Returns:
// [left, top, right, bottom]
//
// Since the player collision check uses an axis-aligned
// rectangle, we rotate all four local hurtbox corners
// and then build an AABB around those points.
//
// This supports all 8 facing directions.
// ====================================================

get_hurt_rect =
function()
{
    var hl =
        hurt_left
        +
        hurt_inset;

    var hr =
        hurt_right
        -
        hurt_inset;

    var ht =
        hurt_top
        +
        hurt_inset;

    var hb =
        hurt_bottom
        -
        hurt_inset;


    // -----------------------------------------------
    // Local rectangle corners
    // -----------------------------------------------

    var x1 = hl;
    var y1 = ht;

    var x2 = hr;
    var y2 = ht;

    var x3 = hr;
    var y3 = hb;

    var x4 = hl;
    var y4 = hb;


    // -----------------------------------------------
    // Rotate from authored UP orientation
    // -----------------------------------------------

    var ang =
        image_angle;

    var ca =
        dcos(
            ang
        );

    var sa =
        dsin(
            ang
        );


    var rx1 =
        x1 * ca
        -
        y1 * sa;

    var ry1 =
        x1 * sa
        +
        y1 * ca;


    var rx2 =
        x2 * ca
        -
        y2 * sa;

    var ry2 =
        x2 * sa
        +
        y2 * ca;


    var rx3 =
        x3 * ca
        -
        y3 * sa;

    var ry3 =
        x3 * sa
        +
        y3 * ca;


    var rx4 =
        x4 * ca
        -
        y4 * sa;

    var ry4 =
        x4 * sa
        +
        y4 * ca;


    // -----------------------------------------------
    // Build axis-aligned hurt rectangle
    // -----------------------------------------------

    var l =
        x
        +
        min(
            min(rx1, rx2),
            min(rx3, rx4)
        );

    var r =
        x
        +
        max(
            max(rx1, rx2),
            max(rx3, rx4)
        );

    var t =
        y
        +
        min(
            min(ry1, ry2),
            min(ry3, ry4)
        );

    var b =
        y
        +
        max(
            max(ry1, ry2),
            max(ry3, ry4)
        );


    return [
        l,
        t,
        r,
        b
    ];
};