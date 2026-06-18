/// oPlayer — Step
// FULL EVENT — gravity zones added

if (mask_index != spriteBotMask) mask_index = spriteBotMask;
if (!variable_instance_exists(id,"bird")) bird = noone;

// ---------- Hot-reload safety ----------
if (!variable_instance_exists(id,"hsp")) hsp = 0;
if (!variable_instance_exists(id,"vsp")) vsp = 0;
if (!variable_instance_exists(id,"gravity_amt")) gravity_amt = 0.25;
if (!variable_instance_exists(id,"max_fall")) max_fall = 8.0;

if (!variable_instance_exists(id,"jump_v_base")) jump_v_base = -4.0;
if (!variable_instance_exists(id,"jump_h_base")) jump_h_base = 4.0;

if (!variable_instance_exists(id,"low_jump_multiplier")) low_jump_multiplier = 1.7;
if (!variable_instance_exists(id,"fall_multiplier")) fall_multiplier = 1.4;

if (!variable_instance_exists(id,"jump_charge_frame_steps")) jump_charge_frame_steps = 6;
if (!variable_instance_exists(id,"jump_charge")) jump_charge = 0;
if (!variable_instance_exists(id,"jump_charge_level")) jump_charge_level = 0;
if (!variable_instance_exists(id,"jump_charging")) jump_charging = false;
if (!variable_instance_exists(id,"prev_jump_h")) prev_jump_h = false;

if (!variable_instance_exists(id,"jump_pose_min_frames")) jump_pose_min_frames = 6;
if (!variable_instance_exists(id,"jump_pose_timer"))      jump_pose_timer = 0;
if (!variable_instance_exists(id,"jump_anim_speed"))      jump_anim_speed = 0.35;

if (!variable_instance_exists(id,"charge_support_min")) charge_support_min = 1;
if (!variable_instance_exists(id,"charge_grace_max")) charge_grace_max = 5;
if (!variable_instance_exists(id,"charge_grace")) charge_grace = 0;
if (!variable_instance_exists(id,"charge_start_lock_max")) charge_start_lock_max = 2;
if (!variable_instance_exists(id,"charge_start_lock")) charge_start_lock = 0;

if (!variable_instance_exists(id,"soft_landing_bounce_enabled")) soft_landing_bounce_enabled = true;
if (!variable_instance_exists(id,"soft_landing_bounce_v"))       soft_landing_bounce_v = -1.0;
if (!variable_instance_exists(id,"soft_landing_min_air_frames")) soft_landing_min_air_frames = 6;
if (!variable_instance_exists(id,"airborne_frames"))             airborne_frames = 0;

if (!variable_instance_exists(id,"in_low_gravity_zone"))  in_low_gravity_zone = false;
if (!variable_instance_exists(id,"in_high_gravity_zone")) in_high_gravity_zone = false;
if (!variable_instance_exists(id,"low_grav_mult_zone"))   low_grav_mult_zone = 1.0;
if (!variable_instance_exists(id,"low_fall_mult_zone"))   low_fall_mult_zone = 1.0;
if (!variable_instance_exists(id,"high_grav_mult_zone"))  high_grav_mult_zone = 1.0;
if (!variable_instance_exists(id,"high_fall_mult_zone"))  high_fall_mult_zone = 1.0;

if (!variable_instance_exists(id,"prev_on_ground")) prev_on_ground = false;
if (!variable_instance_exists(id,"support_stable_frames")) support_stable_frames = 0;
if (!variable_instance_exists(id,"support_stable_needed")) support_stable_needed = 1;

if (!variable_instance_exists(id,"facing")) facing = 1;
if (!variable_instance_exists(id,"state")) state = "idle";
if (!variable_instance_exists(id,"death_fall")) death_fall = false;

if (!variable_instance_exists(id,"support_grace_max")) support_grace_max = 2;
if (!variable_instance_exists(id,"support_grace")) support_grace = 0;

if (!variable_instance_exists(id,"edge_charge_fail_max")) edge_charge_fail_max = 2;
if (!variable_instance_exists(id,"edge_charge_fail")) edge_charge_fail = 0;

if (!variable_instance_exists(id,"bounce_enabled")) bounce_enabled = true;
if (!variable_instance_exists(id,"bounce_threshold")) bounce_threshold = 2.0;
if (!variable_instance_exists(id,"bounce_mult")) bounce_mult = 0.950;
if (!variable_instance_exists(id,"bounce_min")) bounce_min = 2.6;
if (!variable_instance_exists(id,"bounce_max")) bounce_max = 7.0;
if (!variable_instance_exists(id,"bounce_pause_frames")) bounce_pause_frames = 1;
if (!variable_instance_exists(id,"bounce_h_damp")) bounce_h_damp = 0.65;
if (!variable_instance_exists(id,"bounce_pending")) bounce_pending = false;
if (!variable_instance_exists(id,"bounce_timer")) bounce_timer = 0;
if (!variable_instance_exists(id,"bounce_v")) bounce_v = 0;

// Conveyor bounce influence
if (!variable_instance_exists(id,"conveyor_grip_timer"))  conveyor_grip_timer = 0;
if (!variable_instance_exists(id,"conveyor_grip_max"))    conveyor_grip_max   = 10;
if (!variable_instance_exists(id,"conveyor_grip_speed"))  conveyor_grip_speed = 0;
if (!variable_instance_exists(id,"conveyor_grip"))        conveyor_grip       = 0.18;
if (!variable_instance_exists(id,"conveyor_ground_grip")) conveyor_ground_grip = 0.35;

