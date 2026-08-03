/// oVerticalChaseController — Create


// ====================================================
// CAMERA SETUP
// ====================================================

cam =
    view_camera[0];

view_w = 640;
view_h = 360;

camera_set_view_size(
    cam,
    view_w,
    view_h
);


// ====================================================
// STARTING CAMERA POSITION
//
// The controller's room-editor position defines the
// starting camera top-left coordinate.
// ====================================================

start_cam_x = x;
start_cam_y = y;

cam_x = start_cam_x;
cam_y = start_cam_y;


camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);


// ====================================================
// CHASE STATE
// ====================================================

chase_active = false;


// ====================================================
// CHASE SPEED
// ====================================================

chase_speed = 0;

base_chase_speed =
    1.0;

target_chase_speed =
    base_chase_speed;

speed_lerp =
    0.03;


// ====================================================
// CAMERA ROOM BOUNDARY
// ====================================================

cam_y_max =
    max(
        0,
        room_height -
        view_h
    );


// ====================================================
// FIND ACTIVATION TRIGGER
// ====================================================

activation_trigger =
    instance_find(
        oVerticalChaseActivationTrigger,
        0
    );


// ====================================================
// RESET CHASE FUNCTION
// ====================================================

reset_chase = function()
{
    // ------------------------------------------------
    // Stop chase
    // ------------------------------------------------

    chase_active = false;

    chase_speed = 0;

    target_chase_speed =
        base_chase_speed;


    // ------------------------------------------------
    // Return camera to starting position
    // ------------------------------------------------

    cam_x =
        start_cam_x;

    cam_y =
        start_cam_y;


    camera_set_view_pos(
        cam,
        round(cam_x),
        round(cam_y)
    );


    // ------------------------------------------------
    // Reset activation trigger
    // ------------------------------------------------

    if (
        instance_exists(
            activation_trigger
        )
    )
    {
        activation_trigger.activated =
            false;
    }


    // ------------------------------------------------
    // Reset horizontal saw assembly
    // ------------------------------------------------

    var saw_obj =
        asset_get_index(
            "oArea2ChasingSawsHorizontal"
        );


    if (saw_obj != -1)
    {
        with (saw_obj)
        {
            enabled = false;

            x = start_x;
            y = start_y;

            visible = true;


            burst_offset = 0;
            burst_target = 0;
            burst_speed  = 0;
            burst_active = false;

            burst_was_active = false;


            visual_shake_x     = 0;
            visual_shake_y     = 0;
            visual_shake_angle = 0;


            // Recalculate the room-editor-relative
            // offsets after reset.
            screen_offsets_initialized =
                false;
        }
    }


    // ------------------------------------------------
    // Reset vertical burst triggers
    // ------------------------------------------------

    var burst_trigger_obj =
        asset_get_index(
            "oVerticalChaseBurstTrigger"
        );


    if (burst_trigger_obj != -1)
    {
        with (burst_trigger_obj)
        {
            activated = false;
        }
    }
};