/// oHorizontalChaseController — Step

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
var p =
    instance_find(
        oPlayer,
        0
    );

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
        // Horizontal chase begins when the player
        // passes the trigger's X position.
        if (p.x >= activation_trigger.x)
        {
            chase_active = true;

            chase_speed = 0;

            target_chase_speed =
                base_chase_speed;

            activation_trigger.activated =
                true;


            // ----------------------------------------
            // Activate chasing saws
            // ----------------------------------------
            var saw_obj =
                asset_get_index(
                    "oArea2ChasingSaws"
                );

            if (saw_obj != -1)
            {
                with (saw_obj)
                {
                    enabled = true;
                    visible = true;
                }
            }

            show_debug_message(
                "HORIZONTAL CHASE ACTIVATED"
            );
        }
    }

    exit;
}


// ----------------------------------------------------
// ACTIVE CHASE
// ----------------------------------------------------

// Smooth acceleration toward normal chase speed
chase_speed =
    lerp(
        chase_speed,
        target_chase_speed,
        speed_lerp
    );


// Move camera right
cam_x += chase_speed;


// Keep camera inside room
cam_x =
    clamp(
        cam_x,
        0,
        cam_x_max
    );


// Apply camera position
camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);