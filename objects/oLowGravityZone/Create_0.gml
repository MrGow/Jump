/// oLowGravityZone — Create

enabled = true;

// Tuning
if (!variable_instance_exists(id, "low_grav_mult")) low_grav_mult = 0.45;
if (!variable_instance_exists(id, "low_fall_mult")) low_fall_mult = 0.55;

// Debug
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;