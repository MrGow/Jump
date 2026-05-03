/// oSpringPlatform — End Step
/// Trigger spring bounce using the new floor-surface / standing-platform system.

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

// Don't retrigger on dead player
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// ----------------------------------------------------
// Per-player retrigger lock
// ----------------------------------------------------
if (!variable_instance_exists(p, "spring_retrigger_lock")) p.spring_retrigger_lock = 0;
if (p.spring_retrigger_lock > 0) {
    p.spring_retrigger_lock--;
    exit;
}

// ----------------------------------------------------
// Spring usable top surface
// ----------------------------------------------------
var spring_surf_y = bbox_top + surface_y_offset;

var l = bbox_left  + top_inset + surface_x_offset;
var r = bbox_right - top_inset + surface_x_offset;

if (r < l) {
    var mid = (bbox_left + bbox_right) * 0.5 + surface_x_offset;
    l = mid;
    r = mid;
}

var pad_cx = (l + r) * 0.5;

// ----------------------------------------------------
// Player previous/current feet
// ----------------------------------------------------
var feet_now  = p.bbox_bottom;
var feet_prev;

if (variable_instance_exists(p, "crusher_prev_feet_y")) {
    feet_prev = p.crusher_prev_feet_y;
} else {
    var pv_fallback = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    feet_prev = feet_now - pv_fallback;
}

var prev_vsp = 0;
if (variable_instance_exists(p, "crusher_prev_vsp")) prev_vsp = p.crusher_prev_vsp;
else if (variable_instance_exists(p, "vsp"))         prev_vsp = p.vsp;

// ----------------------------------------------------
// Overlap requirements
// ----------------------------------------------------
var overlap_l = max(p.bbox_left,  l);
var overlap_r = min(p.bbox_right, r);
var overlap_w = overlap_r - overlap_l;

if (overlap_w < min_overlap_px) exit;

// ----------------------------------------------------
// New preferred trigger:
// player is actually standing on this spring in the new system
// ----------------------------------------------------
var standing_on_this =
    variable_instance_exists(p, "standing_platform") &&
    (p.standing_platform == id);

// Fallbacks for safety / landing edge cases
var crossed_top =
    (feet_prev <= spring_surf_y) &&
    (feet_now  >= spring_surf_y - 1);

var near_top =
    (feet_now >= spring_surf_y - 4) &&
    (feet_now <= spring_surf_y + 5) &&
    (prev_vsp >= 0 || p.vsp >= 0);

var blocked_down_on_top =
    (prev_vsp > 0) &&
    variable_instance_exists(p, "vsp") &&
    (p.vsp == 0) &&
    (feet_now >= spring_surf_y - 4) &&
    (feet_now <= spring_surf_y + 5);

// Only trigger when actually landing / grounded on the spring
if (!(standing_on_this || crossed_top || near_top || blocked_down_on_top)) exit;

// Reject upward motion
if (prev_vsp < 0 && p.vsp < 0) exit;

// ----------------------------------------------------
// Choose horizontal kick direction
// Prefer incoming horizontal direction.
// If nearly zero, use side of pad player is on.
// If still ambiguous, use facing.
// ----------------------------------------------------
var incoming_h = 0;
if (variable_instance_exists(p, "hsp")) incoming_h = p.hsp;

var kick_dir = 0;

if (abs(incoming_h) > 0.15) {
    kick_dir = sign(incoming_h);
} else {
    var player_cx = (p.bbox_left + p.bbox_right) * 0.5;

    if (player_cx < pad_cx - edge_bias_px) kick_dir = -1;
    else if (player_cx > pad_cx + edge_bias_px) kick_dir = 1;
    else if (variable_instance_exists(p, "facing")) kick_dir = p.facing;
    else kick_dir = 1;
}

// ----------------------------------------------------
// Preserve momentum if already enough.
// Otherwise inject minimum kick.
// ----------------------------------------------------
var out_h_local = incoming_h * spring_h_mult;

if (abs(out_h_local) < spring_min_h_kick) {
    out_h_local = spring_min_h_kick * kick_dir;
}

out_h_local = clamp(out_h_local, -spring_max_h_kick, spring_max_h_kick);

// Store so with(p) can safely read via other
launch_h = out_h_local;

with (p)
{
    // Snap neatly to spring surface before launch
    var snap_dy = (other.bbox_top + other.surface_y_offset) - bbox_bottom;
    y += snap_dy;

    // Kill grounded / charge / pending bounce states
    if (variable_instance_exists(id, "jump_charging"))         jump_charging = false;
    if (variable_instance_exists(id, "jump_charge"))           jump_charge = 0;
    if (variable_instance_exists(id, "jump_charge_level"))     jump_charge_level = 0;
    if (variable_instance_exists(id, "charge_grace"))          charge_grace = 0;
    if (variable_instance_exists(id, "support_grace"))         support_grace = 0;
    if (variable_instance_exists(id, "charge_start_lock"))     charge_start_lock = 0;
    if (variable_instance_exists(id, "support_stable_frames")) support_stable_frames = 0;
    if (variable_instance_exists(id, "edge_charge_fail"))      edge_charge_fail = 0;
    if (variable_instance_exists(id, "bounce_pending"))        bounce_pending = false;
    if (variable_instance_exists(id, "bounce_timer"))          bounce_timer = 0;
    if (variable_instance_exists(id, "prev_on_ground"))        prev_on_ground = false;
    if (variable_instance_exists(id, "coyote_timer"))          coyote_timer = 0;

    // Detach from current surface so launch is clean
    if (variable_instance_exists(id, "standing_platform"))      standing_platform = noone;
    if (variable_instance_exists(id, "standing_platform_xoff")) standing_platform_xoff = 0;

    if (variable_instance_exists(id, "hsp")) hsp = other.launch_h;
    if (variable_instance_exists(id, "vsp")) vsp = -other.spring_power;

    if (variable_instance_exists(id, "state")) state = "jumping";
    if (variable_instance_exists(id, "facing") && hsp != 0) facing = sign(hsp);

    spring_retrigger_lock = other.player_retrigger_lock_frames;
}

// Play spring press/recover animation
pressed_timer = pressed_frames;