if (!variable_instance_exists(id,"wallhit_enabled")) wallhit_enabled = true;
if (!variable_instance_exists(id,"wallhit_threshold")) wallhit_threshold = 3.5;
if (!variable_instance_exists(id,"wallhit_cooldown_frames")) wallhit_cooldown_frames = 10;
if (!variable_instance_exists(id,"wallhit_cd")) wallhit_cd = 0;
if (!variable_instance_exists(id,"wallhit_hold_seconds")) wallhit_hold_seconds = 0.40;
if (!variable_instance_exists(id,"wallhit_timer")) wallhit_timer = 0;

if (!variable_instance_exists(id,"wallbounce_enabled")) wallbounce_enabled = true;
if (!variable_instance_exists(id,"wallbounce_threshold")) wallbounce_threshold = 2.8;
if (!variable_instance_exists(id,"wallbounce_mult")) wallbounce_mult = 0.60;
if (!variable_instance_exists(id,"wallbounce_min_h")) wallbounce_min_h = 1.5;
if (!variable_instance_exists(id,"wallbounce_upkick")) wallbounce_upkick = 0.15;
if (!variable_instance_exists(id,"wallbounce_cd_frames")) wallbounce_cd_frames = 3;
if (!variable_instance_exists(id,"wallbounce_cd")) wallbounce_cd = 0;

if (!variable_instance_exists(id,"ground_probe_inset")) ground_probe_inset = 10;
if (!variable_instance_exists(id,"vertical_probe_inset")) vertical_probe_inset = 3;
if (!variable_instance_exists(id,"side_probe_top_margin")) side_probe_top_margin = 10;
if (!variable_instance_exists(id,"side_probe_bottom_margin")) side_probe_bottom_margin = 6;

if (!variable_instance_exists(id,"standing_platform")) standing_platform = noone;
if (!variable_instance_exists(id,"standing_platform_xoff")) standing_platform_xoff = 0;
if (!variable_instance_exists(id,"platform_stick_timer")) platform_stick_timer = 0;

if (!variable_instance_exists(id,"ground_snap_max")) ground_snap_max = 6;
if (!variable_instance_exists(id,"ground_min_overlap")) ground_min_overlap = 6;
if (!variable_instance_exists(id,"ground_attach_max")) ground_attach_max = 2;
if (!variable_instance_exists(id,"coyote_max")) coyote_max = 5;
if (!variable_instance_exists(id,"coyote_timer")) coyote_timer = 0;
if (!variable_instance_exists(id,"respawn_input_lock")) respawn_input_lock = 0;

// Shadow hot-reload safety
if (!variable_instance_exists(id,"shadow_enabled"))       shadow_enabled = true;
if (!variable_instance_exists(id,"shadow_max_dist"))      shadow_max_dist = 56;
if (!variable_instance_exists(id,"shadow_ground_dist"))   shadow_ground_dist = -1;
if (!variable_instance_exists(id,"shadow_support_ratio")) shadow_support_ratio = 1;
if (!variable_instance_exists(id,"shadow_support_cx"))    shadow_support_cx = x;
if (!variable_instance_exists(id,"shadow_support_left"))  shadow_support_left = x - 8;
if (!variable_instance_exists(id,"shadow_support_right")) shadow_support_right = x + 8;

// Trail hot-reload safety
if (!variable_instance_exists(id,"jump_trail_enabled"))     jump_trail_enabled = true;
if (!variable_instance_exists(id,"jump_trail_max_points"))  jump_trail_max_points = 7;
if (!variable_instance_exists(id,"jump_trail_spacing"))     jump_trail_spacing = 1;
if (!variable_instance_exists(id,"jump_trail_timer"))       jump_trail_timer = 0;
if (!variable_instance_exists(id,"jump_trail_points"))      jump_trail_points = array_create(jump_trail_max_points);
if (!variable_instance_exists(id,"jump_trail_alpha"))       jump_trail_alpha = 0.32;
if (!variable_instance_exists(id,"jump_trail_size_start"))  jump_trail_size_start = 1.00;
if (!variable_instance_exists(id,"jump_trail_size_end"))    jump_trail_size_end = 0.45;
if (!variable_instance_exists(id,"jump_trail_y_lift"))      jump_trail_y_lift = -12;
if (!variable_instance_exists(id,"jump_trail_sprite"))      jump_trail_sprite = asset_get_index("spriteJumpArc");

// ----------------------------------------------------
// Blocking solid helpers
// ----------------------------------------------------

if (!variable_global_exists("tm_solids")) global.tm_solids = undefined;
if (!variable_global_exists("tm_solids_room")) global.tm_solids_room = -1;

function ensure_tm_solids()
{
    if (global.tm_solids_room != room) {
        global.tm_solids = undefined;
        global.tm_solids_room = room;
    }

    if (!is_undefined(global.tm_solids) && global.tm_solids != -1) return global.tm_solids;

    var lid = layer_get_id("Solids");
    if (lid == -1) { global.tm_solids = undefined; return undefined; }

    var tm = layer_tilemap_get_id(lid);
    if (tm == -1) { global.tm_solids = undefined; return undefined; }

    global.tm_solids = tm;
    return tm;
}

