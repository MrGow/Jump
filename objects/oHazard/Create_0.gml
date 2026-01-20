/// oHazard - Create (PARENT)
enabled = true;

// Children can toggle this during Step (e.g. crushers only active when down)
active = true;

// Optional: some hazards only kill when hit from certain direction, etc.
if (!variable_instance_exists(id, "kill_mode")) kill_mode = "touch"; 
// "touch" (default), "active_only", "top_only", etc.

// Debug
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;