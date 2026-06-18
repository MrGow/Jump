/// oLowGravityZone — Create

enabled = true;

// Upward gravity while rising.
// Lower = much higher jumps.
if (!variable_instance_exists(id, "low_grav_mult")) low_grav_mult = 0.35;

// Falling gravity.
// Keep this close to normal so the player doesn't float forever.
if (!variable_instance_exists(id, "low_fall_mult")) low_fall_mult = 0.95;

if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;