function tile_any_solid_at(_x, _y)
{
    if (asset_get_index("oSolidDyn") != -1) {
        if (instance_position(_x, _y, oSolidDyn) != noone) return true;
    }

    var obj_spinner = asset_get_index("oSpinnerPlatform");
    if (obj_spinner != -1)
    {
        var sp = instance_position(_x, _y, oSpinnerPlatform);

        if (sp != noone)
        {
            var sp_enabled = (!variable_instance_exists(sp, "enabled") || sp.enabled);
            var sp_active  = (!variable_instance_exists(sp, "active")  || sp.active);

            if (sp_enabled && sp_active)
            {
                if (variable_instance_exists(sp, "solid_body") && sp.solid_body)
                {
                    return true;
                }
            }
        }
    }

    var obj_break = asset_get_index("oBreakingPlatform");
    if (obj_break != -1)
    {
        var bp = instance_position(_x, _y, oBreakingPlatform);

        if (bp != noone)
        {
            var bp_enabled = (!variable_instance_exists(bp, "enabled") || bp.enabled);
            var bp_active  = (!variable_instance_exists(bp, "active")  || bp.active);

            if (bp_enabled && bp_active)
            {
                if (variable_instance_exists(bp, "solid_body") && bp.solid_body)
                {
                    return true;
                }
            }
        }
    }

    if (asset_get_index("oHazard") != -1) {
        var hz = instance_position(_x, _y, oHazard);

        if (hz != noone)
        {
            if (!variable_instance_exists(hz, "enabled") || hz.enabled)
            {
                if (variable_instance_exists(hz, "solid_body") && hz.solid_body)
                {
                    var only_active =
                        (variable_instance_exists(hz, "solid_only_when_active")
                         && hz.solid_only_when_active);

                    if (!only_active) return true;
                    else if (variable_instance_exists(hz, "active") && hz.active) return true;
                }
            }
        }
    }

    ensure_tm_solids();

    if (is_undefined(global.tm_solids) || global.tm_solids == -1)
        return false;

    return (tilemap_get_at_pixel(global.tm_solids, _x, _y) != 0);
}

function rect_hits_solid_h(_dx)
{
    var l = bbox_left  + _dx;
    var r = bbox_right + _dx;
    var t = bbox_top;
    var b = bbox_bottom;

    var e = 0.1;
    var step_v = 3;

    var probe_x;
    if (_dx < 0) probe_x = l + e;
    else         probe_x = r - e;

    var yy0 = t + side_probe_top_margin;
    var yy1 = b - side_probe_bottom_margin;

    if (yy1 < yy0) {
        yy0 = t + e;
        yy1 = b - e;
    }

    var yy = yy0;
    while (yy <= yy1 + 0.0001)
    {
        if (tile_any_solid_at(probe_x, yy)) return true;
        yy += step_v;
    }

    if (tile_any_solid_at(probe_x, t + 1)) return true;
    if (tile_any_solid_at(probe_x, t + 3)) return true;
    if (tile_any_solid_at(probe_x, t + 5)) return true;

    if (tile_any_solid_at(probe_x, b - 5)) return true;
    if (tile_any_solid_at(probe_x, b - 3)) return true;
    if (tile_any_solid_at(probe_x, b - 1)) return true;

    var foot_y = b - 0.5;
    if (tile_any_solid_at(probe_x, foot_y)) return true;

    return false;
}

function rect_hits_solid_v(_dy)
{
    var l = bbox_left;
    var r = bbox_right;
    var t = bbox_top + _dy;
    var b = bbox_bottom + _dy;

    var e = 0.1;
    var step_h = 4;

    var inset = vertical_probe_inset;
    var xl = l + inset;
    var xr = r - inset;

    if (xl > xr) {
        xl = (l + r) * 0.5;
        xr = xl;
    }

    var xx = xl;
    while (xx <= xr + 0.0001) {
        if (_dy < 0) {
            if (tile_any_solid_at(xx, t + e)) return true;
        } else if (_dy > 0) {
            if (tile_any_solid_at(xx, b - e)) return true;
        }
        xx += step_h;
    }

    if (_dy > 0) {
        var ex1 = l + 1;
        var ex2 = l + 3;
        var ex3 = r - 3;
        var ex4 = r - 1;

        if (tile_any_solid_at(ex1, b - e)) return true;
        if (tile_any_solid_at(ex2, b - e)) return true;
        if (tile_any_solid_at(ex3, b - e)) return true;
        if (tile_any_solid_at(ex4, b - e)) return true;
    }

    return false;
}

function rect_hits_solid(_dx, _dy)
{
    if (_dx != 0 && _dy == 0) return rect_hits_solid_h(_dx);
    if (_dy != 0 && _dx == 0) return rect_hits_solid_v(_dy);

    var l = bbox_left   + _dx;
    var r = bbox_right  + _dx;
    var t = bbox_top    + _dy;
    var b = bbox_bottom + _dy;

    var e = 0.1;
    var step_v = 4;
    var step_h = 4;

    var yy = t + e;
    while (yy <= b - e + 0.0001) {
        if (tile_any_solid_at(l + e, yy)) return true;
        if (tile_any_solid_at(r - e, yy)) return true;
        yy += step_v;
    }

    if (tile_any_solid_at(l + e, b - e)) return true;
    if (tile_any_solid_at(r - e, b - e)) return true;

    var xx = l + e;
    while (xx <= r - e + 0.0001) {
        if (tile_any_solid_at(xx, t + e)) return true;
        if (tile_any_solid_at(xx, b - e)) return true;
        xx += step_h;
    }

    if (tile_any_solid_at(r - e, t + e)) return true;
    if (tile_any_solid_at(r - e, b - e)) return true;

    return false;
}

