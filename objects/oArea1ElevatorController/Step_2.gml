/// oArea1ElevatorController — End Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
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
// NORMAL CAMERA
// ====================================================

var normal_camera =
    instance_find(
        oCamera,
        0
    );


// ====================================================
// ACTIVE ELEVATOR CAMERA
//
// States:
// 1 = startup
// 2 = ascending
// 3 = finishing
//
// Camera remains attached vertically to the elevator.
// ====================================================

if (
    camera_override_active &&
    elevator_state < 4
)
{
    camera_x =
        start_cam_x;


    camera_y =
        platform_surface_y -
        camera_platform_offset_y;


    // ------------------------------------------------
    // Room safety
    // ------------------------------------------------

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


    // ------------------------------------------------
    // Apply elevator camera
    // ------------------------------------------------

    camera_set_view_pos(
        cam,
        round(camera_x),
        round(camera_y)
    );


    // ------------------------------------------------
    // Keep normal camera synchronised underneath
    // ------------------------------------------------

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


    exit;
}


// ====================================================
// ELEVATOR JUST FINISHED
//
// IMPORTANT:
//
// Do NOT read camera_get_view_y() here.
//
// oCamera may already have followed the player downward
// earlier in this frame.
//
// Instead calculate the final elevator camera position
// directly from the elevator itself.
// ====================================================

if (
    elevator_state == 4 &&
    camera_override_active
)
{
    // ------------------------------------------------
    // Final Y is derived DIRECTLY from elevator.
    // This prevents the downward handoff jolt.
    // ------------------------------------------------

    finish_camera_y =
        platform_surface_y -
        camera_platform_offset_y;


    finish_camera_y =
        clamp(
            finish_camera_y,
            0,
            max(
                0,
                room_height -
                view_h
            )
        );


    // ------------------------------------------------
    // Horizontal begins where the elevator camera was.
    // ------------------------------------------------

    finish_camera_x =
        camera_x;


    finish_camera_x =
        clamp(
            finish_camera_x,
            0,
            max(
                0,
                room_width -
                view_w
            )
        );


    // ------------------------------------------------
    // Elevator vertical tracking ends.
    // Final-height horizontal-only mode begins.
    // ------------------------------------------------

    camera_override_active =
        false;

    finish_camera_hold_active =
        true;


    // ------------------------------------------------
    // Apply immediately THIS FRAME.
    //
    // This overwrites any downward movement oCamera
    // may already have performed.
    // ------------------------------------------------

    camera_set_view_pos(
        cam,
        round(finish_camera_x),
        round(finish_camera_y)
    );


    // ------------------------------------------------
    // Synchronise normal camera.
    // ------------------------------------------------

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
                round(finish_camera_x);
        }


        if (
            variable_instance_exists(
                normal_camera,
                "cam_logic_y"
            )
        )
        {
            normal_camera.cam_logic_y =
                round(finish_camera_y);
        }
    }


    exit;
}


// ====================================================
// FINAL ELEVATOR CAMERA MODE
//
// Y remains permanently locked at the elevator's final
// height.
//
// X slowly eases toward the normal camera's horizontal
// target instead of snapping instantly.
// ====================================================

if (finish_camera_hold_active)
{
    // ------------------------------------------------
    // TARGET HORIZONTAL POSITION
    //
    // Let normal oCamera calculate where it WANTS to be
    // horizontally, but don't jump there immediately.
    // ------------------------------------------------

    var target_x =
        finish_camera_x;


    if (
        normal_camera != noone &&
        variable_instance_exists(
            normal_camera,
            "cam_logic_x"
        )
    )
    {
        target_x =
            normal_camera.cam_logic_x;
    }


    // ------------------------------------------------
    // Room safety
    // ------------------------------------------------

    target_x =
        clamp(
            target_x,
            0,
            max(
                0,
                room_width -
                view_w
            )
        );


    // ------------------------------------------------
    // SMOOTH HORIZONTAL PAN
    //
    // This begins exactly from the elevator's final X
    // and gradually catches up with the player.
    // ------------------------------------------------

    finish_camera_x =
        lerp(
            finish_camera_x,
            target_x,
            finish_camera_pan_lerp
        );


    // ------------------------------------------------
    // Tiny-distance snap.
    //
    // Prevents endlessly approaching the final pixel.
    // ------------------------------------------------

    if (
        abs(
            target_x -
            finish_camera_x
        )
        < 0.25
    )
    {
        finish_camera_x =
            target_x;
    }


    // =================================================
    // APPLY
    //
    // X = smooth horizontal follow
    // Y = permanently locked at elevator finish height
    // =================================================

    camera_set_view_pos(
        cam,
        round(
            finish_camera_x
        ),
        round(
            finish_camera_y
        )
    );


    // =================================================
    // KEEP NORMAL CAMERA Y LOCKED
    //
    // Normal camera remains free to determine where
    // horizontal following should eventually go, but it
    // cannot pull the screen downward.
    // =================================================

    if (normal_camera != noone)
    {
        if (
            variable_instance_exists(
                normal_camera,
                "cam_logic_y"
            )
        )
        {
            normal_camera.cam_logic_y =
                round(
                    finish_camera_y
                );
        }
    }


    exit;
}