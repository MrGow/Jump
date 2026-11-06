/// oArea1ElevatorController — End Step

// ====================================================
// FREEZE
// During an active elevator sequence, keep the elevator
// camera applied even while the game is frozen.
// ====================================================

var _game_frozen = scr_game_frozen();

if (_game_frozen && !camera_override_active && !finish_camera_hold_active)
{
    exit;
}

// ====================================================
// PLATFORM SAFETY
// ====================================================

if (!instance_exists(platform))
{
    exit;
}

// ====================================================
// PLATFORM SURFACE
// ====================================================

var platform_surface_y = platform.y;

if (variable_instance_exists(platform, "surface_y"))
{
    platform_surface_y = platform.surface_y;
}

// ====================================================
// NORMAL CAMERA
// ====================================================

var normal_camera = instance_find(oCamera, 0);

// ====================================================
// ACTIVE ELEVATOR CAMERA
// States: 1 = startup, 2 = ascending, 3 = finishing.
// X centres on the elevator; Y retains its old offset.
// ====================================================

if (camera_override_active && elevator_state < 4)
{
    var platform_centre_x =
        (platform.bbox_left + platform.bbox_right) * 0.5;

    camera_x = platform_centre_x - view_w * 0.5;

    camera_y = platform_surface_y - camera_platform_offset_y;

    // Room safety
    camera_x = clamp(camera_x, 0, max(0, room_width - view_w));
    camera_y = clamp(camera_y, 0, max(0, room_height - view_h));

    // Apply elevator camera
    camera_set_view_pos(cam, round(camera_x), round(camera_y));

    // Keep normal camera synchronised underneath
    if (normal_camera != noone)
    {
        if (variable_instance_exists(normal_camera, "cam_logic_x"))
        {
            normal_camera.cam_logic_x = round(camera_x);
        }

        if (variable_instance_exists(normal_camera, "cam_logic_y"))
        {
            normal_camera.cam_logic_y = round(camera_y);
        }
    }

    exit;
}

// ====================================================
// ELEVATOR JUST FINISHED
// Final Y comes directly from the elevator, not oCamera.
// ====================================================

if (elevator_state == 4 && camera_override_active)
{
    finish_camera_y = platform_surface_y - camera_platform_offset_y;

    finish_camera_y = clamp(
        finish_camera_y,
        0,
        max(0, room_height - view_h)
    );

    // Begin horizontal pan at the elevator camera's last X.
    finish_camera_x = camera_x;

    finish_camera_x = clamp(
        finish_camera_x,
        0,
        max(0, room_width - view_w)
    );

    camera_override_active = false;
    finish_camera_hold_active = true;

    // Apply immediately this frame to avoid a handoff jolt.
    camera_set_view_pos(
        cam,
        round(finish_camera_x),
        round(finish_camera_y)
    );

    if (normal_camera != noone)
    {
        if (variable_instance_exists(normal_camera, "cam_logic_x"))
        {
            normal_camera.cam_logic_x = round(finish_camera_x);
        }

        if (variable_instance_exists(normal_camera, "cam_logic_y"))
        {
            normal_camera.cam_logic_y = round(finish_camera_y);
        }
    }

    exit;
}

// ====================================================
// FINAL ELEVATOR CAMERA MODE
// Y remains locked; X eases toward normal camera target.
// ====================================================

if (finish_camera_hold_active)
{
    var target_x = finish_camera_x;

    if (
        normal_camera != noone &&
        variable_instance_exists(normal_camera, "cam_logic_x")
    )
    {
        target_x = normal_camera.cam_logic_x;
    }

    target_x = clamp(target_x, 0, max(0, room_width - view_w));

    finish_camera_x = lerp(
        finish_camera_x,
        target_x,
        finish_camera_pan_lerp
    );

    if (abs(target_x - finish_camera_x) < 0.25)
    {
        finish_camera_x = target_x;
    }

    camera_set_view_pos(
        cam,
        round(finish_camera_x),
        round(finish_camera_y)
    );

    // Keep normal camera's vertical logic at final height.
    if (normal_camera != noone)
    {
        if (variable_instance_exists(normal_camera, "cam_logic_y"))
        {
            normal_camera.cam_logic_y = round(finish_camera_y);
        }
    }

    exit;
}