// ----------------------------------------------------
// Floor-surface helpers
// ----------------------------------------------------

function __find_floor_surface(_max_snap)
{
    var best_inst = noone;
    var best_dy   = 999999;

    var x1 = bbox_left;
    var y1 = bbox_bottom - 4;
    var x2 = bbox_right;
    var y2 = bbox_bottom + _max_snap + 4;

    var list = ds_list_create();

    var objs = [
        asset_get_index("oFloorSurface"),
        asset_get_index("oMovingPlatform"),
        asset_get_index("oSpringPlatform"),
        asset_get_index("oSpringPlatformBig"),
        asset_get_index("oBreakingPlatform"),
        asset_get_index("oSpinnerPlatform"),
        asset_get_index("oConveyorLeft"),
        asset_get_index("oConveyorRight")
    ];

    for (var oi = 0; oi < array_length(objs); oi++)
    {
        var obj = objs[oi];
        if (obj == -1) continue;

        ds_list_clear(list);
        var n = collision_rectangle_list(x1, y1, x2, y2, obj, false, true, list, false);

        for (var i = 0; i < n; i++)
        {
            var inst = list[| i];
            if (!instance_exists(inst)) continue;

            if (variable_instance_exists(inst, "enabled") && !inst.enabled) continue;
            if (variable_instance_exists(inst, "active")  && !inst.active)  continue;

            var left  = inst.bbox_left;
            var right = inst.bbox_right;
            var top   = inst.bbox_top;

            if (variable_instance_exists(inst, "surface_inset_left"))  left  += inst.surface_inset_left;
            if (variable_instance_exists(inst, "surface_inset_right")) right -= inst.surface_inset_right;
            if (variable_instance_exists(inst, "surface_y"))           top    = inst.surface_y;

            var overlap = min(bbox_right, right) - max(bbox_left, left);
            if (overlap < ground_min_overlap) continue;

            var dy = top - bbox_bottom;
            if (dy < -2) continue;
            if (dy > _max_snap) continue;

            if (dy < best_dy) {
                best_dy   = dy;
                best_inst = inst;
            }
        }
    }

    ds_list_destroy(list);
    return [best_inst, best_dy];
}

function __resolve_embed_up(_max_push)
{
    if (is_undefined(_max_push)) _max_push = 6;

    if (!rect_hits_solid(0, 0)) return false;

    for (var i = 1; i <= _max_push; i++) {
        if (!rect_hits_solid(0, -i)) {
            y -= i;
            return true;
        }
    }

    return false;
}

// ---------- SPRITE HELPERS ----------
function __spr(_name) {
    var s = asset_get_index(_name);
    return (s != -1) ? s : -1;
}

function __unstick_from_wall()
{
    if (!rect_hits_solid(0,0)) return;

    for (var i = 1; i <= 6; i++) {
        if (!rect_hits_solid(-i,0)) { x -= i; return; }
        if (!rect_hits_solid( i,0)) { x += i; return; }
    }
}

function __set_sprite_keep_feet_once(_spr, _speed)
{
    if (_spr == -1) return;

    if (sprite_index == _spr) {
        if (!is_undefined(_speed)) image_speed = _speed;
        return;
    }

    var cur_yoff = sprite_get_yoffset(sprite_index);
    var cur_bot  = sprite_get_bbox_bottom(sprite_index);
    var feet_y   = y - cur_yoff + cur_bot;

    sprite_index = _spr;
    image_index  = 0;
    if (!is_undefined(_speed)) image_speed = _speed;

    var new_yoff = sprite_get_yoffset(sprite_index);
    var new_bot  = sprite_get_bbox_bottom(sprite_index);
    y = feet_y - (new_bot - new_yoff);

    __unstick_from_wall();
}

function __zone_bbox_overlap(_inst)
{
    return
        (bbox_right  > _inst.bbox_left) &&
        (bbox_left   < _inst.bbox_right) &&
        (bbox_bottom > _inst.bbox_top) &&
        (bbox_top    < _inst.bbox_bottom);
}

// Sprites
var sprIdle     = __spr("spriteBotIdle");
var sprCharge   = __spr("spriteBotJumpCharge");
var sprJumping  = __spr("spriteBotJumping");
var sprGlide    = __spr("spriteBotGliding");
var sprLanding  = __spr("spriteBotLanding");
var sprDeath    = __spr("spriteBotDeath");

ensure_tm_solids();

