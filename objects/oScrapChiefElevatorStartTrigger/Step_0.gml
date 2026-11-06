/// oScrapChiefElevatorStartTrigger — Step

if (activated || scr_game_frozen())
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}


// ====================================================
// REFERENCES
// ====================================================

if (!instance_exists(controller))
{
    controller = instance_find(
        oScrapChiefController,
        0
    );
}

if (!instance_exists(platform))
{
    platform = instance_find(
        oScrapChiefElevator,
        0
    );
}

if (!instance_exists(controller))
{
    exit;
}

if (!instance_exists(platform))
{
    exit;
}


// ====================================================
// TRIGGER RECTANGLE
//
// Uses the actual sprite collision bounds.
// Respects sprite origin and instance scaling.
// ====================================================

var left   = bbox_left;
var right  = bbox_right;
var top    = bbox_top;
var bottom = bbox_bottom;


// ====================================================
// PLAYER OVERLAP
// ====================================================

var player_inside =
    p.bbox_right > left &&
    p.bbox_left < right &&
    p.bbox_bottom > top &&
    p.bbox_top < bottom;

if (!player_inside)
{
    exit;
}


// ====================================================
// MUST BE STANDING ON ELEVATOR
// ====================================================

if (require_platform)
{
    var standing_on_elevator =
        variable_instance_exists(
            p,
            "standing_platform"
        )
        &&
        p.standing_platform == platform;

    if (!standing_on_elevator)
    {
        exit;
    }
}


// ====================================================
// ACTIVATE
// ====================================================

if (
    variable_instance_exists(
        controller,
        "start_elevator"
    )
    &&
    is_callable(controller.start_elevator)
)
{
    activated = true;

    controller.start_elevator();
}