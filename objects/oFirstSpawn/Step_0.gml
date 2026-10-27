/// oFirstSpawn — Step
// One-time setup. The player's normal Step handles the entire fall.

if (state != "waiting") exit;

player_ref = instance_find(oPlayer, 0);
camera_ref = instance_find(oCamera, 0);
if (!instance_exists(player_ref) || !instance_exists(camera_ref)) exit;

started = true;
state = "empty_hold";
hold_tick = 0;

old_trail_enabled = player_ref.jump_trail_enabled;
player_ref.first_spawn_locked = true;
player_ref.jump_trail_enabled = false;
player_ref.jump_trail_points = [];
player_ref.jump_charging = false;
player_ref.jump_charge = 0;
player_ref.bounce_pending = false;
player_ref.bounce_timer = 0;
player_ref.prev_on_ground = false;
player_ref.standing_platform = noone;
player_ref.hsp = 0;
player_ref.vsp = 0;
player_ref.x = landing_x + fall_offset_x;
player_ref.y = landing_y - fall_height;

// Select zone at landing location, never at the airborne location.
var n = instance_number(oCamZone);
for (var i = 0; i < n; i++)
{
    var z = instance_find(oCamZone, i);
    if (!instance_exists(z)) continue;
    if (is_callable(z.update_rect)) z.update_rect();
    if (point_in_rectangle(landing_x, landing_y,
        z.left, z.top, z.right, z.bottom))
    {
        opening_zone = z;
        break;
    }
}

camera_ref.active_zone = opening_zone;
camera_ref.pending_zone = noone;
camera_ref.fade_state = 0;
camera_ref.fade_alpha = 0;
camera_ref.transition_guard = 0;
camera_ref.post_fade_settle = 0;

old_camera_locked = camera_ref.arena_lock_active;
var vw = camera_get_view_width(camera_ref.cam);
var vh = camera_get_view_height(camera_ref.cam);
var tx = clamp(landing_x - vw * 0.5 + camera_offset_x,
    0, max(0, room_width - vw));
var ty = clamp(landing_y - vh * 0.5 + camera_offset_y,
    0, max(0, room_height - vh));
if (instance_exists(opening_zone))
{
    tx = clamp(tx, opening_zone.left,
        max(opening_zone.left, opening_zone.right - vw));
    ty = clamp(ty, opening_zone.top,
        max(opening_zone.top, opening_zone.bottom - vh));
}
camera_ref.arena_lock_active = true;
camera_ref.arena_lock_x = round(tx);
camera_ref.arena_lock_y = round(ty);
camera_ref.cam_logic_x = round(tx);
camera_ref.cam_logic_y = round(ty);
camera_set_view_pos(camera_ref.cam, round(tx), round(ty));
