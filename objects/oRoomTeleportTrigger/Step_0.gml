/// oRoomTeleportTrigger — Step

if (!enabled)
{
    exit;
}


// ====================================================
// GLOBAL TRANSITION LOCK
// ====================================================

if (
    variable_global_exists(
        "room_teleport_active"
    ) &&
    global.room_teleport_active
)
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
// PLAYER OVERLAP
// ====================================================

var hit =
    p.bbox_right > bbox_left &&
    p.bbox_left < bbox_right &&
    p.bbox_bottom > bbox_top &&
    p.bbox_top < bbox_bottom;


// ====================================================
// ARRIVAL LOCKOUT
//
// A trigger disabled by the destination controller must
// remain disabled until the player has completely left
// its collision rectangle.
// ====================================================

if (!armed)
{
    if (!hit)
    {
        armed = true;
    }

    exit;
}


// ====================================================
// START ROOM TELEPORT
// ====================================================

if (hit)
{
    armed = false;


    // ------------------------------------------------
    // Capture the player's actual displayed direction
    // before the original player instance is destroyed.
    //
    // image_xscale is used first because it is the final
    // direction currently being drawn on screen.
    // ------------------------------------------------

    var captured_facing =
        sign(p.image_xscale);

    if (captured_facing == 0)
    {
        if (
            variable_instance_exists(
                p,
                "facing"
            )
        )
        {
            captured_facing =
                sign(p.facing);
        }
    }

    if (captured_facing == 0)
    {
        captured_facing = 1;
    }


    // Store globally so room_goto() cannot discard it.
    global.room_teleport_entry_facing =
        captured_facing;


    // ------------------------------------------------
    // Create persistent transition controller
    // ------------------------------------------------

    var c =
        instance_create_depth(
            0,
            0,
            -1000,
            oRoomTeleportController
        );


    // Keep a controller-local copy as a fallback.
    c.entry_facing =
        captured_facing;


    // ------------------------------------------------
    // Destination
    // ------------------------------------------------

    c.target_room =
        target_room;

    c.target_spawn =
        target_spawn;


    // ------------------------------------------------
    // Area-title presentation
    // ------------------------------------------------

    c.area_name =
        area_name;

    c.show_area_name =
        show_area_name;
}