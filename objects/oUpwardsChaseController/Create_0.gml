/// oUpwardsChaseController — Create


// ====================================================
// CAMERA SETUP
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
// STARTING CAMERA POSITION
//
// The controller's room-editor position defines the
// initial camera's top-left coordinate.
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

base_chase_speed = 1.0;
target_chase_speed = base_chase_speed;

speed_lerp = 0.03;


// ====================================================
// CAMERA ROOM BOUNDARY
// ====================================================

cam_y_min = 0;


// ====================================================
// FIND MAIN ACTIVATION MARKER
// ====================================================

activation_trigger =
    instance_find(
        oUpwardsChaseActivationTrigger,
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
    // Reset activation marker
    // ------------------------------------------------

    if (instance_exists(activation_trigger))
    {
        activation_trigger.activated = false;
    }


    // ------------------------------------------------
    // Reset chasing caterpillar
    // ------------------------------------------------

    var caterpillar_obj =
        asset_get_index(
            "oArea3ChasingCaterpillar"
        );


    if (caterpillar_obj != -1)
    {
        with (caterpillar_obj)
        {
            // ----------------------------------------
            // Chase state
            // ----------------------------------------

            enabled = false;
            visible = true;


            // ----------------------------------------
            // Return to room-editor position
            // ----------------------------------------

            x = start_x;
            y = start_y;


            // ----------------------------------------
            // Reset burst movement
            // ----------------------------------------

            burst_offset = 0;
            burst_target = 0;
            burst_speed  = 0;

            burst_active = false;
            burst_was_active = false;


            // ----------------------------------------
            // Reset visual vibration
            // ----------------------------------------

            visual_shake_x = 0;
            visual_shake_y = 0;


            // ----------------------------------------
            // Reset head/body animations
            // ----------------------------------------

            head_anim_position = 0;
            body_anim_position = 0;

            head_anim_speed_current =
                head_anim_speed_normal;

            body_anim_speed_current =
                body_anim_speed_normal;


            // ----------------------------------------
            // Recalculate room-editor-relative offset
            //
            // This ensures any manual placement of the
            // caterpillar remains correct after death.
            // ----------------------------------------

            screen_offsets_initialized = false;
        }
    }


    // ------------------------------------------------
    // Reset all upward burst triggers
    // ------------------------------------------------

    var burst_trigger_obj =
        asset_get_index(
            "oUpwardsChaseBurstTrigger"
        );


    if (burst_trigger_obj != -1)
    {
        with (burst_trigger_obj)
        {
            activated = false;
        }
    }
};