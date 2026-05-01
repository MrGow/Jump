/// oCamera - Room Start (unified/final)

view_index = 0;
cam = view_camera[view_index];
camera_set_view_size(cam, 640, 360);
visible = true;

// -------- safety defaults --------
if (!variable_instance_exists(id, "zone_start_mode")) zone_start_mode = "center";

if (!variable_instance_exists(id, "fade_state"))   fade_state = 0;
if (!variable_instance_exists(id, "fade_alpha"))   fade_alpha = 0;
if (!variable_instance_exists(id, "pending_zone")) pending_zone = noone;
if (!variable_instance_exists(id, "fade_hold_timer")) fade_hold_timer = 0;

if (!variable_instance_exists(id, "fade_speed_out")) fade_speed_out = 0.12;
if (!variable_instance_exists(id, "fade_speed_in"))  fade_speed_in  = 0.06;
if (!variable_instance_exists(id, "fade_speed"))     fade_speed     = fade_speed_out;

if (!variable_instance_exists(id, "fade_hold_frames")) fade_hold_frames = 14;

if (!variable_instance_exists(id, "post_fade_settle_frames")) post_fade_settle_frames = 10;
if (!variable_instance_exists(id, "settle_frames")) settle_frames = post_fade_settle_frames;
if (!variable_instance_exists(id, "post_fade_settle")) post_fade_settle = 0;

if (!variable_instance_exists(id, "transition_guard_max")) transition_guard_max = 3;
if (!variable_instance_exists(id, "zone_transition_lock_frames")) zone_transition_lock_frames = transition_guard_max;
if (!variable_instance_exists(id, "transition_guard")) transition_guard = 0;

if (!variable_instance_exists(id, "cam_logic_x")) cam_logic_x = camera_get_view_x(cam);
if (!variable_instance_exists(id, "cam_logic_y")) cam_logic_y = camera_get_view_y(cam);

// Resolve target
if (!instance_exists(target)) {
    var p = instance_find(target_obj, 0);
    if (p != noone) target = p;
}
if (!instance_exists(target)) exit;

// Ensure all zones have fresh rects now
with (oCamZone) {
    if (is_callable(update_rect)) update_rect();
}

// Find zone containing target
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

// Fallback to first zone if none contained target
if (z == noone && instance_number(oCamZone) > 0) {
    z = instance_find(oCamZone, 0);
    if (instance_exists(z) && is_callable(z.update_rect)) z.update_rect();
}

// Place camera
if (instance_exists(z))
{
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
    } else {
        tx = zl + ((zr - zl) - vw) * 0.5;
        ty = zt + ((zb - zt) - vh) * 0.5;
    }

    tx = clamp(tx, zl, zr - vw);
    ty = clamp(ty, zt, zb - vh);

    // Also clamp to room (safety)
    tx = clamp(tx, 0, max(0, room_width  - vw));
    ty = clamp(ty, 0, max(0, room_height - vh));

    camera_set_view_pos(cam, round(tx), round(ty));
}
else
{
    // Fallback center on target
    var vw2 = camera_get_view_width(cam);
    var vh2 = camera_get_view_height(cam);

    var tx2 = clamp(round(target.x - vw2 * 0.5), 0, max(0, room_width  - vw2));
    var ty2 = clamp(round((target.y + y_bias) - vh2 * 0.5), 0, max(0, room_height - vh2));

    camera_set_view_pos(cam, tx2, ty2);
}

cam_logic_x = camera_get_view_x(cam);
cam_logic_y = camera_get_view_y(cam);

pending_zone = noone;