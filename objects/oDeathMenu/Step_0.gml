/// oDeathMenu — Step

// ====================================================
// HOT-RELOAD AUDIO SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_death_screen"))
{
    snd_death_screen =
        asset_get_index("RespawnDeathScreen1");
}

if (!variable_instance_exists(id, "snd_respawn_confirm"))
{
    snd_respawn_confirm =
        asset_get_index("RespawnConfirmation1");
}

if (!variable_instance_exists(id, "snd_player_respawn"))
{
    snd_player_respawn =
        asset_get_index("RespawnSound1");
}

if (!variable_instance_exists(id, "death_screen_sfx_gain"))
{
    death_screen_sfx_gain = 1.0;
}

if (!variable_instance_exists(id, "respawn_confirm_sfx_gain"))
{
    respawn_confirm_sfx_gain = 1.0;
}

if (!variable_instance_exists(id, "player_respawn_sfx_gain"))
{
    player_respawn_sfx_gain = 1.0;
}


// ----------------------------------------------------
// Fade in
// ----------------------------------------------------
if (alpha < 1)
{
    alpha =
        clamp(
            alpha + fade_speed,
            0,
            1
        );
}


// ----------------------------------------------------
// Use jump as confirm / "Climb again"
// ----------------------------------------------------
var confirm = false;

