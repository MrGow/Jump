/// oVentField - Create
event_inherited();

enabled = true;

// Circle
if (!variable_instance_exists(id, "radius")) radius = 96;

// Direction vector: right (1,0), left (-1,0), up (0,-1), down (0,1)
if (!variable_instance_exists(id, "wind_dir_x")) wind_dir_x = 1;
if (!variable_instance_exists(id, "wind_dir_y")) wind_dir_y = 0;

// Strength (tune)
if (!variable_instance_exists(id, "wind_strength")) wind_strength = 0.25;

// Optional override falloff
if (!variable_instance_exists(id, "falloff_pow")) falloff_pow = 1.6;

// Sampler
field_sample = function(_px, _py)
{
    var dx = _px - x;
    var dy = _py - y;
    var d  = sqrt(dx*dx + dy*dy);

    if (d > radius) {
        return { wind_x: 0, wind_y: 0, grav_mul: 1.0, mag_x: 0, mag_y: 0, inf: 0, priority: priority };
    }

    var t   = 1.0 - (d / radius);
    var inf = power(t, falloff_pow);

    return {
        wind_x: wind_dir_x * wind_strength * inf,
        wind_y: wind_dir_y * wind_strength * inf,
        grav_mul: 1.0,
        mag_x: 0, mag_y: 0,
        inf: inf,
        priority: priority
    };
};

