/// oHorizontalChaseController — Create

// ----------------------------------------------------
// Camera setup
// ----------------------------------------------------
cam = view_camera[0];

view_w = 640;
view_h = 360;

camera_set_view_size(cam, view_w, view_h);

// ----------------------------------------------------
// Store starting camera position
// ----------------------------------------------------
// The chase controller's position in the room editor
// defines the initial camera's top-left coordinate.
start_cam_x = x;
start_cam_y = y;

cam_x = start_cam_x;
cam_y = start_cam_y;

camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);

// ----------------------------------------------------
// Chase state
// ----------------------------------------------------
chase_active = false;

// ----------------------------------------------------
// Chase speed
// ----------------------------------------------------
chase_speed = 0;

base_chase_speed = 1.0;
target_chase_speed = base_chase_speed;

speed_lerp = 0.03;

// ----------------------------------------------------
// Camera room boundary
// ----------------------------------------------------
cam_x_max = max(0, room_width - view_w);

// ----------------------------------------------------
// Find activation marker
// ----------------------------------------------------
activation_trigger = instance_find(oHorizontalChaseActivationTrigger, 0);

// ----------------------------------------------------
// Reset chase function
// ----------------------------------------------------
reset_chase = function()
{
    // ------------------------------------------------
    // Stop chase
    // ------------------------------------------------
    chase_active = false;

    chase_speed = 0;
    target_chase_speed = base_chase_speed;

    // ------------------------------------------------
    // Return camera to starting position
    // ------------------------------------------------
    cam_x = start_cam_x;
    cam_y = start_cam_y;

    camera_set_view_pos(
        cam,
        round(cam_x),
        round(cam_y)
    );

    // ------------------------------------------------
    // Reset main chase activation trigger
    // ------------------------------------------------
    if (instance_exists(activation_trigger))
    {
        activation_trigger.activated = false;
    }

    // ------------------------------------------------
    // Reset chasing saw
    // ------------------------------------------------
    var saw_obj = asset_get_index("oArea2ChasingSaws");

    if (saw_obj != -1)
    {
        with (saw_obj)
        {
            // Stop chasing
            enabled = false;

            // Return to room-editor starting position
            x = start_x;
            y = start_y;

            // Keep visible before the chase begins
            visible = true;

            // Reset all accumulated burst pressure
            burst_offset = 0;
            burst_target = 0;
            burst_speed  = 0;
            burst_active = false;
        }
    }

    // ------------------------------------------------
    // Reset all horizontal burst triggers
    // ------------------------------------------------
    var burst_trigger_obj =
        asset_get_index("oHorizontalChaseBurstTrigger");

    if (burst_trigger_obj != -1)
    {
        with (burst_trigger_obj)
        {
            activated = false;
        }
    }
};