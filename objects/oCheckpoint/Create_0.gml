/// oCheckpoint — Create

sprite_index = spriteCheckpoint;
image_speed  = 0;

enabled = true;

// Optional editor override. If blank, auto-build one.
if (!variable_instance_exists(id, "checkpoint_id")) checkpoint_id = "";
if (checkpoint_id == "") {
    checkpoint_id = string(room) + "_" + string(round(x)) + "_" + string(round(y));
}

// Where player respawns when this checkpoint is active
if (!variable_instance_exists(id, "respawn_x")) respawn_x = x;
if (!variable_instance_exists(id, "respawn_y")) respawn_y = y;

// Optional tweak if your sprite needs the player to spawn slightly above it
if (!variable_instance_exists(id, "respawn_y_offset")) respawn_y_offset = 0;
respawn_y += respawn_y_offset;

// Touch detection padding
if (!variable_instance_exists(id, "touch_pad")) touch_pad = 8;

// Visual state
is_active_checkpoint = false;