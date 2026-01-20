/// oGravityLaser - Create
event_inherited();

enabled = true;

// Gravity multiplier inside:
// green/low example: 0.55
// red/high example: 2.00
if (!variable_instance_exists(id, "grav_mul")) grav_mul = 0.55;

// Soft edge influence (0 = hard edge, >0 = soft)
if (!variable_instance_exists(id, "soft_edge")) soft_edge = 0; // pixels, e.g. 24

// Debug tint helper
is_low = (grav_mul < 1.0);

// Sampler (AABB with optional soft edge)
field_sample = function(_px, _py)
{
    // Compute AABB from bbox (works with scaled sprites)
    var l = bbox_left;
    var r = bbox_right;
    var t = bbox_top;
    var b = bbox_bottom;

    if (_px < l || _px > r || _py < t || _py > b) {
        return { wind_x: 0, wind_y: 0, grav_mul: 1.0, mag_x: 0, mag_y: 0, inf: 0, priority: priority };
    }

    var inf = 1.0;

    if (soft_edge > 0)
    {
        // Distance to nearest edge (inside rect)
        var de = min(min(_px - l, r - _px), min(_py - t, b - _py));
        inf = clamp(de / soft_edge, 0, 1);
        inf = power(inf, falloff_pow);
    }

    return {
        wind_x: 0,
        wind_y: 0,
        grav_mul: grav_mul,
        mag_x: 0, mag_y: 0,
        inf: inf,
        priority: priority
    };
};
