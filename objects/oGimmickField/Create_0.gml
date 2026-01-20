/// oGimmickField - Create (PARENT)
enabled = true;

// Bigger number = "wins" when choosing strongest (optional)
if (!variable_instance_exists(id, "priority")) priority = 0;

// Edge softness for circles/rect falloff
if (!variable_instance_exists(id, "falloff_pow")) falloff_pow = 1.8;

// Debug
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;

// Children should override by defining a function named `field_sample` in their Create.
field_sample = function(_px, _py)
{
    // Default: no effect
    return { wind_x: 0, wind_y: 0, grav_mul: 1.0, mag_x: 0, mag_y: 0, inf: 0, priority: priority };
};

