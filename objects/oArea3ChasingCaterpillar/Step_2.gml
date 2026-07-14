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
// Freeze movement and collision during pause/death
if (scr_game_frozen())
{
    exit;
}

var ctrl =
    instance_find(oUpwardsChaseController, 0);


// ----------------------------------------------------
// Chase movement only while active
// ----------------------------------------------------
if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    // Burst upward toward the player
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

    // Follow the bottom edge of the camera.
    //
    // Increasing burst_offset subtracts more Y,
    // moving the caterpillar upward into the screen.
    x =
        ctrl.cam_x +
        screen_offset_x;

    y =
        ctrl.cam_y +
        screen_offset_y -
        burst_offset;
}


// ----------------------------------------------------
// Kill player on contact at all times,
// including while resting before activation
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