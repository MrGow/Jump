/// oCheckpoint — Step

if (!enabled) exit;

// Sync visual active state from global checkpoint
is_active_checkpoint =
    variable_global_exists("checkpoint_set") &&
    global.checkpoint_set &&
    variable_global_exists("checkpoint_room") &&
    variable_global_exists("checkpoint_id") &&
    global.checkpoint_room == room &&
    global.checkpoint_id == checkpoint_id;

// Activate when player passes/touches it
var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var l = bbox_left  - touch_pad;
var r = bbox_right + touch_pad;
var t = bbox_top   - touch_pad;
var b = bbox_bottom + touch_pad;

var overlap =
    (p.bbox_right  > l) &&
    (p.bbox_left   < r) &&
    (p.bbox_bottom > t) &&
    (p.bbox_top    < b);

if (overlap)
{
    var already_active =
        variable_global_exists("checkpoint_set") &&
        global.checkpoint_set &&
        variable_global_exists("checkpoint_room") &&
        variable_global_exists("checkpoint_id") &&
        global.checkpoint_room == room &&
        global.checkpoint_id == checkpoint_id;

    if (!already_active)
    {
        global.checkpoint_set  = true;
        global.checkpoint_room = room;
        global.checkpoint_x    = respawn_x;
        global.checkpoint_y    = respawn_y;
        global.checkpoint_id   = checkpoint_id;

        // If run controller exists in this room, update its local spawn too
        if (instance_exists(oRunController)) {
            oRunController.spawn_x = respawn_x;
            oRunController.spawn_y = respawn_y;
        }

        is_active_checkpoint = true;
    }
}