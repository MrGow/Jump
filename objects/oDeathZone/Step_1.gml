/// oDeathZone — Begin Step

if (!enabled)
{
    exit;
}


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "death_shake_strength"))
{
    death_shake_strength = 6;
}

if (!variable_instance_exists(id, "death_shake_frames"))
{
    death_shake_frames = 8;
}

if (
    !variable_instance_exists(id, "update_rect") ||
    !is_callable(update_rect)
)
{
    exit;
}


// ====================================================
// UPDATE COLLISION RECTANGLE
// ====================================================

update_rect();


// ====================================================
// FIND PLAYER
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
// DO NOT RETRIGGER AN EXISTING DEATH
// ====================================================

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// PLAYER BBOX OVERLAP
// ====================================================

var overlap =
    p.bbox_right  > left &&
    p.bbox_left   < right &&
    p.bbox_bottom > top &&
    p.bbox_top    < bottom;


// ====================================================
// OFFSCREEN FALL DEATH
// ====================================================

if (overlap)
{
    var shake_strength =
        death_shake_strength;

    var shake_frames =
        death_shake_frames;

    with (p)
    {
        scr_player_died(
            undefined,
            true,
            shake_strength,
            shake_frames,
            "fall"
        );
    }
}