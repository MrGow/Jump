/// oArea1ElevatorController — End Step


// ====================================================
// CAMERA OVERRIDE SAFETY
//
// IMPORTANT:
//
// Unlike normal gameplay movement, the elevator camera
// must remain attached to the elevator even while the
// game is frozen during:
//
// - death delay
// - death menu
// - pause
//
// The platform itself is frozen, so this simply keeps
// its exact screen composition instead of letting the
// normal camera/death camera expose the bottom of the
// huge elevator sprite.
// ====================================================

if (
    !camera_override_active ||
    !instance_exists(platform)
)
{
    exit;
}


// ====================================================
// PLATFORM SURFACE
// ====================================================

var platform_surface_y =
    platform.y;


if (
    variable_instance_exists(
        platform,
        "surface_y"
    )
)
{
    platform_surface_y =
        platform.surface_y;
}


// ====================================================
// CAMERA POSITION
//
// Preserve the same screen-space relationship between
// the camera and elevator that was captured when the
// sequence began.
// ====================================================

camera_x =
    start_cam_x;

camera_y =
    platform_surface_y -
    camera_platform_offset_y;


// ====================================================
// ROOM SAFETY
// ====================================================

camera_x =
    clamp(
        camera_x,
        0,
        max(
            0,
            room_width -
            view_w
        )
    );


camera_y =
    clamp(
        camera_y,
        0,
        max(
            0,
            room_height -
            view_h
        )
    );


// ====================================================
// APPLY CAMERA
//
// This deliberately also runs while scr_game_frozen()
// is true.
//
// Platform x/y are not moving during freeze, so the
// camera itself is also effectively frozen — just at
// the CORRECT elevator-relative position.
// ====================================================

camera_set_view_pos(
    cam,
    round(camera_x),
    round(camera_y)
);


// ====================================================
// KEEP NORMAL CAMERA SYNCHRONISED
// ====================================================

var normal_camera =
    instance_find(
        oCamera,
        0
    );


if (normal_camera != noone)
{
    if (
        variable_instance_exists(
            normal_camera,
            "cam_logic_x"
        )
    )
    {
        normal_camera.cam_logic_x =
            round(camera_x);
    }


    if (
        variable_instance_exists(
            normal_camera,
            "cam_logic_y"
        )
    )
    {
        normal_camera.cam_logic_y =
            round(camera_y);
    }
}