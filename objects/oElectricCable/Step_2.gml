/// oElectricCable — End Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ALWAYS LETHAL
//
// No active/inactive blinking logic.
// If enabled gameplay is running, touching the
// electrical hurtbox kills.
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


// ====================================================
// PLAYER HIT LOCK
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
// HURTBOX
// ====================================================

var rr =
    get_hurt_rect();


var l =
    rr[0];

var t =
    rr[1];

var r =
    rr[2];

var b =
    rr[3];


var hit =
    p.bbox_right > l
    &&
    p.bbox_left < r
    &&
    p.bbox_bottom > t
    &&
    p.bbox_top < b;


if (!hit)
{
    exit;
}


// ====================================================
// KILL PLAYER
// ====================================================

with (p)
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