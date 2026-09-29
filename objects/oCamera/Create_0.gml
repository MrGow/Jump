/// oCamera — Create

target_obj = oPlayer;
target = noone;

view_index = 0;
cam = view_camera[view_index];
camera_set_view_size(cam, 640, 360);
visible = true;

// Logical position, before train sway and shake.
cam_logic_x = camera_get_view_x(cam);
cam_logic_y = camera_get_view_y(cam);

// Zones
active_zone = noone;
pending_zone = noone;
zone_fade_enable = true;

fade_state = 0;
fade_alpha = 0;
fade_hold_timer = 0;

fade_speed_out = 0.12;
fade_speed_in = 0.06;
fade_hold_frames = 14;
fade_speed = fade_speed_out;

zone_fade_margin = 64;
post_fade_settle_frames = 10;
post_fade_settle = 0;
settle_frames = post_fade_settle_frames;

transition_guard_max = 3;
transition_guard = 0;
zone_transition_lock_frames = transition_guard_max;

debug_cam = true;
debug_pulse_frames = 12;
debug_pulse = 0;

if (!variable_instance_exists(id, "zone_start_mode"))
    zone_start_mode = "center";

// Existing follow tuning
deadzone_frac_x = 0.32;
deadzone_frac_y = 0.12;
deadzone_min_x = 8;
deadzone_min_y = 8;

pan_bias_max = 80;
pan_bias_lerp = 0.28;
smooth_follow = 0.18;
y_bias = -14;

lookahead_max = 140;
lookahead_lerp = 0.28;
lookahead_x = 0;
pan_bias = 0;
prev_px = 0;

// Arena camera control. oGunShipArenaTrigger sets the
// target position and toggles arena_lock_active.
arena_lock_active = false;
arena_lock_x = cam_logic_x;
arena_lock_y = cam_logic_y;
arena_was_locked = false;
arena_release_frames = 0;

if (instance_number(oCamera) > 1)
{
    instance_destroy();
    exit;
}

function cam_find_zone(_px, _py, _exclude)
{
    var n = instance_number(oCamZone);

    for (var i = 0; i < n; i++)
    {
        var z = instance_find(oCamZone, i);

        if (z == noone || z == _exclude)
            continue;

        if (is_callable(z.update_rect))
            z.update_rect();

        if (point_in_rectangle(
            _px,
            _py,
            z.left,
            z.top,
            z.right,
            z.bottom
        ))
        {
            return z;
        }
    }

    return noone;
}

function cam_transition_freeze_player()
{
    if (!instance_exists(target))
        return;

    // Preserve death state.
    var is_dead =
        variable_instance_exists(target, "state") &&
        target.state == "dead";

    if (is_dead)
        return;

    if (variable_instance_exists(target, "hsp"))
        target.hsp = 0;

    if (variable_instance_exists(target, "vsp") &&
        target.vsp < 0)
    {
        target.vsp = 0;
    }

    if (variable_instance_exists(target, "jump_charge"))
        target.jump_charge = 0;

    if (variable_instance_exists(target, "jump_charging"))
        target.jump_charging = false;

    if (variable_instance_exists(target, "charging"))
        target.charging = false;

    if (variable_instance_exists(target, "can_jump"))
        target.can_jump = false;

    if (variable_instance_exists(target, "state"))
        target.state = "fall";
}