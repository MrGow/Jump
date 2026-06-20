/// oCheckpoint — Create

sprite_index = spriteCheckpoint;
image_speed  = 0;
image_index  = 0;

enabled = true;

// Checkpoint SFX
snd_checkpoint_activate = asset_get_index("CheckpointActivate1");
checkpoint_sfx_gain = 1.0;

// Optional editor override. If blank, auto-build one.
if (!variable_instance_exists(id, "checkpoint_id")) checkpoint_id = "";
if (checkpoint_id == "") {
    checkpoint_id = string(room) + "_" + string(round(x)) + "_" + string(round(y));
}

// Where player respawns when this checkpoint is active
if (!variable_instance_exists(id, "respawn_x")) respawn_x = x;
if (!variable_instance_exists(id, "respawn_y")) respawn_y = y;

// Optional tweak
if (!variable_instance_exists(id, "respawn_y_offset")) respawn_y_offset = -30;
respawn_y += respawn_y_offset;

// Touch detection padding
if (!variable_instance_exists(id, "touch_pad")) touch_pad = 8;

// Animation tuning
inactive_frame = 0;

// Your visible frames 7-11 become GM frames 6-10
active_loop_from = 6;
active_loop_to   = 10;

activate_anim_speed = 1;
active_loop_speed   = 1;

// State
is_active_checkpoint = false;
checkpoint_anim_state = "inactive"; // inactive, activating, active