// ----------------------------------------------------
// DEAD
// ----------------------------------------------------
if (state == "dead")
{
    hsp = 0;

    if (!death_fall)
    {
        vsp = 0;
    }
    else
    {
        var g_dead = gravity_amt;
        vsp += g_dead;
        if (vsp > max_fall) vsp = max_fall;

        if (vsp < 0) {
            var syu = sign(vsp);
            var myu = abs(vsp);

            repeat (floor(myu)) {
                if (!rect_hits_solid(0, syu)) y += syu;
                else { vsp = 0; break; }
            }
        }
        else if (vsp > 0) {
            y += vsp;
        }
    }

    if (sprDeath != -1 && sprite_index == sprDeath)
    {
        var last = image_number - 1;
        if (image_index >= last)
        {
            image_index = last;
            image_speed = 1;
        }
    }

    return;
}

// ---------- Apply standing surface carry ----------
if (instance_exists(standing_platform))
{
    var _sdx = variable_instance_exists(standing_platform, "dx") ? standing_platform.dx : 0;
    var _sdy = variable_instance_exists(standing_platform, "dy") ? standing_platform.dy : 0;

    var _can_anchor = variable_instance_exists(standing_platform, "x");

    if (jump_charging)
    {
        if (_can_anchor && abs(_sdx) <= 0.0001) {
            x = standing_platform.x + standing_platform_xoff;
        }
        else {
            x += _sdx;
        }

        y += _sdy;
        hsp = 0;
    }
    else
    {
        x += _sdx;
        y += _sdy;
    }
}
else
{
    standing_platform = noone;
}

// ---------- INPUT ----------
var left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var right = keyboard_check(vk_right) || keyboard_check(ord("D"));

var jump_h = keyboard_check(vk_space) || keyboard_check(vk_up);
if (variable_global_exists("inp_jump_held")) jump_h = global.inp_jump_held;

if (variable_global_exists("menu_demo_active") && global.menu_demo_active)
{
    left   = variable_global_exists("menu_demo_left")  ? global.menu_demo_left  : false;
    right  = variable_global_exists("menu_demo_right") ? global.menu_demo_right : false;
    jump_h = variable_global_exists("menu_demo_jump_held") ? global.menu_demo_jump_held : false;
}

var dir_input = (right ? 1 : 0) - (left ? 1 : 0);

if (!(variable_global_exists("menu_demo_active") && global.menu_demo_active))
{
    if (variable_global_exists("inp_move")) {
        if (abs(global.inp_move) > 0.3) dir_input = sign(global.inp_move);
    }
}

if (respawn_input_lock > 0) {
    respawn_input_lock--;
    jump_h = false;
}

var jump_p = (jump_h && !prev_jump_h);
var jump_r = (!jump_h && prev_jump_h);

if (dir_input != 0) facing = (dir_input > 0) ? 1 : -1;

if (wallhit_cd > 0) wallhit_cd--;
if (wallbounce_cd > 0) wallbounce_cd--;
if (wallhit_timer > 0) wallhit_timer--;
if (charge_start_lock > 0) charge_start_lock--;

// ---------- Grounded-at-start test ----------
var surf_start = __find_floor_surface(ground_attach_max);
var feet_ground_start = (surf_start[0] != noone && surf_start[1] <= ground_attach_max && vsp >= 0);

if (feet_ground_start) {
    standing_platform = surf_start[0];

    if (variable_instance_exists(standing_platform, "x")) {
        standing_platform_xoff = x - standing_platform.x;
    }
}
else {
    if (coyote_timer <= 0 && !jump_charging) standing_platform = noone;
}

if (feet_ground_start) {
    coyote_timer = coyote_max;
    support_stable_frames++;
    support_grace = support_grace_max;
    charge_grace = charge_grace_max;
}
else {
    if (coyote_timer > 0) coyote_timer--;
    support_stable_frames = 0;
    if (support_grace > 0) support_grace--;
    if (charge_grace > 0) charge_grace--;
}

var grounded_for_state_start = feet_ground_start;
if (grounded_for_state_start && vsp > 0) vsp = 0;

var max_charge_level = (sprCharge != -1) ? max(0, sprite_get_number(sprCharge) - 1) : 3;

// ---------- APPLY PENDING LANDING BOUNCE ----------
if (bounce_pending) {
    bounce_timer--;

    if (bounce_timer <= 0) {
        bounce_pending = false;

        vsp = bounce_v;
        state = "jumping";
        jump_pose_timer = jump_pose_min_frames;
        __set_sprite_keep_feet_once(sprJumping, jump_anim_speed);
        image_index = 0;

        charge_grace = 0;
        charge_start_lock = 0;
        support_grace = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;

        standing_platform = noone;
        feet_ground_start = false;
    }
}

// ---------- CHARGE LOGIC ----------
var can_start_charge =
    feet_ground_start &&
    (support_stable_frames >= support_stable_needed) &&
    (abs(vsp) < 0.25) &&
    !bounce_pending &&
    (state != "landing");

var can_continue_charge =
    (charge_start_lock > 0) ||
    (feet_ground_start || charge_grace > 0 || support_grace > 0);

