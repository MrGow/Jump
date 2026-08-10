/// oArea1ElevatorController — Create


// ====================================================
// CAMERA
// ====================================================

cam = view_camera[0];

view_w = 640;
view_h = 360;

camera_set_view_size(
    cam,
    view_w,
    view_h
);


// ====================================================
// REFERENCES
// ====================================================

platform =
    instance_find(
        oArea1ElevatorPlatform,
        0
    );

activation_trigger =
    instance_find(
        oArea1ElevatorActivationTrigger,
        0
    );


// ====================================================
// STATE
//
// 0 = waiting
// 1 = startup pause
// 2 = ascending
// 3 = finishing
// 4 = complete
// ====================================================

elevator_state = 0;

sequence_active = false;
sequence_complete = false;


// ====================================================
// STARTUP
// ====================================================

startup_frames =
    round(
        room_speed * 1.0
    );

startup_timer = 0;


// ====================================================
// MOVEMENT
// ====================================================

base_speed = 1.15;

current_speed = 0;
target_speed  = 0;

speed_lerp = 0.025;


// ====================================================
// TOTAL TRAVEL
// ====================================================

if (!variable_instance_exists(id, "travel_distance"))
{
    travel_distance = 5000;
}


// ====================================================
// POSITION
// ====================================================

start_platform_x = 0;
start_platform_y = 0;

end_platform_y = 0;


// ====================================================
// PLATFORM MOVEMENT COMMAND
// ====================================================

platform_move_y = 0;


// ====================================================
// CAMERA OVERRIDE
// ====================================================

camera_override_active = false;

start_cam_x = 0;
start_cam_y = 0;

camera_platform_offset_y = 0;

camera_x = 0;
camera_y = 0;


// ====================================================
// FINISHING
// ====================================================

finish_slow_distance = 160;

finish_speed = 0.35;


// ====================================================
// STARTUP JOLTS
// ====================================================

// Initial machinery power-up.
startup_jolt_strength = 3;
startup_jolt_frames   = 10;


// Second kick when the elevator actually begins moving.
engage_jolt_strength = 2;
engage_jolt_frames   = 6;


// ====================================================
// DEBUG
// ====================================================

debug_elevator = false;


// ====================================================
// START ELEVATOR
// ====================================================

start_elevator = function()
{
    if (sequence_active)
    {
        return;
    }


    if (!instance_exists(platform))
    {
        platform =
            instance_find(
                oArea1ElevatorPlatform,
                0
            );
    }


    if (!instance_exists(platform))
    {
        show_debug_message(
            "AREA 1 ELEVATOR: no platform found."
        );

        return;
    }


    // ------------------------------------------------
    // Store platform starting position
    // ------------------------------------------------

    start_platform_x =
        platform.x;

    start_platform_y =
        platform.y;


    end_platform_y =
        start_platform_y -
        travel_distance;


    // ------------------------------------------------
    // Capture current camera
    // ------------------------------------------------

    start_cam_x =
        camera_get_view_x(
            cam
        );

    start_cam_y =
        camera_get_view_y(
            cam
        );


    camera_x =
        start_cam_x;

    camera_y =
        start_cam_y;


    // ------------------------------------------------
    // Preserve platform's current screen position
    // ------------------------------------------------

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


    camera_platform_offset_y =
        platform_surface_y -
        start_cam_y;


    // ------------------------------------------------
    // Begin sequence
    // ------------------------------------------------

    sequence_active = true;
    sequence_complete = false;

    elevator_state = 1;

    startup_timer =
        startup_frames;

    current_speed = 0;
    target_speed  = 0;

    platform_move_y = 0;

    camera_override_active = true;


    // ------------------------------------------------
    // Initial heavy machinery startup jolt
    // ------------------------------------------------

    if (instance_exists(platform))
    {
        platform.jolt_strength =
            startup_jolt_strength;

        platform.jolt_timer =
            startup_jolt_frames;
    }


    // ------------------------------------------------
    // Mark trigger as used
    // ------------------------------------------------

    if (
        instance_exists(
            activation_trigger
        )
    )
    {
        activation_trigger.activated =
            true;
    }


    if (debug_elevator)
    {
        show_debug_message(
            "AREA 1 ELEVATOR STARTED"
        );
    }
};


// ====================================================
// RESET ELEVATOR
// ====================================================

reset_elevator = function()
{
    sequence_active = false;
    sequence_complete = false;

    elevator_state = 0;

    startup_timer = 0;

    current_speed = 0;
    target_speed  = 0;

    platform_move_y = 0;

    camera_override_active = false;


    // ------------------------------------------------
    // Reset platform
    // ------------------------------------------------

    if (!instance_exists(platform))
    {
        platform =
            instance_find(
                oArea1ElevatorPlatform,
                0
            );
    }


    if (instance_exists(platform))
    {
        platform.x =
            platform.start_x;

        platform.y =
            platform.start_y;

        platform.prev_x =
            platform.x;

        platform.prev_y =
            platform.y;

        platform.dx = 0;
        platform.dy = 0;

        platform.surface_y =
            platform.bbox_top;


        // Reset visual movement.
        platform.visual_shake_x = 0;
        platform.visual_shake_y = 0;

        platform.engine_shake_timer = 0;

        platform.jolt_timer = 0;
        platform.jolt_strength = 0;
    }


    // ------------------------------------------------
    // Reset activation trigger
    // ------------------------------------------------

    if (!instance_exists(activation_trigger))
    {
        activation_trigger =
            instance_find(
                oArea1ElevatorActivationTrigger,
                0
            );
    }


    if (
        instance_exists(
            activation_trigger
        )
    )
    {
        activation_trigger.activated =
            false;
    }


    if (debug_elevator)
    {
        show_debug_message(
            "AREA 1 ELEVATOR RESET"
        );
    }
};