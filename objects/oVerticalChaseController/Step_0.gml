/// oVerticalChaseController — Step

// ----------------------------------------------------
// Freeze chase camera during:
// - pause
// - death animation delay
// - death menu
// - menu state
// ----------------------------------------------------
if (scr_game_frozen())
{
    exit;
}


// ----------------------------------------------------
// Find player
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}


// ----------------------------------------------------
// WAITING FOR PLAYER TO CROSS ACTIVATION POINT
// ----------------------------------------------------
if (!chase_active)
{
    if (instance_exists(activation_trigger))
    {
        // Downward chase begins when the player
        // passes below the trigger's Y position.
        if (p.y >= activation_trigger.y)
        {
            chase_active = true;

            chase_speed = 0;
            target_chase_speed = base_chase_speed;

            activation_trigger.activated = true;

            // Activate horizontal saw assembly
            var saw_obj =
                asset_get_index("oArea2ChasingSawsHorizontal");

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

// Smooth acceleration toward normal chase speed
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