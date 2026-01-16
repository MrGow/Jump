/// oCamera - Create (FULL FIXED)

target_obj = oPlayer;
target     = noone;

// ---------------- Camera setup ----------------
view_index = 0;
cam = view_camera[view_index];
camera_set_view_size(cam, 640, 360);

// IMPORTANT: needed so Draw GUI runs
visible = true;

// Logical (unshaken) camera pos
cam_logic_x = camera_get_view_x(cam);
cam_logic_y = camera_get_view_y(cam);

// ---------------- Zone state ----------------
active_zone = noone;
pending_zone = noone;

// ---------------- Fade state ----------------
zone_fade_enable = true;

fade_state = 0;   // 0 none, 1 out, 2 hold, 3 in
fade_alpha = 0;
fade_hold  = 0;

// Fade tuning (out faster than in so you don't see the fall)
fade_speed_out  = 0.12;   // faster to black
fade_speed_in   = 0.06;   // slower back in
fade_hold_frames = 14;

// Start fade before leaving zone
zone_fade_margin = 64;    // was 24; bigger = earlier fade

// ---------------- Post-transition polish ----------------
post_fade_settle_frames = 10;
post_fade_settle        = 0;

post_transition_air_lock_frames = 10;
post_transition_air_lock        = 0;

// ---------------- Handover guard ----------------
transition_guard_max = 3;
transition_guard     = 0;

// ---------------- Debug ----------------
debug_cam          = true;
debug_pulse_frames = 12;
debug_pulse        = 0;

// ---------------- Room Start placement mode ----------------
if (!variable_instance_exists(id, "zone_start_mode")) zone_start_mode = "center"; // "center" or "topleft"

// ------------------------------------------------------------
// EARLY-PAN TUNING (more forward visibility)
// ------------------------------------------------------------
deadzone_frac_x  = 0.32;
deadzone_frac_y  = 0.12;
deadzone_min_x   = 8;
deadzone_min_y   = 8;

pan_bias_max     = 80;
pan_bias_lerp    = 0.28;

smooth_follow    = 0.18;
y_bias           = -14;

lookahead_max    = 140;
lookahead_lerp   = 0.28;
lookahead_x      = 0;

pan_bias         = 0;
prev_px          = 0;

// ---------------- Single instance safety ----------------
if (instance_number(oCamera) > 1) { instance_destroy(); exit; }

// ------------------------------------------------------------
// Helper: find zone containing point (SAFE, no with() writeback)
// ------------------------------------------------------------
function cam_find_zone(_px, _py, _exclude)
{
    var n = instance_number(oCamZone);
    for (var i = 0; i < n; i++)
    {
        var z = instance_find(oCamZone, i);
        if (z == noone || z == _exclude) continue;

        if (is_callable(z.update_rect)) z.update_rect();

        if (point_in_rectangle(_px, _py, z.left, z.top, z.right, z.bottom))
            return z;
    }
    return noone;
}

// ------------------------------------------------------------
// Helper: freeze player locomotion during transitions (drop only)
// ------------------------------------------------------------
function cam_transition_freeze_player()
{
    if (!instance_exists(target)) return;

    // stop horizontal motion
    if (variable_instance_exists(target, "hsp")) target.hsp = 0;

    // cancel upward velocity (allow fall)
    if (variable_instance_exists(target, "vsp") && target.vsp < 0) target.vsp = 0;

    // kill jump charge flags if present
    if (variable_instance_exists(target, "jump_charge"))    target.jump_charge = 0;
    if (variable_instance_exists(target, "jump_charging"))  target.jump_charging = false;
    if (variable_instance_exists(target, "charging"))       target.charging = false;
    if (variable_instance_exists(target, "can_jump"))       target.can_jump = false;

    // generic state
    if (variable_instance_exists(target, "state")) target.state = "fall";
}
