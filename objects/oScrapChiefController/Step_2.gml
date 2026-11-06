
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
// CAMERA TARGET: ELEVATOR CENTRE
// ====================================================

var elevator_target_x =
    platform.x -
    camera_platform_offset_x;

elevator_target_x = clamp(
    elevator_target_x,
    0,
    max(0, room_width - view_w)
);


// Vertical camera position stays fixed.
camera_y = clamp(
    camera_y,
    0,
    max(0, room_height - view_h)
);


// ====================================================
// BEGIN DOCKING HANDOFF
// ====================================================

if (
    elevator_state == 11 &&
    camera_transition_mode != 2
)
{
    camera_transition_mode = 2;

    camera_transition_frame = 0;

    camera_transition_frames =
        max(
            1,
            round(camera_exit_seconds * room_speed)
        );

    camera_transition_start_x = camera_x;
    camera_transition_start_y = camera_y;
}


// ====================================================
// CAMERA TRANSITION / LOCK
// ====================================================

if (camera_transition_mode == 1)
{
    // --------------------------------------------
    // Smooth transition onto elevator
    // --------------------------------------------

    camera_transition_frame++;

    var t = clamp(
        camera_transition_frame /
        camera_transition_frames,
        0,
        1
    );

    var eased =
        t * t * (3 - 2 * t);

    camera_x = lerp(
        camera_transition_start_x,
        elevator_target_x,
        eased
    );

    if (t >= 1)
    {
        camera_transition_mode = 0;
    }
}
else if (camera_transition_mode == 2)
{
    // --------------------------------------------
    // Smooth transition back towards JumpBot
    // --------------------------------------------

    var player_target_x =
        elevator_target_x;

    var p = instance_find(
        oPlayer,
        0
    );

    if (p != noone)
    {
        player_target_x =
            (p.bbox_left + p.bbox_right) * 0.5 -
            view_w * 0.5;
    }

    player_target_x = clamp(
        player_target_x,
        0,
        max(0, room_width - view_w)
    );


    // --------------------------------------------
    // Smoothstep easing
    // --------------------------------------------

    camera_transition_frame++;

    var t = clamp(
        camera_transition_frame /
        camera_transition_frames,
        0,
        1
    );

    var eased =
        t * t * (3 - 2 * t);

    camera_x = lerp(
        camera_transition_start_x,
        player_target_x,
        eased
    );
}
else
{
    // --------------------------------------------
    // Normal boss encounter camera
    // --------------------------------------------

    camera_x = elevator_target_x;
}


// ====================================================
// ROOM SAFETY
// ====================================================

camera_x = clamp(
    camera_x,
    0,
    max(0, room_width - view_w)
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
// COMPLETE DOCKING HANDOFF
// ====================================================

if (
    camera_transition_mode == 2 &&
    camera_transition_frame >= camera_transition_frames
)
{
    camera_transition_mode = 0;

    camera_override_active = false;

    if (normal_camera != noone)
    {
        normal_camera.arena_lock_active = false;
        normal_camera.arena_was_locked = false;
        normal_camera.arena_release_frames = 0;

        normal_camera.cam_logic_x =
            round(camera_x);

        normal_camera.cam_logic_y =
            round(camera_y);
    }
}