if (variable_global_exists("inp_jump_press"))
{
    confirm =
        global.inp_jump_press;
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
    // =================================================
    // CONFIRMATION SOUND
    // =================================================
    if (
        snd_respawn_confirm != -1 &&
        audio_group_is_loaded(audiogroupui)
    )
    {
        var confirm_voice =
            audio_play_sound(
                snd_respawn_confirm,
                111,
                false
            );

        if (confirm_voice != noone)
        {
            audio_sound_gain(
                confirm_voice,
                respawn_confirm_sfx_gain,
                0
            );
        }
    }


    // =================================================
    // CONSUME CONFIRMATION INPUT
    //
    // Jump remains blocked after respawn until the
    // player physically releases Space/Up/gamepad A.
    // =================================================
    global.inp_jump_block_until_release = true;

    global.inp_jump_press = false;
    global.inp_jump_held  = false;


    // ------------------------------------------------
    // Lose carried, unbanked chips on respawn
    // ------------------------------------------------
    if (variable_global_exists("chips_carried"))
    {
        global.chips_carried = 0;
    }

    if (variable_global_exists("chips_carried_ids"))
    {
        ds_map_clear(
            global.chips_carried_ids
        );
    }


    // ------------------------------------------------
    // Determine respawn destination
    // ------------------------------------------------
    var target_room = room;
    var target_x    = 0;
    var target_y    = 0;

    // Prefer active checkpoint.
    if (
        variable_global_exists("checkpoint_set") &&
        global.checkpoint_set
    )
    {
        target_room =
            global.checkpoint_room;

        target_x =
            global.checkpoint_x;

        target_y =
            global.checkpoint_y;
    }
    // Fallback to current room spawn.
    else if (instance_exists(oRunController))
    {
        var fallback_controller =
            instance_find(
                oRunController,
                0
            );

        if (fallback_controller != noone)
        {
            target_x =
                fallback_controller.spawn_x;

            target_y =
                fallback_controller.spawn_y;
        }
    }


    // ====================================================
    // CLEAN UP EXPLOSION-DEATH VISUALS
    // ====================================================

    var death_explosion_object =
        asset_get_index("oDeathExplosion");

    if (death_explosion_object != -1)
    {
        with (death_explosion_object)
        {
            instance_destroy();
        }
    }

    var death_part_object =
        asset_get_index("oBotDeathPart");

    if (death_part_object != -1)
    {
        with (death_part_object)
        {
            instance_destroy();
        }
    }


    // ----------------------------------------------------
    // Return game to playing state
    // ----------------------------------------------------
    global.game_phase = "playing";

    // Restore normal gameplay audio gains before the
    // diegetic respawn sound plays.
    scr_settings_apply_audio_gains();


    // ====================================================
    // CROSS-ROOM RESPAWN
    // ====================================================
    if (target_room != room)
    {
        global.pending_respawn      = true;
        global.pending_respawn_room = target_room;
        global.pending_respawn_x    = target_x;
        global.pending_respawn_y    = target_y;

        // The destination room's Run Controller plays
        // RespawnSound1 after positioning the player.
        global.pending_respawn_play_sound = true;

        global.inp_jump_press = false;
        global.inp_jump_held  = false;

        instance_destroy();

        room_goto(target_room);

        exit;
    }


    // ====================================================
    // SAME-ROOM RESPAWN
    // ====================================================
    if (instance_exists(oRunController))
    {
        var run_controller =
            instance_find(
                oRunController,
                0
            );

        if (run_controller != noone)
        {
            run_controller.spawn_x =
                target_x;

            run_controller.spawn_y =
                target_y;

            if (instance_exists(oPlayer))
            {
                var player =
                    instance_find(
                        oPlayer,
                        0
                    );

                if (player != noone)
                {
                    // --------------------------------
                    // Position
                    // --------------------------------
                    player.x = target_x;
                    player.y = target_y;

                    // --------------------------------
                    // Movement
                    // --------------------------------
                    if (!variable_instance_exists(player, "hsp"))
                    {
                        player.hsp = 0;
                    }

                    if (!variable_instance_exists(player, "vsp"))
                    {
                        player.vsp = 0;
                    }

                    player.hsp = 0;
                    player.vsp = 0;

                    // --------------------------------
                    // State
                    // --------------------------------
                    player.state = "idle";

                    if (
                        variable_instance_exists(
                            player,
                            "death_fall"
                        )
                    )
                    {
                        player.death_fall = false;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "death_cam_lock_x"
                        )
                    )
                    {
                        player.death_cam_lock_x =
                            player.x;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "death_cam_lock_y"
                        )
                    )
                    {
                        player.death_cam_lock_y =
                            player.y;
                    }

                    // --------------------------------
                    // HP
                    // --------------------------------
                    if (
                        !variable_instance_exists(
                            player,
                            "max_hp"
                        )
                    )
                    {
                        player.max_hp = 1;
                    }

                    if (
                        !variable_instance_exists(
                            player,
                            "hp"
                        )
                    )
                    {
                        player.hp =
                            player.max_hp;
                    }

                    player.hp =
                        player.max_hp;

                    // --------------------------------
                    // Sprite
                    // --------------------------------
                    player.sprite_index =
                        spriteBotIdle;

                    player.image_index  = 0;
                    player.image_speed  = 0.2;
                    player.image_alpha  = 1;
                    player.image_blend  = c_white;
                    player.image_angle  = 0;
                    player.image_yscale = 1;

                    if (
                        variable_instance_exists(
                            player,
                            "facing"
                        )
                    )
                    {
                        player.image_xscale =
                            player.facing;
                    }

                    // --------------------------------
                    // Reset jump state
                    // --------------------------------
                    if (
                        variable_instance_exists(
                            player,
                            "jump_charging"
                        )
                    )
                    {
                        player.jump_charging = false;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "jump_charge"
                        )
                    )
                    {
                        player.jump_charge = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "jump_charge_level"
                        )
                    )
                    {
                        player.jump_charge_level = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "jump_charge_sfx_last"
                        )
                    )
                    {
                        player.jump_charge_sfx_last = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "charge_grace"
                        )
                    )
                    {
                        player.charge_grace = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "charge_start_lock"
                        )
                    )
                    {
                        player.charge_start_lock = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "support_grace"
                        )
                    )
                    {
                        player.support_grace = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "support_stable_frames"
                        )
                    )
                    {
                        player.support_stable_frames = 0;
                    }

                    // --------------------------------
                    // Reset landing/bounce state
                    // --------------------------------
                    if (
                        variable_instance_exists(
                            player,
                            "bounce_pending"
                        )
                    )
                    {
                        player.bounce_pending = false;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "bounce_timer"
                        )
                    )
                    {
                        player.bounce_timer = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "bounce_v"
                        )
                    )
                    {
                        player.bounce_v = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "standing_platform"
                        )
                    )
                    {
                        player.standing_platform = noone;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "coyote_timer"
                        )
                    )
                    {
                        player.coyote_timer = 0;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "jump_pose_timer"
                        )
                    )
                    {
                        player.jump_pose_timer = 0;
                    }

                    // --------------------------------
                    // Prevent confirmation input from
                    // becoming a new jump
                    // --------------------------------
                    if (
                        variable_instance_exists(
                            player,
                            "prev_jump_h"
                        )
                    )
                    {
                        player.prev_jump_h = true;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "respawn_input_lock"
                        )
                    )
                    {
                        player.respawn_input_lock = 8;
                    }

                    if (
                        variable_instance_exists(
                            player,
                            "prev_on_ground"
                        )
                    )
                    {
                        player.prev_on_ground = false;
                    }
                }
            }
        }
    }


    // ====================================================
    // DIEGETIC SAME-ROOM RESPAWN SOUND
    // ====================================================

    if (
        snd_player_respawn != -1 &&
        audio_group_is_loaded(audiogroupsfx)
    )
    {
        scr_play_sfx(
            snd_player_respawn,
            player_respawn_sfx_gain,
            random_range(0.98, 1.02)
        );
    }


    // ====================================================
    // RESET MILLIPEEDES AND THEIR SPAWNERS
    // ====================================================
    if (instance_exists(oRunController))
    {
        var rc =
            instance_find(
                oRunController,
                0
            );

        if (
            rc != noone &&
            variable_instance_exists(
                rc,
                "reset_millipede_hazards"
            ) &&
            is_callable(
                rc.reset_millipede_hazards
            )
        )
        {
            rc.reset_millipede_hazards();
        }
    }


    // ====================================================
    // RESET HORIZONTAL CHASE
    // ====================================================
    var h_chase_obj =
        asset_get_index(
            "oHorizontalChaseController"
        );

    if (h_chase_obj != -1)
    {
        var h_chase_ctrl =
            instance_find(
                h_chase_obj,
                0
            );

        if (
            h_chase_ctrl != noone &&
            variable_instance_exists(
                h_chase_ctrl,
                "reset_chase"
            ) &&
            is_callable(
                h_chase_ctrl.reset_chase
            )
        )
        {
            h_chase_ctrl.reset_chase();
        }
    }


    // ====================================================
    // RESET DOWNWARDS VERTICAL CHASE
    // ====================================================
    var v_chase_obj =
        asset_get_index(
            "oVerticalChaseController"
        );

    if (v_chase_obj != -1)
    {
        var v_chase_ctrl =
            instance_find(
                v_chase_obj,
                0
            );

        if (
            v_chase_ctrl != noone &&
            variable_instance_exists(
                v_chase_ctrl,
                "reset_chase"
            ) &&
            is_callable(
                v_chase_ctrl.reset_chase
            )
        )
        {
            v_chase_ctrl.reset_chase();
        }
    }


    // ====================================================
    // RESET UPWARDS CHASE
    // ====================================================
    var up_chase_obj =
        asset_get_index(
            "oUpwardsChaseController"
        );

    if (up_chase_obj != -1)
    {
        var up_chase_ctrl =
            instance_find(
                up_chase_obj,
                0
            );

        if (
            up_chase_ctrl != noone &&
            variable_instance_exists(
                up_chase_ctrl,
                "reset_chase"
            ) &&
            is_callable(
                up_chase_ctrl.reset_chase
            )
        )
        {
            up_chase_ctrl.reset_chase();
        }
    }


    // ----------------------------------------------------
    // Finish respawn
    // ----------------------------------------------------
    global.cam_death_lock_active = false;

    global.inp_jump_press = false;
    global.inp_jump_held  = false;

    instance_destroy();
}