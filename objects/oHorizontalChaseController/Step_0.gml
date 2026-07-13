/// oHorizontalChaseController — Step

// ----------------------------------------------------
// WAITING FOR PLAYER TO CROSS ACTIVATION POINT
// ----------------------------------------------------
if (!chase_active)
{
    var p = instance_find(oPlayer, 0);

    if (p != noone && activation_trigger != noone)
    {
        // Player has crossed the trigger's X position
        if (p.x >= activation_trigger.x)
        {
            chase_active = true;

            chase_speed = 0;
            target_chase_speed = base_chase_speed;

            activation_trigger.activated = true;

            // Activate chasing saws
            with (oArea2ChasingSaws)
            {
                enabled = true;
                visible = true;
            }

            show_debug_message("CHASE ACTIVATED");
        }
    }

    exit;
}


// ----------------------------------------------------
// ACTIVE CHASE
// ----------------------------------------------------

// Accelerate smoothly
chase_speed = lerp(
    chase_speed,
    target_chase_speed,
    speed_lerp
);

// Move camera right
cam_x += chase_speed;

// Keep camera inside room
cam_x = clamp(
    cam_x,
    0,
    cam_x_max
);

// Apply camera
camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);