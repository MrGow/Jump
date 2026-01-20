/// scr_fields_get_effects(px, py)
/// Returns: { wind_x, wind_y, grav_mul }
/// - wind is additive across all fields
/// - gravity chooses the strongest field by priority then influence

function scr_fields_get_effects(_px, _py)
{
    var out = { wind_x: 0, wind_y: 0, grav_mul: 1.0 };

    var best_inf = 0;
    var best_pri = -999999;
    var best_mul = 1.0;

    var n = instance_number(oGimmickField);
    for (var i = 0; i < n; i++)
    {
        var f = instance_find(oGimmickField, i);
        if (f == noone) continue;
        if (!f.enabled) continue;

        if (is_undefined(f.field_sample)) continue;

        var e = f.field_sample(_px, _py);

        // Additive forces
        out.wind_x += e.wind_x;
        out.wind_y += e.wind_y;

        // Gravity: choose strongest by priority then influence
        if (e.grav_mul != 1.0)
        {
            if (e.priority > best_pri || (e.priority == best_pri && e.inf > best_inf))
            {
                best_pri = e.priority;
                best_inf = e.inf;
                best_mul = e.grav_mul;
            }
        }
    }

    if (best_pri > -999999)
    {
        out.grav_mul = lerp(1.0, best_mul, best_inf);
    }

    return out;
}
