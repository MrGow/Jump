/// oVerticalChaseController — Create

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
start_cam_x = camera_get_view_x(cam);
start_cam_y = camera_get_view_y(cam);

cam_x = start_cam_x;
cam_y = start_cam_y;

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
cam_y_max = max(0, room_height - view_h);

// ----------------------------------------------------
// Find activation marker
// ----------------------------------------------------
activation_trigger = instance_find(oVerticalChaseActivationTrigger, 0);

// ----------------------------------------------------
// Reset chase function
// ----------------------------------------------------
reset_chase = function()
{
    // Stop chase
    chase_active = false;

    chase_speed = 0;
    target_chase_speed = base_chase_speed;

    // Return camera to starting position
    cam_x = start_cam_x;
    cam_y = start_cam_y;

    camera_set_view_pos(
        cam,
        round(cam_x),
        round(cam_y)
    );

    // Reset activation marker
    if (instance_exists(activation_trigger))
    {
        activation_trigger.activated = false;
    }

    // Return horizontal saw assembly to original position
    var saw_obj = asset_get_index("oArea2ChasingSawsHorizontal");

    if (saw_obj != -1)
    {
        with (saw_obj)
        {
            enabled = false;

            x = start_x;
            y = start_y;

            visible = true;
        }
    }
};