/// oArea2ChasingSaws — End Step

// ----------------------------------------------------
// Freeze sprite animation during pause/death
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}

// Resume normal saw animation
if (image_speed == 0)
{
    image_speed = 1;
}

// Existing chase movement/collision code continues below...

// ----------------------------------------------------
// Freeze both movement and collision during pause/death
// ----------------------------------------------------
if (scr_game_frozen())
{
    exit;
}


// ----------------------------------------------------
// Find horizontal chase controller
// ----------------------------------------------------
var ctrl =
    instance_find(oHorizontalChaseController, 0);


// ----------------------------------------------------
// Chase movement
// ----------------------------------------------------
if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    // ------------------------------------------------
    // Temporary burst movement
    // ------------------------------------------------
    if (burst_active)
    {
        burst_offset += burst_speed;

        if (burst_offset >= burst_target)
        {
            burst_offset = burst_target;
            burst_active = false;
            burst_speed  = 0;
        }
    }

    // ------------------------------------------------
    // Follow left side of camera
    //
    // Positive burst_offset moves the saw farther
    // right into the playable screen.
    // ------------------------------------------------
    x =
        ctrl.cam_x +
        screen_offset_x +
        burst_offset;

    y =
        ctrl.cam_y +
        screen_offset_y;
}


// ----------------------------------------------------
// Kill player on contact
//
// This remains active while the saw is resting,
// provided the game itself is not frozen.
// ----------------------------------------------------
var p = instance_place(x, y, oPlayer);

if (p != noone)
{
    if (
        variable_instance_exists(p, "state") &&
        p.state != "dead"
    )
    {
        with (p)
        {
            scr_player_died();
        }
    }
}