/// oArea1ElevatorActivationTrigger — Step


// ====================================================
// SAFETY
// ====================================================

if (activated)
{
    exit;
}


if (scr_game_frozen())
{
    exit;
}


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
// REFRESH REFERENCES
// ====================================================

if (!instance_exists(controller))
{
    controller =
        instance_find(
            oArea1ElevatorController,
            0
        );
}


if (!instance_exists(platform))
{
    platform =
        instance_find(
            oArea1ElevatorPlatform,
            0
        );
}


if (!instance_exists(controller))
{
    exit;
}


// ====================================================
// TRIGGER RECTANGLE
// ====================================================

var left =
    x -
    trigger_width * 0.5;

var right =
    x +
    trigger_width * 0.5;

var top =
    y -
    trigger_height * 0.5;

var bottom =
    y +
    trigger_height * 0.5;


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
// OPTIONAL: MUST BE STANDING ON ELEVATOR
// ====================================================

if (require_platform)
{
    var standing_on_elevator =
        variable_instance_exists(
            p,
            "standing_platform"
        )
        &&
        p.standing_platform ==
        platform;


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
    is_callable(
        controller.start_elevator
    )
)
{
    activated = true;

    controller.start_elevator();
}