/// oHorizontalChaseController — Create

view_index = 0;
cam = view_camera[view_index];

view_w = 640;
view_h = 360;

camera_set_view_size(cam, view_w, view_h);

// ----------------------------------------------------
// Chase starting camera position
// ----------------------------------------------------
start_cam_x = camera_get_view_x(cam);
start_cam_y = camera_get_view_y(cam);

cam_x = start_cam_x;
cam_y = start_cam_y;

// Force initial camera position
camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);

// ----------------------------------------------------
// Chase state
// ----------------------------------------------------
chase_active = false;

base_chase_speed = 1.0;

chase_speed = 0;
target_chase_speed = base_chase_speed;

speed_lerp = 0.03;

// Room bounds
cam_x_max = max(0, room_width - view_w);

// ----------------------------------------------------
// Start chase
// ----------------------------------------------------
start_chase = function()
{
    show_debug_message("START CHASE FUNCTION CALLED");

    if (chase_active) return;

    chase_active = true;

    chase_speed = 0;
    target_chase_speed = base_chase_speed;

    with (oChasingSaws)
    {
        enabled = true;
        visible = true;
    }
};

// ----------------------------------------------------
// Reset chase
// ----------------------------------------------------
reset_chase = function()
{
    chase_active = false;

    chase_speed = 0;
    target_chase_speed = base_chase_speed;

    cam_x = start_cam_x;
    cam_y = start_cam_y;

    camera_set_view_pos(
        cam,
        round(cam_x),
        round(cam_y)
    );

    with (oChasingSaws)
    {
        enabled = false;
        visible = false;
    }
};