if (!jump_charging)
{
    if (jump_p && can_start_charge) {
        jump_charging     = true;
        jump_charge       = 0;
        jump_charge_level = 0;
        state             = "jump_charge";
        charge_start_lock = charge_start_lock_max;
        edge_charge_fail  = 0;
    }
}
else
{
    if (jump_h) {
        jump_charge += 1;
        var steps_per_frame = max(1, jump_charge_frame_steps);
        jump_charge_level = clamp(floor(jump_charge / steps_per_frame), 0, max_charge_level);
    }

    if (jump_r) {
        var mult = 1.0 + (0.25 * jump_charge_level);

        vsp = jump_v_base * mult;
        hsp = jump_h_base * mult * facing;

        conveyor_grip_timer = 0;
        conveyor_grip_speed = 0;

        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;

        state = "jumping";
        jump_pose_timer = jump_pose_min_frames;
        __set_sprite_keep_feet_once(sprJumping, jump_anim_speed);
        image_index = 0;

        charge_grace = 0;
        charge_start_lock = 0;
        support_grace = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;

        standing_platform = noone;
        feet_ground_start = false;
        coyote_timer = 0;
    }
    else if (!jump_h || !can_continue_charge) {
        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;
        charge_start_lock = 0;
        support_grace = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;

        if (state == "jump_charge") {
            state = feet_ground_start ? "idle" : "glide";
        }
    }
}

// ---------- Ground friction / air drag ----------
if (feet_ground_start && !jump_charging && !bounce_pending &&
    state != "jumping" && state != "glide") {
    hsp = 0;
}
else if (!feet_ground_start) {
    hsp *= 0.995;
}

// ----------------------------------------------------
// Gravity zone check
// Low gravity = smaller multipliers.
// High gravity = larger multipliers.
// High gravity overrides low gravity if both overlap.
// ----------------------------------------------------
in_low_gravity_zone  = false;
in_high_gravity_zone = false;

low_grav_mult_zone  = 1.0;
low_fall_mult_zone  = 1.0;
high_grav_mult_zone = 1.0;
high_fall_mult_zone = 1.0;

var grav_zone_active = false;
var grav_rise_mult   = 1.0;
var grav_fall_mult   = 1.0;

var obj_lowgrav = asset_get_index("oLowGravityZone");
if (obj_lowgrav != -1)
{
    var low_count = instance_number(oLowGravityZone);

    for (var lg = 0; lg < low_count; lg++)
    {
        var lz = instance_find(oLowGravityZone, lg);
        if (lz == noone) continue;
        if (variable_instance_exists(lz, "enabled") && !lz.enabled) continue;

        if (__zone_bbox_overlap(lz))
        {
            in_low_gravity_zone = true;

            low_grav_mult_zone = variable_instance_exists(lz, "low_grav_mult") ? lz.low_grav_mult : 0.45;
            low_fall_mult_zone = variable_instance_exists(lz, "low_fall_mult") ? lz.low_fall_mult : 0.55;

            grav_zone_active = true;
            grav_rise_mult   = low_grav_mult_zone;
            grav_fall_mult   = low_fall_mult_zone;
        }
    }
}

var obj_highgrav = asset_get_index("oHighGravityZone");
if (obj_highgrav != -1)
{
    var high_count = instance_number(oHighGravityZone);

    for (var hg = 0; hg < high_count; hg++)
    {
        var hz = instance_find(oHighGravityZone, hg);
        if (hz == noone) continue;
        if (variable_instance_exists(hz, "enabled") && !hz.enabled) continue;

        if (__zone_bbox_overlap(hz))
        {
            in_high_gravity_zone = true;

            high_grav_mult_zone = variable_instance_exists(hz, "high_grav_mult") ? hz.high_grav_mult : 1.75;
            high_fall_mult_zone = variable_instance_exists(hz, "high_fall_mult") ? hz.high_fall_mult : 1.5;

            grav_zone_active = true;
            grav_rise_mult   = high_grav_mult_zone;
            grav_fall_mult   = high_fall_mult_zone;
        }
    }
}

// ---------- GRAVITY ----------
var g = gravity_amt;

if (!feet_ground_start)
{
    if (vsp < 0)
    {
        if (!jump_h) g += gravity_amt * (low_jump_multiplier - 1.0);

        if (grav_zone_active)
        {
            g *= grav_rise_mult;
        }
    }
    else
    {
        g += gravity_amt * (fall_multiplier - 1.0);

        if (grav_zone_active)
        {
            g *= grav_fall_mult;
        }
    }
}

vsp += g;
if (vsp > max_fall) vsp = max_fall;

// ---------- COLLISIONS H ----------
var hit_wall    = false;
var wall_dir    = 0;
var wall_impact = 0;
var hsp_attempt = hsp;

if (hsp != 0) {
    var sx = sign(hsp);
    var mx = abs(hsp);

    repeat (floor(mx)) {
        if (!rect_hits_solid(sx, 0)) x += sx;
        else { hit_wall = true; wall_dir = sx; break; }
    }

    var fx = mx - floor(mx);
    if (!hit_wall && fx > 0) {
        if (!rect_hits_solid(sx * fx, 0)) x += sx * fx;
        else { hit_wall = true; wall_dir = sx; }
    }
}

if (hit_wall) {
    wall_impact = abs(hsp_attempt);

    var airborne_for_bounce = !feet_ground_start && (coyote_timer <= 0);

    if (wallbounce_enabled && airborne_for_bounce &&
        wall_impact >= wallbounce_threshold &&
        wallbounce_cd <= 0)
    {
        wallbounce_cd = wallbounce_cd_frames;

        var nb = -hsp_attempt * wallbounce_mult;

        if (abs(nb) < wallbounce_min_h) {
            nb = wallbounce_min_h * sign(nb == 0 ? -wall_dir : nb);
        }

        hsp = nb;

        if (wallbounce_upkick > 0) vsp = min(vsp, 0) - wallbounce_upkick;
        if (hsp != 0) facing = (hsp > 0) ? 1 : -1;
    }
    else {
        hsp = 0;
    }

    if (wallhit_enabled && wall_impact >= wallhit_threshold && wallhit_cd <= 0) {
        wallhit_cd = wallhit_cooldown_frames;
        wallhit_timer = ceil(room_speed * wallhit_hold_seconds);
    }
}

