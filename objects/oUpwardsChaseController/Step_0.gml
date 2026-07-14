/// oUpwardsChaseController — Step

// Freeze during pause, death animation delay and death menu
if (scr_game_frozen())
{
    exit;
}

var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}


// ----------------------------------------------------
// WAITING FOR PLAYER TO CLIMB PAST ACTIVATION POINT
// ----------------------------------------------------
if (!chase_active)
{
    if (instance_exists(activation_trigger))
    {
        // Upward movement means decreasing Y.
        if (p.y <= activation_trigger.y)
        {
            chase_active = true;

            chase_speed = 0;
            target_chase_speed = base_chase_speed;

            activation_trigger.activated = true;

            var caterpillar_obj =
                asset_get_index("oArea3ChasingCaterpillar");

            if (caterpillar_obj != -1)
            {
                with (caterpillar_obj)
                {
                    enabled = true;
                    visible = true;
                }
            }

            show_debug_message("UPWARDS CHASE ACTIVATED");
        }
    }

    exit;
}


// ----------------------------------------------------
// ACTIVE CHASE
// ----------------------------------------------------

// Smooth acceleration toward normal speed
chase_speed = lerp(
    chase_speed,
    target_chase_speed,
    speed_lerp
);

// Move camera upward
cam_y -= chase_speed;

// Keep camera inside room
cam_y = max(cam_y_min, cam_y);

// Apply camera
camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);