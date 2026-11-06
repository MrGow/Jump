/// oScrapChiefController — End Step

// ====================================================
// CAMERA OVERRIDE
// ====================================================

if (!camera_override_active)
{
    exit;
}

if (!instance_exists(platform))
{
    exit;
}


// ====================================================
// CAMERA POSITION
// ====================================================

camera_x =
    platform.x -
    camera_platform_offset_x;


// Vertical camera position stays fixed.
camera_x = clamp(
    camera_x,
    0,
    max(0, room_width - view_w)
);

camera_y = clamp(
    camera_y,
    0,
    max(0, room_height - view_h)
);


// ====================================================
// APPLY CAMERA
// ====================================================

camera_set_view_pos(
    cam,
    round(camera_x),
    round(camera_y)
);


// ====================================================
// SYNCHRONISE NORMAL CAMERA
// ====================================================

var normal_camera = instance_find(
    oCamera,
    0
);

if (normal_camera != noone)
{
    normal_camera.cam_logic_x =
        round(camera_x);

    normal_camera.cam_logic_y =
        round(camera_y);
}


// ====================================================
// DOCKING CAMERA HANDOFF
// ====================================================

if (elevator_state == 11)
{
    camera_override_active = false;

    if (normal_camera != noone)
    {
        normal_camera.arena_lock_x =
            round(camera_x);

        normal_camera.arena_lock_y =
            round(camera_y);

        normal_camera.arena_lock_active =
            true;

        normal_camera.arena_was_locked =
            true;
    }
}