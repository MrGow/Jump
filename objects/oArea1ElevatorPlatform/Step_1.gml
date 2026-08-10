/// oArea1ElevatorPlatform — Begin Step


// ====================================================
// STORE PREVIOUS POSITION
// ====================================================

prev_x = x;
prev_y = y;


// ====================================================
// DEFAULT: NO MOVEMENT
// ====================================================

var move_y = 0;


// ====================================================
// FIND CONTROLLER
// ====================================================

if (!instance_exists(controller))
{
    controller =
        instance_find(
            oArea1ElevatorController,
            0
        );
}


// ====================================================
// READ CONTROLLER MOVEMENT
// ====================================================

if (
    instance_exists(controller) &&
    !scr_game_frozen()
)
{
    move_y =
        controller.platform_move_y;
}


// ====================================================
// MOVE PLATFORM
// ====================================================

y += move_y;


// ====================================================
// MOVEMENT DELTAS
//
// oPlayer reads these to inherit platform motion.
// ====================================================

dx =
    x -
    prev_x;

dy =
    y -
    prev_y;


// ====================================================
// UPDATE STANDING SURFACE
// ====================================================

surface_y =
    bbox_top;