/// oCamera - Step (FULL FIXED: predictive fade + separate fade speeds + no momentum carry)

if (debug_pulse > 0) debug_pulse--;
if (transition_guard > 0) transition_guard--;

// Resolve target if needed
if (!instance_exists(target)) {
    var p = instance_find(target_obj, 0);
    if (p != noone) target = p; else exit;
}

var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

// Use the logical, unshaken camera as our "current" pos
var vx = cam_logic_x;
var vy = cam_logic_y;

// ----------------------------------------------------
// Fade state machine (overlay drawn in Draw GUI)
// ----------------------------------------------------
if (zone_fade_enable) {

    // Lock player while ANY fade is active (out/hold/in)
    if (variable_global_exists("input") && is_struct(global.input)) {
        global.input.player_locked = (fade_state != 0);
    }

    // Kill locomotion for the entire transition so you "drop only"
    if (fade_state != 0) {
        cam_transition_freeze_player();
    }

    if (fade_state == 1) {
        // FADE OUT (fast)
        fade_alpha += fade_speed_out;

        if (fade_alpha >= 1) {
            fade_alpha = 1;

            // Commit zone switch UNDER FULL BLACK
            if (instance_exists(pending_zone)) {
                if (debug_cam) show_debug_message("FADE COMMIT zone -> id=" + string(pending_zone));
                active_zone = pending_zone;
            } else {
                if (debug_cam) show_debug_message("FADE COMMIT but pending_zone was noone");
            }
            pending_zone = noone;

            // Snap logical camera immediately inside the NEW zone
            if (instance_exists(active_zone)) {

                if (is_callable(active_zone.update_rect)) active_zone.update_rect();

                var zl2 = active_zone.left;
                var zt2 = active_zone.top;
                var zr2 = active_zone.right;
                var zb2 = active_zone.bottom;

                cam_logic_x = clamp(round(target.x - vw * 0.5), zl2, zr2 - vw);
                cam_logic_y = clamp(round(target.y - vh * 0.5), zt2, zb2 - vh);
            }

            // Hard-reset player locomotion AGAIN on commit
            cam_transition_freeze_player();

            // Reset these so the deadzone doesn't "lean" after snapping
            prev_px      = target.x;
            lookahead_x  = 0;
            pan_bias     = 0;

            // Post-transition polish timers
            post_fade_settle         = post_fade_settle_frames;
            post_transition_air_lock = post_transition_air_lock_frames;

            fade_hold  = fade_hold_frames;
            fade_state = 2;

            // Guard to prevent immediate flip-flop
            transition_guard = transition_guard_max;
        }
    }
    else if (fade_state == 2) {
        // HOLD BLACK
        fade_hold--;
        if (fade_hold <= 0) fade_state = 3;
    }
    else if (fade_state == 3) {
        // FADE IN (slower)
        fade_alpha -= fade_speed_in;

        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 0;
        }
    }
}
else {
    // Ensure we never leave the player locked if fades are disabled
    if (variable_global_exists("input") && is_struct(global.input)) {
        global.input.player_locked = false;
    }
}

// ----------------------------------------------------
// Post-transition air-lock: keep things calm for a few frames
// ----------------------------------------------------
if (post_transition_air_lock > 0) {
    post_transition_air_lock--;

    // Keep horizontal dead and cap fall so you don't instantly plummet a whole screen
    if (instance_exists(target)) {
        if (variable_instance_exists(target, "hsp")) target.hsp = 0;
        if (variable_instance_exists(target, "vsp")) target.vsp = min(target.vsp, 1.0);
    }
}

// ----------------------------------------------------
// Ensure we have an active zone (initialize if missing)
// ----------------------------------------------------
if (!instance_exists(active_zone) && fade_state == 0) {
    active_zone = cam_find_zone(target.x, target.y, noone);
    if (instance_exists(active_zone)) {
        if (debug_cam) show_debug_message("ZONE INIT -> " + string(active_zone));
    }
}

