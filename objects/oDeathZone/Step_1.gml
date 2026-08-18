/// oDeathZone — Begin Step

if (!enabled)
{
    exit;
}


// ====================================================
// OPTIONAL FOLLOW TARGET
//
// This is done in Begin Step so the death zone is
// already underneath the elevator BEFORE testing the
// player this frame.
// ====================================================

if (
    follow_active &&
    instance_exists(
        follow_target
    )
)
{
    update_rect();


    // ------------------------------------------------
    // Vertical follow:
    // put the TOP edge just underneath target bbox.
    // ------------------------------------------------

    var desired_top =
        follow_target.bbox_bottom +
        follow_gap_y;


    y +=
        desired_top -
        top;


    // ------------------------------------------------
    // Optional horizontal follow.
    //
    // Normally false because the elevator death zone
    // should be wide enough to cover the whole shaft.
    // ------------------------------------------------

    if (follow_x)
    {
        x =
            follow_target.x +
            follow_offset_x;
    }
}


update_rect();


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


// Don't retrigger if already dead.
if (
    variable_instance_exists(
        p,
        "state"
    ) &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// OVERLAP
// ====================================================

var overlap =
    p.bbox_right >
    left
    &&
    p.bbox_left <
    right
    &&
    p.bbox_bottom >
    top
    &&
    p.bbox_top <
    bottom;


if (overlap)
{
    with (p)
    {
        scr_player_died(
            undefined,
            true
        );
    }
}