/// oCheckpoint — Step

if (!enabled) exit;

if (!variable_instance_exists(id, "snd_checkpoint_activate")) snd_checkpoint_activate = asset_get_index("CheckpointActivate1");
if (!variable_instance_exists(id, "checkpoint_sfx_gain")) checkpoint_sfx_gain = 1.0;

var active_now =
    variable_global_exists("checkpoint_set") &&
    global.checkpoint_set &&
    variable_global_exists("checkpoint_room") &&
    variable_global_exists("checkpoint_id") &&
    global.checkpoint_room == room &&
    global.checkpoint_id == checkpoint_id;

is_active_checkpoint = active_now;

var p = instance_find(oPlayer, 0);
if (p != noone)
{
    if (!(variable_instance_exists(p, "state") && p.state == "dead"))
    {
        var l = bbox_left   - touch_pad;
        var r = bbox_right  + touch_pad;
        var t = bbox_top    - touch_pad;
        var b = bbox_bottom + touch_pad;

        var overlap =
            (p.bbox_right  > l) &&
            (p.bbox_left   < r) &&
            (p.bbox_bottom > t) &&
            (p.bbox_top    < b);

        if (overlap && !active_now)
        {
            global.checkpoint_set  = true;
            global.checkpoint_room = room;
            global.checkpoint_x    = respawn_x;
            global.checkpoint_y    = respawn_y;
            global.checkpoint_id   = checkpoint_id;

            if (instance_exists(oRunController)) {
                oRunController.spawn_x = respawn_x;
                oRunController.spawn_y = respawn_y;
            }

            // Bank carried chips
            if (!variable_global_exists("chips_collected")) global.chips_collected = 0;
            if (!variable_global_exists("chips_carried"))   global.chips_carried   = 0;

            if (!variable_global_exists("chips_found")) {
                global.chips_found = ds_map_create();
            }

            if (!variable_global_exists("chips_carried_ids")) {
                global.chips_carried_ids = ds_map_create();
            }

            if (global.chips_carried > 0)
            {
                var old_count = global.chips_collected;

                var key = ds_map_find_first(global.chips_carried_ids);

                while (!is_undefined(key))
                {
                    if (!ds_map_exists(global.chips_found, key)) {
                        ds_map_add(global.chips_found, key, true);
                        global.chips_collected += 1;
                    }

                    key = ds_map_find_next(global.chips_carried_ids, key);
                }

                ds_map_clear(global.chips_carried_ids);
                global.chips_carried = 0;

                // ----------------------------------------------------
                // Chip achievements
                // ----------------------------------------------------
                if (function_exists(scr_achievement_unlock))
                {
                    if (global.chips_collected >= 1)  scr_achievement_unlock("ACH_CHIP_1");
                    if (global.chips_collected >= 5)  scr_achievement_unlock("ACH_CHIP_2");
                    if (global.chips_collected >= 10) scr_achievement_unlock("ACH_CHIP_3");
                    if (global.chips_collected >= 15) scr_achievement_unlock("ACH_CHIP_4");

                    if (global.chips_collected >= global.chips_total) {
                        scr_achievement_unlock("ACH_CHIP_5");
                    }
                }

                if (instance_exists(oChipBankPopup)) {
                    with (oChipBankPopup) instance_destroy();
                }

                var popup = instance_create_depth(0, 0, -1000000, oChipBankPopup);
                popup.from_count = old_count;
                popup.to_count = global.chips_collected;
                popup.display_count = old_count;
            }

            // Autosave at checkpoint
            if (variable_global_exists("save_slot")) {
                scr_save_game(global.save_slot);
            }

            is_active_checkpoint = true;
            active_now = true;

            checkpoint_anim_state = "activating";
            image_index = 0;
            image_speed = activate_anim_speed;

            scr_play_sfx(snd_checkpoint_activate, checkpoint_sfx_gain, random_range(0.98, 1.02));
        }
    }
}

// Animation control
if (!active_now)
{
    checkpoint_anim_state = "inactive";
    image_speed = 0;
    image_index = inactive_frame;
}
else
{
    if (checkpoint_anim_state == "inactive")
    {
        checkpoint_anim_state = "active";
        image_index = active_loop_from;
        image_speed = active_loop_speed;
    }

    if (checkpoint_anim_state == "activating")
    {
        image_speed = activate_anim_speed;

        if (image_index >= image_number - 1)
        {
            checkpoint_anim_state = "active";
            image_index = active_loop_from;
            image_speed = active_loop_speed;
        }
    }
    else if (checkpoint_anim_state == "active")
    {
        image_speed = active_loop_speed;

        if (image_index < active_loop_from || image_index > active_loop_to + 0.99)
        {
            image_index = active_loop_from;
        }

        if (image_index >= active_loop_to + 0.99)
        {
            image_index = active_loop_from;
        }
    }
}