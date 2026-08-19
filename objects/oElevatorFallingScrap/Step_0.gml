/// oElevatorFallingScrap — Step
// ====================================================
// DEATH CLEANUP
//
// A same-room respawn keeps dynamically created room
// instances alive. Remove old scrap during the death flow
// so a previous attempt cannot carry into the next one.
// This must run before scr_game_frozen() exits the event.
// ====================================================

if (
    variable_global_exists("game_phase") &&
    (
        global.game_phase == "death_delay" ||
        global.game_phase == "death_menu"
    )
)
{
    instance_destroy();
    exit;
}



// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


if (!active)
{
    exit;
}


// ====================================================
// FALL
// ====================================================

fall_speed =
    min(
        fall_speed +
        fall_acceleration,

        max_fall_speed
    );


y +=
    fall_speed;


// ====================================================
// ROTATE
// ====================================================

image_angle +=
    rotation_speed;


// ====================================================
// PLAYER COLLISION
// ====================================================

var p =
    instance_place(
        x,
        y,
        oPlayer
    );


if (p != noone)
{
    if (
        variable_instance_exists(
            p,
            "state"
        ) &&
        p.state != "dead"
    )
    {
        with (p)
        {
            scr_player_died();
        }
    }
}


// ====================================================
// DESTROY BELOW CAMERA
// ====================================================

var cam =
    view_camera[0];


if (cam != -1)
{
    var cam_y =
        camera_get_view_y(
            cam
        );

    var cam_h =
        camera_get_view_height(
            cam
        );


    if (
        bbox_top >
        cam_y +
        cam_h +
        cleanup_margin
    )
    {
        instance_destroy();
        exit;
    }
}