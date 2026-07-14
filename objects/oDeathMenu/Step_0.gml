/// oDeathMenu — Step

// ----------------------------------------------------
// Fade in
// ----------------------------------------------------
if (alpha < 1)
{
    alpha = clamp(alpha + fade_speed, 0, 1);
}


// ----------------------------------------------------
// Use jump as confirm / "Climb again"
// ----------------------------------------------------
var confirm = false;

if (variable_global_exists("inp_jump_press"))
{
    confirm = global.inp_jump_press;
}
else
{
    confirm =
        keyboard_check_pressed(vk_space) ||
        keyboard_check_pressed(vk_up);
}


// ----------------------------------------------------
// Confirm respawn
// ----------------------------------------------------
if (confirm)
{
    // ------------------------------------------------
    // Lose carried, unbanked chips on respawn
    // ------------------------------------------------
    if (variable_global_exists("chips_carried"))
    {
        global.chips_carried = 0;
    }

    if (variable_global_exists("chips_carried_ids"))
    {
        ds_map_clear(global.chips_carried_ids);
    }


    // ------------------------------------------------
    // Determine respawn destination
    // ------------------------------------------------
    var target_room = room;
    var target_x = 0;
    var target_y = 0;


    // Prefer active checkpoint
    if (variable_global_exists("checkpoint_set") &&
        global.checkpoint_set)
    {
        target_room = global.checkpoint_room;
        target_x    = global.checkpoint_x;
        target_y    = global.checkpoint_y;
    }
    // Fallback to current room spawn
    else if (instance_exists(oRunController))
    {
        target_x = oRunController.spawn_x;
        target_y = oRunController.spawn_y;
    }


    // Return game to playing state
    global.game_phase = "playing";


    // ====================================================
    // CROSS-ROOM RESPAWN
    // ====================================================
    if (target_room != room)
    {
        global.pending_respawn      = true;
        global.pending_respawn_room = target_room;
        global.pending_respawn_x    = target_x;
        global.pending_respawn_y    = target_y;

        global.inp_jump_press = false;

        instance_destroy();

        room_goto(target_room);

        exit;
    }


    // ====================================================
    // SAME-ROOM RESPAWN
    // ====================================================
    if (instance_exists(oRunController))
    {
        with (oRunController)
        {
            spawn_x = target_x;
            spawn_y = target_y;

            if (instance_exists(oPlayer))
            {
                with (oPlayer)
                {
                    // ------------------------------------
                    // Position
                    // ------------------------------------
                    x = other.spawn_x;
                    y = other.spawn_y;

                    // ------------------------------------
                    // Movement
                    // ------------------------------------
                    if (!variable_instance_exists(id, "hsp")) hsp = 0;
                    if (!variable_instance_exists(id, "vsp")) vsp = 0;

                    hsp = 0;
                    vsp = 0;

                    // ------------------------------------
                    // State
                    // ------------------------------------
                    state = "idle";

                    if (variable_instance_exists(id, "death_fall"))
                    {
                        death_fall = false;
                    }

                    if (variable_instance_exists(id, "death_cam_lock_x"))
                    {
                        death_cam_lock_x = x;
                    }

                    if (variable_instance_exists(id, "death_cam_lock_y"))
                    {
                        death_cam_lock_y = y;
                    }

                    // ------------------------------------
                    // HP
                    // ------------------------------------
                    if (!variable_instance_exists(id, "max_hp"))
                    {
                        max_hp = 1;
                    }

                    if (!variable_instance_exists(id, "hp"))
                    {
                        hp = max_hp;
                    }

                    hp = max_hp;

                    // ------------------------------------
                    // Sprite
                    // ------------------------------------
                    sprite_index = spriteBotIdle;
                    image_index  = 0;
                    image_speed  = 0.2;
                    image_xscale = facing;

                    // ------------------------------------
                    // Reset jump / landing state
                    // ------------------------------------
                    if (variable_instance_exists(id, "jump_charging"))
                    {
                        jump_charging = false;
                    }

                    if (variable_instance_exists(id, "jump_charge"))
                    {
                        jump_charge = 0;
                    }

                    if (variable_instance_exists(id, "jump_charge_level"))
                    {
                        jump_charge_level = 0;
                    }

                    if (variable_instance_exists(id, "bounce_pending"))
                    {
                        bounce_pending = false;
                    }

                    if (variable_instance_exists(id, "bounce_timer"))
                    {
                        bounce_timer = 0;
                    }

                    if (variable_instance_exists(id, "standing_platform"))
                    {
                        standing_platform = noone;
                    }

                    if (variable_instance_exists(id, "coyote_timer"))
                    {
                        coyote_timer = 0;
                    }

                    // Prevent held jump from instantly retriggering
                    if (variable_instance_exists(id, "prev_jump_h"))
                    {
                        prev_jump_h = true;
                    }

                    if (variable_instance_exists(id, "respawn_input_lock"))
                    {
                        respawn_input_lock = 8;
                    }
                }
            }
        }
    }


    // ====================================================
    // RESET HORIZONTAL CHASE IF PRESENT
    // ====================================================
    var h_chase_obj =
        asset_get_index("oHorizontalChaseController");

    if (h_chase_obj != -1)
    {
        var h_chase_ctrl =
            instance_find(h_chase_obj, 0);

        if (h_chase_ctrl != noone)
        {
            if (variable_instance_exists(
                h_chase_ctrl,
                "reset_chase"
            ))
            {
                h_chase_ctrl.reset_chase();
            }
        }
    }


    // ====================================================
    // RESET VERTICAL CHASE IF PRESENT
    // ====================================================
    var v_chase_obj =
        asset_get_index("oVerticalChaseController");

    if (v_chase_obj != -1)
    {
        var v_chase_ctrl =
            instance_find(v_chase_obj, 0);

        if (v_chase_ctrl != noone)
        {
            if (variable_instance_exists(
                v_chase_ctrl,
                "reset_chase"
            ))
            {
                v_chase_ctrl.reset_chase();
            }
        }
    }


    // ----------------------------------------------------
    // Finish respawn
    // ----------------------------------------------------
    global.cam_death_lock_active = false;
    global.inp_jump_press = false;

    instance_destroy();
}