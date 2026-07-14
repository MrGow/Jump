/// oVerticalChaseController — Step

var p = instance_find(oPlayer, 0);

if (p == noone) exit;


// ----------------------------------------------------
// WAITING FOR PLAYER TO CROSS ACTIVATION POINT
// ----------------------------------------------------
if (!chase_active)
{
    if (instance_exists(activation_trigger))
    {
        // Downward chase:
        // activate once the player moves below the marker
        if (p.y >= activation_trigger.y)
        {
            chase_active = true;

            chase_speed = 0;
            target_chase_speed = base_chase_speed;

            activation_trigger.activated = true;

            // Activate chasing saws
            var saw_obj = asset_get_index("oArea2ChasingSawsHorizontal");

            if (saw_obj != -1)
            {
                with (saw_obj)
                {
                    enabled = true;
                    visible = true;
                }
            }

            show_debug_message("VERTICAL CHASE ACTIVATED");
        }
    }

    exit;
}


// ----------------------------------------------------
// ACTIVE CHASE
// ----------------------------------------------------

// Smooth acceleration
chase_speed = lerp(
    chase_speed,
    target_chase_speed,
    speed_lerp
);

// Move camera downward
cam_y += chase_speed;

// Keep camera inside room
cam_y = clamp(
    cam_y,
    0,
    cam_y_max
);

// Apply camera position
camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);