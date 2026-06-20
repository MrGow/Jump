/// oCheckpoint — Step

if (!enabled) exit;

// Hot-reload safety
if (!variable_instance_exists(id, "snd_checkpoint_activate")) snd_checkpoint_activate = asset_get_index("CheckpointActivate1");
if (!variable_instance_exists(id, "checkpoint_sfx_gain")) checkpoint_sfx_gain = 1.0;

// ----------------------------------------------------
// Sync active state from global checkpoint
// ----------------------------------------------------
var active_now =
    variable_global_exists("checkpoint_set") &&
    global.checkpoint_set &&
    variable_global_exists("checkpoint_room") &&
    variable_global_exists("checkpoint_id") &&
    global.checkpoint_room == room &&
    global.checkpoint_id == checkpoint_id;

is_active_checkpoint = active_now;

// ----------------------------------------------------
// Activate when player passes/touches it
// ----------------------------------------------------
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

            is_active_checkpoint = true;
            active_now = true;

            checkpoint_anim_state = "activating";
            image_index = 0;
            image_speed = activate_anim_speed;

            // Play activation sound exactly when the flag-raising animation starts
            scr_play_sfx(snd_checkpoint_activate, checkpoint_sfx_gain, random_range(0.98, 1.02));
        }
    }
}

// ----------------------------------------------------
// Animation control
// ----------------------------------------------------
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
        // This covers room reloads where this checkpoint is already active.
        // No sound here because it was already activated previously.
        checkpoint_anim_state = "active";
        image_index = active_loop_from;
        image_speed = active_loop_speed;
    }

    if (checkpoint_anim_state == "activating")
    {
        image_speed = activate_anim_speed;

        // Once the full activation animation reaches the end,
        // switch into the flag-blowing loop.
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