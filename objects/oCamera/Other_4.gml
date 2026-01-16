
/// oCamera - Room Start  [FULL EVENT - safe defaults]

view_index = 0;
cam = view_camera[view_index];
camera_set_view_size(cam, 640, 360);

// IMPORTANT: needed so Draw GUI runs
visible = true;

// ---------- HOT-RELOAD / ORDER SAFETY ----------
// Room Start can fire before Create finished in some setups / hot reloads,
// so ensure key vars exist before reading them.
if (!variable_instance_exists(id, "zone_start_mode")) zone_start_mode = "center"; // "center" or "topleft"

if (!variable_instance_exists(id, "fade_state"))   fade_state   = 0;
if (!variable_instance_exists(id, "fade_alpha"))   fade_alpha   = 0;
if (!variable_instance_exists(id, "pending_zone")) pending_zone = noone;
if (!variable_instance_exists(id, "fade_hold"))    fade_hold    = 0;

if (!variable_instance_exists(id, "cam_logic_x")) cam_logic_x = 0;
if (!variable_instance_exists(id, "cam_logic_y")) cam_logic_y = 0;

// Resolve target
if (!instance_exists(target)) {
    var p = instance_find(target_obj, 0);
    if (p != noone) target = p;
}
if (!instance_exists(target)) exit;

// Ensure all zones have correct rects RIGHT NOW
with (oCamZone) {
    if (is_callable(update_rect)) update_rect();
}

// Find zone containing the player (safe loop, no with-writeback needed)
var z = noone;
var n = instance_number(oCamZone);
for (var i = 0; i < n; i++)
{
    var zz = instance_find(oCamZone, i);
    if (zz == noone) continue;

    if (is_callable(zz.update_rect)) zz.update_rect();

    if (point_in_rectangle(target.x, target.y, zz.left, zz.top, zz.right, zz.bottom)) {
        z = zz;
        break;
    }
}

// Choose a zone (player’s zone preferred, else first)
if (z == noone && instance_number(oCamZone) > 0) {
    z = instance_find(oCamZone, 0);
    if (instance_exists(z) && is_callable(z.update_rect)) z.update_rect();
}

// Place camera
if (instance_exists(z)) {

    active_zone = z;

    var vw = camera_get_view_width(cam);
    var vh = camera_get_view_height(cam);

    if (is_callable(active_zone.update_rect)) active_zone.update_rect();

    var zl = active_zone.left;
    var zt = active_zone.top;
    var zr = active_zone.right;
    var zb = active_zone.bottom;

    var tx, ty;

    if (zone_start_mode == "topleft") {
        tx = zl;
        ty = zt;
    } else { // "center"
        tx = zl + ((zr - zl) - vw) * 0.5;
        ty = zt + ((zb - zt) - vh) * 0.5;
    }

    tx = clamp(tx, zl, zr - vw);
    ty = clamp(ty, zt, zb - vh);

    camera_set_view_pos(cam, round(tx), round(ty));
}
else {
    // fallback: center on player
    var vw2 = camera_get_view_width(cam);
    var vh2 = camera_get_view_height(cam);

    var tx2 = clamp(round(target.x - vw2 * 0.5), 0, max(0, room_width  - vw2));
    var ty2 = clamp(round(target.y - vh2 * 0.5), 0, max(0, room_height - vh2));

    camera_set_view_pos(cam, tx2, ty2);
}

// Keep logical camera in sync with the initial placement
cam_logic_x = camera_get_view_x(cam);
cam_logic_y = camera_get_view_y(cam);

// Reset fade on room start
fade_state   = 0;
fade_alpha   = 0;
pending_zone = noone;
fade_hold    = 0;

// Optional: reset post-transition polish if those vars exist
if (variable_instance_exists(id, "post_fade_settle")) post_fade_settle = 0;
if (variable_instance_exists(id, "post_transition_air_lock")) post_transition_air_lock = 0;

// Reset look values so first step doesn't "jump"
if (variable_instance_exists(id, "prev_px")) prev_px = target.x;
if (variable_instance_exists(id, "lookahead_x")) lookahead_x = 0;
if (variable_instance_exists(id, "pan_bias")) pan_bias = 0;

if (variable_instance_exists(id, "debug_cam") && debug_cam) {
    show_debug_message("CAM ROOM START: zone=" + string(active_zone) +
                       " cam=(" + string(cam_logic_x) + "," + string(cam_logic_y) + ")");
}