// ---------- COLLISIONS V ----------
var vsp_before_vcollide = vsp;
var landed_surface = noone;

if (vsp < 0)
{
    var sy_up = -1;
    var my_up = abs(vsp);

    repeat (floor(my_up)) {
        if (!rect_hits_solid(0, sy_up)) y += sy_up;
        else { vsp = 0; break; }
    }

    var fy_up = my_up - floor(my_up);
    if (fy_up > 0 && vsp < 0) {
        if (!rect_hits_solid(0, sy_up * fy_up)) y += sy_up * fy_up;
        else vsp = 0;
    }
}
else if (vsp > 0)
{
    var my_dn = abs(vsp);

    repeat (floor(my_dn)) {
        y += 1;

        var surf_step = __find_floor_surface(1);
        if (surf_step[0] != noone && surf_step[1] <= 0) {
            y += surf_step[1];
            landed_surface = surf_step[0];
            vsp = 0;
            break;
        }
    }

    var fy_dn = my_dn - floor(my_dn);
    if (fy_dn > 0 && landed_surface == noone) {
        y += fy_dn;

        var surf_frac = __find_floor_surface(1);
        if (surf_frac[0] != noone && surf_frac[1] <= 0) {
            y += surf_frac[1];
            landed_surface = surf_frac[0];
            vsp = 0;
        }
    }
}

// ---------- Ground after movement ----------
if (landed_surface == noone && vsp >= 0)
{
    var surf_snap = __find_floor_surface(ground_snap_max);

    if (surf_snap[0] != noone) {
        y += surf_snap[1];
        landed_surface = surf_snap[0];
        vsp = 0;
    }
}

var feet_ground = (landed_surface != noone);

if (!feet_ground)
{
    var surf_hold = __find_floor_surface(ground_attach_max);

    if (surf_hold[0] != noone && surf_hold[1] <= ground_attach_max && vsp >= 0) {
        feet_ground = true;
        landed_surface = surf_hold[0];
    }
}

if (feet_ground) {
    standing_platform = landed_surface;

    if (variable_instance_exists(standing_platform, "x")) {
        standing_platform_xoff = x - standing_platform.x;
    }

    coyote_timer = coyote_max;

    if (instance_exists(standing_platform) &&
        variable_instance_exists(standing_platform, "is_conveyor") &&
        standing_platform.is_conveyor)
    {
        conveyor_grip_timer = conveyor_grip_max;
        conveyor_grip_speed = variable_instance_exists(standing_platform, "belt_speed") ? standing_platform.belt_speed : 0;
    }
}
else {
    if (coyote_timer > 0) coyote_timer--;
    if (!jump_charging) standing_platform = noone;
}

var grounded_stable = feet_ground;
var just_landed = (!prev_on_ground && feet_ground);

// ---------- Conveyor grip / bounce pull ----------
if (conveyor_grip_timer > 0 && !jump_charging)
{
    var grip_amt = feet_ground ? conveyor_ground_grip : conveyor_grip;

    hsp = lerp(hsp, conveyor_grip_speed, grip_amt);

    conveyor_grip_timer--;
}
else if (conveyor_grip_timer > 0)
{
    conveyor_grip_timer--;
}

// ---------- LANDING TRIGGER + OPTIONAL BOUNCE ----------
if (just_landed) {
    state = "landing";
    jump_pose_timer = 0;
    __set_sprite_keep_feet_once(sprLanding, 0.4);

    var impact = max(0, vsp_before_vcollide);

    // Gravity zones should not cause endless bounce loops
    var in_grav_zone_now = in_low_gravity_zone || in_high_gravity_zone;

    if (bounce_enabled && impact >= bounce_threshold && !in_grav_zone_now) {
        bounce_v = -clamp(impact * bounce_mult, bounce_min, bounce_max);
        bounce_timer = max(0, bounce_pause_frames);
        bounce_pending = true;

        hsp *= bounce_h_damp;
    }
    else if (
        soft_landing_bounce_enabled &&
        airborne_frames >= soft_landing_min_air_frames &&
        abs(hsp) > 0.2 &&
        !in_grav_zone_now
    ) {
        bounce_v = soft_landing_bounce_v;
        bounce_timer = max(0, bounce_pause_frames);
        bounce_pending = true;

        hsp *= bounce_h_damp;
    }
    else {
        hsp = 0;
        vsp = 0;
    }
}

// ---------- Cleanup ----------
if (feet_ground && vsp > 0) vsp = 0;
if (feet_ground) __resolve_embed_up(6);

