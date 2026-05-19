/// oIntraTeleportController — Create

target_id = "";
trigger_id = noone;

fade_alpha = 0;
fade_speed_out = 0.12;
fade_speed_in  = 0.06;
hold_frames = 10;

state = "fade_out";
did_teleport = false;

global.intra_teleport_active = true;

visible = true;
depth = -10000000;

// ----------------------------------------------------
// Find destination by teleport_id
// ----------------------------------------------------
find_destination = function(_id)
{
    var n = instance_number(oIntraTeleportDest);

    for (var i = 0; i < n; i++)
    {
        var d = instance_find(oIntraTeleportDest, i);
        if (d == noone) continue;

        if (variable_instance_exists(d, "teleport_id") && d.teleport_id == _id)
        {
            return d;
        }
    }

    return noone;
};

// ----------------------------------------------------
// Find CamZone containing point
// ----------------------------------------------------
find_zone_at = function(_px, _py)
{
    var n = instance_number(oCamZone);

    for (var i = 0; i < n; i++)
    {
        var z = instance_find(oCamZone, i);
        if (z == noone) continue;

        if (is_callable(z.update_rect)) z.update_rect();

        if (point_in_rectangle(_px, _py, z.left, z.top, z.right, z.bottom))
        {
            return z;
        }
    }

    return noone;
};

// ----------------------------------------------------
// Force camera into destination zone
// ----------------------------------------------------
snap_camera_to_zone = function(_zone, _px, _py)
{
    if (!instance_exists(oCamera)) exit;

    var cam_inst = instance_find(oCamera, 0);
    if (cam_inst == noone) exit;

    var cam = cam_inst.cam;

    var vw = camera_get_view_width(cam);
    var vh = camera_get_view_height(cam);

    if (instance_exists(_zone))
    {
        if (is_callable(_zone.update_rect)) _zone.update_rect();

        var zl = _zone.left;
        var zt = _zone.top;
        var zr = _zone.right;
        var zb = _zone.bottom;

        var yb = variable_instance_exists(cam_inst, "y_bias") ? cam_inst.y_bias : -14;

        var tx = round(_px - vw * 0.5);
        var ty = round((_py + yb) - vh * 0.5);

        if ((zr - zl) <= vw) tx = zl;
        else tx = clamp(tx, zl, zr - vw);

        if ((zb - zt) <= vh) ty = zt;
        else ty = clamp(ty, zt, zb - vh);

        cam_inst.active_zone = _zone;
        cam_inst.pending_zone = noone;

        cam_inst.cam_logic_x = tx;
        cam_inst.cam_logic_y = ty;

        if (variable_instance_exists(cam_inst, "fade_state")) cam_inst.fade_state = 0;
        if (variable_instance_exists(cam_inst, "fade_alpha")) cam_inst.fade_alpha = 0;
        if (variable_instance_exists(cam_inst, "fade_hold"))  cam_inst.fade_hold  = 0;

        if (variable_instance_exists(cam_inst, "transition_guard"))
        {
            cam_inst.transition_guard = variable_instance_exists(cam_inst, "transition_guard_max")
                ? cam_inst.transition_guard_max
                : 3;
        }

        if (variable_instance_exists(cam_inst, "post_fade_settle")) cam_inst.post_fade_settle = 0;
        if (variable_instance_exists(cam_inst, "post_transition_air_lock")) cam_inst.post_transition_air_lock = 6;

        if (variable_instance_exists(cam_inst, "prev_px"))     cam_inst.prev_px = _px;
        if (variable_instance_exists(cam_inst, "lookahead_x")) cam_inst.lookahead_x = 0;
        if (variable_instance_exists(cam_inst, "pan_bias"))    cam_inst.pan_bias = 0;

        camera_set_view_pos(cam, tx, ty);
    }
};