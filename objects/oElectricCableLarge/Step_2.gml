/// oElectricCableLarge — End Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ONLY DANGEROUS WHILE ACTIVE
// ====================================================

if (!enabled)
{
    exit;
}


if (!active)
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


if (p == noone)
{
    exit;
}


// Already dead.
if (
    variable_instance_exists(
        p,
        "state"
    )
    &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// HIT LOCK
// ====================================================

if (!variable_instance_exists(p, "electric_hit_lock"))
{
    p.electric_hit_lock =
        0;
}


if (p.electric_hit_lock > 0)
{
    p.electric_hit_lock--;

    exit;
}


// ====================================================
// COLLISION
//
// Uses spriteHazardElectricCableLargeMask.
//
// Because mask_index belongs to this instance,
// image_angle rotates the lethal mask with all eight
// facing directions.
// ====================================================

var hit_player =
    instance_place(
        x,
        y,
        oPlayer
    );


if (hit_player == noone)
{
    exit;
}


// ====================================================
// KILL
// ====================================================

with (hit_player)
{
    if (state == "dead")
    {
        exit;
    }


    scr_player_died(
    undefined,
    false,
    undefined,
    undefined,
    "electrocute"
);


    electric_hit_lock =
        other.player_hit_lock_frames;
}