// ---------- Ground shadow cache ----------
if (shadow_enabled)
{
    shadow_ground_dist   = -1;
    shadow_support_ratio = 1;
    shadow_support_cx    = x;
    shadow_support_left  = bbox_left;
    shadow_support_right = bbox_right;

    var surf_shadow = __find_floor_surface(shadow_max_dist);

    if (surf_shadow[0] != noone)
    {
        var s_inst = surf_shadow[0];
        var s_dy   = surf_shadow[1];

        if (s_dy >= -2 && s_dy <= shadow_max_dist)
        {
            shadow_ground_dist = max(0, s_dy);

            var s_left  = s_inst.bbox_left;
            var s_right = s_inst.bbox_right;

            if (variable_instance_exists(s_inst, "surface_inset_left")) {
                s_left += s_inst.surface_inset_left;
            }
            if (variable_instance_exists(s_inst, "surface_inset_right")) {
                s_right -= s_inst.surface_inset_right;
            }

            var clip_l = max(bbox_left,  s_left);
            var clip_r = min(bbox_right, s_right);
            var clip_w = max(0, clip_r - clip_l);

            var player_w = max(1, bbox_right - bbox_left);

            shadow_support_ratio = clamp(clip_w / player_w, 0, 1);

            if (clip_w > 0) {
                shadow_support_cx    = (clip_l + clip_r) * 0.5;
                shadow_support_left  = clip_l;
                shadow_support_right = clip_r;
            }
            else {
                shadow_support_cx    = x;
                shadow_support_left  = x;
                shadow_support_right = x;
            }
        }
    }

    if (shadow_ground_dist < 0)
    {
        var inset = 2;
        var l  = bbox_left  + inset;
        var r  = bbox_right - inset;

        if (l > r) {
            l = (bbox_left + bbox_right) * 0.5;
            r = l;
        }

        var m1 = lerp(l, r, 0.25);
        var m2 = lerp(l, r, 0.50);
        var m3 = lerp(l, r, 0.75);

        for (var sd = 0; sd <= shadow_max_dist; sd++)
        {
            var ytest = bbox_bottom + sd;

            if (tile_any_solid_at(l,  ytest) ||
                tile_any_solid_at(m1, ytest) ||
                tile_any_solid_at(m2, ytest) ||
                tile_any_solid_at(m3, ytest) ||
                tile_any_solid_at(r,  ytest))
            {
                shadow_ground_dist   = sd;
                shadow_support_ratio = 1;
                shadow_support_cx    = x;
                shadow_support_left  = bbox_left;
                shadow_support_right = bbox_right;
                break;
            }
        }
    }

    if (feet_ground)
    {
        shadow_ground_dist   = 0;
        shadow_support_ratio = 1;
        shadow_support_cx    = x;
        shadow_support_left  = bbox_left;
        shadow_support_right = bbox_right;
    }
}
else
{
    shadow_ground_dist   = -1;
    shadow_support_ratio = 1;
    shadow_support_cx    = x;
    shadow_support_left  = bbox_left;
    shadow_support_right = bbox_right;
}

// ---------- VISUAL GROUND ----------
var grounded_visual = feet_ground || (coyote_timer > 0);

if (grounded_visual && state == "glide" && vsp >= 0 && abs(vsp) <= 0.35) {
    state = "idle";
}

// ---------- Jump trail history ----------
var trail_active =
    jump_trail_enabled &&
    (state == "jumping" || state == "glide" || (!feet_ground && abs(vsp) > 0.1));

if (trail_active)
{
    jump_trail_timer++;

    if (jump_trail_timer >= jump_trail_spacing)
    {
        jump_trail_timer = 0;

        var draw_x_now = x;
        var draw_y_now = y + draw_floor_inset - 10;

        for (var ti = jump_trail_max_points - 1; ti > 0; ti--) {
            jump_trail_points[ti] = jump_trail_points[ti - 1];
        }

        jump_trail_points[0] = {
            x : draw_x_now,
            y : draw_y_now,
            facing : facing,
            vsp : vsp,
            hsp : hsp
        };
    }
}
else
{
    jump_trail_timer = 0;

    for (var tc = 0; tc < jump_trail_max_points; tc++) {
        jump_trail_points[tc] = undefined;
    }
}

// ---------- ANIMATION ----------
if (grounded_visual) {
    if (state == "landing") {
        if (!bounce_pending) {
            if (image_index >= image_number - 1) {
                image_index = image_number - 1;
                image_speed = 0;
                state = "idle";
                jump_pose_timer = 0;
                __set_sprite_keep_feet_once(sprIdle, 1);
            }
        }
    }
    else if (state == "jump_charge" && jump_h) {
        if (sprCharge != -1) {
            jump_pose_timer = 0;
            __set_sprite_keep_feet_once(sprCharge, 0);
            image_speed = 0;
            image_index = jump_charge_level;
        }
        else {
            __set_sprite_keep_feet_once(sprIdle, 1);
        }
    }
    else {
        jump_pose_timer = 0;
        __set_sprite_keep_feet_once(sprIdle, 1);
    }
}
else {
    if (state == "jumping") {
        __set_sprite_keep_feet_once(sprJumping, jump_anim_speed);

        if (jump_pose_timer > 0) {
            jump_pose_timer--;
        }
        else {
            if (image_index >= image_number - 1) {
                state = "glide";
                __set_sprite_keep_feet_once(sprGlide, 1);
            }
        }
    }
    else {
        state = "glide";
        jump_pose_timer = 0;
        __set_sprite_keep_feet_once(sprGlide, 1);
    }
}

image_xscale = facing;

prev_jump_h    = jump_h;
prev_on_ground = feet_ground;