// ----------------------------------------------------
// Early fade trigger (PREDICTIVE)
// Start fade if player is outside the "inner band" now OR next frame
// ----------------------------------------------------
if (fade_state == 0 && zone_fade_enable && instance_exists(active_zone) && transition_guard <= 0) {

    if (is_callable(active_zone.update_rect)) active_zone.update_rect();

    var il = active_zone.left   + zone_fade_margin;
    var it = active_zone.top    + zone_fade_margin;
    var ir = active_zone.right  - zone_fade_margin;
    var ib = active_zone.bottom - zone_fade_margin;

    var hx = (variable_instance_exists(target, "hsp")) ? target.hsp : 0;
    var vv = (variable_instance_exists(target, "vsp")) ? target.vsp : 0;

    var px0 = target.x;
    var py0 = target.y;

    // predict: only downward matters visually
    var px1 = px0 + hx;
    var py1 = py0 + max(vv, 0);

    var out_now  = !point_in_rectangle(px0, py0, il, it, ir, ib);
    var out_next = !point_in_rectangle(px1, py1, il, it, ir, ib);

    if (out_now || out_next) {

        // Find a zone containing the player (prefer not current)
        var nz = cam_find_zone(px0, py0, active_zone);
        if (nz == noone) nz = cam_find_zone(px0, py0, noone);

        if (instance_exists(nz) && nz != active_zone) {
            pending_zone = nz;
            fade_state   = 1;
            if (debug_cam) show_debug_message("ZONE FADE START (predictive) -> " + string(nz));
        }
    }
}

// ----------------------------------------------------
// If still no zone, fallback to simple follow
// ----------------------------------------------------
if (!instance_exists(active_zone)) {
    var tx_fb = clamp(round(target.x - vw * 0.5), 0, max(0, room_width  - vw));
    var ty_fb = clamp(round(target.y - vh * 0.5), 0, max(0, room_height - vh));
    cam_logic_x = tx_fb;
    cam_logic_y = ty_fb;
    camera_set_view_pos(cam, cam_logic_x, cam_logic_y);
    exit;
}

// Ensure zone rect is fresh
if (is_callable(active_zone.update_rect)) active_zone.update_rect();

// Recompute zone rect
var zl = active_zone.left;
var zt = active_zone.top;
var zr = active_zone.right;
var zb = active_zone.bottom;

var zw = zr - zl;
var zh = zb - zt;

// ---------- compute deadzone in pixels ----------
var dzx = max(deadzone_min_x, round(vw * deadzone_frac_x));
var dzy = max(deadzone_min_y, round(vh * deadzone_frac_y));

// ---------- look-ahead from dx ----------
var px = target.x;
var py = target.y + y_bias;

var dx = px - prev_px;
prev_px = px;

var desired_look = clamp(dx * 10, -lookahead_max, lookahead_max);
lookahead_x = lerp(lookahead_x, desired_look, lookahead_lerp);

// Smoothed deadzone bias
var desired_bias = 0;
var speed_abs    = abs(dx);
if (speed_abs > 0.2) desired_bias = pan_bias_max * sign(dx);
pan_bias = lerp(pan_bias, desired_bias, pan_bias_lerp);

var dz_shift_x = pan_bias;

// Desired top-left starts from current logical view
var tx = vx;
var ty = vy;

// ---------------- X AXIS ----------------
if (zw <= vw) {
    tx = zl + (zw - vw) * 0.5;
} else {
    var focus_x = px + lookahead_x;
    var win_l   = vx + dzx + dz_shift_x;
    var win_r   = vx + vw - dzx + dz_shift_x;

    if (focus_x < win_l)        tx = focus_x - (dzx + dz_shift_x);
    else if (focus_x > win_r)   tx = focus_x - (vw - (dzx - dz_shift_x));

    tx = clamp(tx, zl, zr - vw);
}

// ---------------- Y AXIS ----------------
if (zh <= vh) {
    ty = zt + (zh - vh) * 0.5;
} else {
    var win_t = vy + dzy;
    var win_b = vy + vh - dzy;

    if (py < win_t)        ty = py - dzy;
    else if (py > win_b)   ty = py - (vh - dzy);

    ty = clamp(ty, zt, zb - vh);
}

// ---------------- Smooth apply (to logical) ----------------
var sf = smooth_follow;
if (post_fade_settle > 0) { sf = 0.08; post_fade_settle--; }

var nx = lerp(vx, tx, sf);
var ny = lerp(vy, ty, sf);

// Pixel snap to avoid shimmer
if (abs(nx - tx) <= 0.5) nx = tx;
if (abs(ny - ty) <= 0.5) ny = ty;

// Store logical pos
cam_logic_x = round(nx);
cam_logic_y = round(ny);

// --- Camera shake hook (optional) ---
var jx = 0, jy = 0;
if (variable_global_exists("shake_time") && variable_global_exists("shake_mag")) {
    if (global.shake_time > 0 && global.shake_mag > 0) {
        jx = irandom_range(-global.shake_mag, global.shake_mag);
        jy = irandom_range(-global.shake_mag, global.shake_mag);
    }
}

// Apply final position
camera_set_view_pos(cam, cam_logic_x + jx, cam_logic_y + jy);
