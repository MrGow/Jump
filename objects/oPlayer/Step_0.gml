/// oPlayer — Step (FULL)
/// Tightened edge-perch so player cannot stand so far off platform tips
/// + FIX: if arriving from below and landing on a tiny ledge tip,
///        count a blocked downward settle onto valid soft support as grounded
/// + FIX: charge anti-stuck now uses HARD support only, so platform tips
///        cannot keep jump_charge alive off soft perch logic
/// + NEW: moving platforms use standing_platform attachment logic
/// + FIX: standing_platform is cleared immediately after real jump launch
/// + FIX: moving platform charge now HARD-ANCHORS X to platform
/// + FIX: wallbounce no longer triggers when jumping into a wall while still near ground
/// + FIX: platform landing gets a short stick window to kill residual slide
/// + NEW: explicit ledge-supported state so fake-air ledges don't force glide / cancel charge
/// + NEW: rare glide-lock rescue for near-ground false-air frames
/// + NEW: anti-tip-stick when rising into upper ledge corners
/// oPlayer - Step (top safety wrapper)

/// oPlayer - Step safety guard (runtime-compatible)

// If script/function isn't available in this runtime, create a no-op fallback safely.
if (asset_get_index("ensure_tm_solids") == -1) {
    function ensure_tm_solids() { }
}
if (mask_index != spriteBotMask) mask_index = spriteBotMask;

// ---------- Hot-reload safety ----------
if (!variable_instance_exists(id,"hsp"))                 hsp = 0;
if (!variable_instance_exists(id,"vsp"))                 vsp = 0;
if (!variable_instance_exists(id,"gravity_amt"))         gravity_amt = 0.25;
if (!variable_instance_exists(id,"max_fall"))            max_fall = 8.0;

if (!variable_instance_exists(id,"jump_v_base"))         jump_v_base = -4.0;
if (!variable_instance_exists(id,"jump_h_base"))         jump_h_base =  4.0;

if (!variable_instance_exists(id,"low_jump_multiplier")) low_jump_multiplier = 1.7;
if (!variable_instance_exists(id,"fall_multiplier"))     fall_multiplier    = 1.4;

if (!variable_instance_exists(id,"jump_charge_frame_steps")) jump_charge_frame_steps = 6;
if (!variable_instance_exists(id,"jump_charge"))            jump_charge = 0;
if (!variable_instance_exists(id,"jump_charge_level"))      jump_charge_level = 0;
if (!variable_instance_exists(id,"jump_charging"))          jump_charging = false;
if (!variable_instance_exists(id,"prev_jump_h"))            prev_jump_h = false;

if (!variable_instance_exists(id,"charge_support_min"))      charge_support_min = 1;
if (!variable_instance_exists(id,"charge_grace_max"))        charge_grace_max   = 5;
if (!variable_instance_exists(id,"charge_grace"))            charge_grace       = 0;
if (!variable_instance_exists(id,"charge_start_lock_max"))   charge_start_lock_max = 2;
if (!variable_instance_exists(id,"charge_start_lock"))       charge_start_lock     = 0;

if (!variable_instance_exists(id,"prev_on_ground"))          prev_on_ground = false;

if (!variable_instance_exists(id,"ground_stick_max"))        ground_stick_max = 4;
if (!variable_instance_exists(id,"ground_stick"))            ground_stick = 0;

if (!variable_instance_exists(id,"ground_min_frames"))       ground_min_frames = 3;
if (!variable_instance_exists(id,"ground_frames"))           ground_frames = 0;

if (!variable_instance_exists(id,"support_stable_frames"))   support_stable_frames = 0;
if (!variable_instance_exists(id,"support_stable_needed"))   support_stable_needed = 2;

if (!variable_instance_exists(id,"facing"))                  facing = 1;
if (!variable_instance_exists(id,"state"))                   state = "idle";
if (!variable_instance_exists(id,"death_fall"))              death_fall = false;

if (!variable_instance_exists(id,"support_grace_max"))       support_grace_max = 4;
if (!variable_instance_exists(id,"support_grace"))           support_grace = 0;

if (!variable_instance_exists(id,"edge_charge_fail_max")) edge_charge_fail_max = 2;
if (!variable_instance_exists(id,"edge_charge_fail"))     edge_charge_fail     = 0;

if (!variable_instance_exists(id,"bounce_enabled"))       bounce_enabled = true;
if (!variable_instance_exists(id,"bounce_threshold"))     bounce_threshold = 2.0;
if (!variable_instance_exists(id,"bounce_mult"))          bounce_mult = 0.55;
if (!variable_instance_exists(id,"bounce_min"))           bounce_min = 2.0;
if (!variable_instance_exists(id,"bounce_max"))           bounce_max = 6.0;
if (!variable_instance_exists(id,"bounce_pause_frames"))  bounce_pause_frames = 1;
if (!variable_instance_exists(id,"bounce_h_damp"))        bounce_h_damp = 0.65;
if (!variable_instance_exists(id,"bounce_pending"))       bounce_pending = false;
if (!variable_instance_exists(id,"bounce_timer"))         bounce_timer = 0;
if (!variable_instance_exists(id,"bounce_v"))             bounce_v = 0;

if (!variable_instance_exists(id,"wallhit_enabled"))            wallhit_enabled = true;
if (!variable_instance_exists(id,"wallhit_threshold"))          wallhit_threshold = 3.5;
if (!variable_instance_exists(id,"wallhit_cooldown_frames"))    wallhit_cooldown_frames = 10;
if (!variable_instance_exists(id,"wallhit_cd"))                 wallhit_cd = 0;
if (!variable_instance_exists(id,"wallhit_hold_seconds"))       wallhit_hold_seconds = 0.40;
if (!variable_instance_exists(id,"wallhit_timer"))              wallhit_timer = 0;

if (!variable_instance_exists(id,"wallbounce_enabled"))         wallbounce_enabled = true;
if (!variable_instance_exists(id,"wallbounce_threshold"))       wallbounce_threshold = 2.8;
if (!variable_instance_exists(id,"wallbounce_mult"))            wallbounce_mult = 0.60;
if (!variable_instance_exists(id,"wallbounce_min_h"))           wallbounce_min_h = 1.5;
if (!variable_instance_exists(id,"wallbounce_upkick"))          wallbounce_upkick = 0.15;
if (!variable_instance_exists(id,"wallbounce_cd_frames"))       wallbounce_cd_frames = 3;
if (!variable_instance_exists(id,"wallbounce_cd"))              wallbounce_cd = 0;

if (!variable_instance_exists(id,"ground_probe_inset"))         ground_probe_inset = 10;
if (!variable_instance_exists(id,"vertical_probe_inset"))       vertical_probe_inset = 3;
if (!variable_instance_exists(id,"side_probe_top_margin"))      side_probe_top_margin = 10;
if (!variable_instance_exists(id,"side_probe_bottom_margin"))   side_probe_bottom_margin = 6;
if (!variable_instance_exists(id,"edge_perch_v_max"))           edge_perch_v_max = 0.08;
if (!variable_instance_exists(id,"edge_perch_support_needed"))  edge_perch_support_needed = 2;

if (!variable_instance_exists(id,"ledge_support_v_max"))        ledge_support_v_max = 0.20;
if (!variable_instance_exists(id,"ledge_support_grace_max"))    ledge_support_grace_max = 5;
if (!variable_instance_exists(id,"ledge_support_grace"))        ledge_support_grace = 0;

// ---------- Standing platform safety ----------
if (!variable_instance_exists(id,"standing_platform"))      standing_platform = noone;
if (!variable_instance_exists(id,"standing_platform_xoff")) standing_platform_xoff = 0;
if (!variable_instance_exists(id,"platform_stick_timer"))   platform_stick_timer = 0;


// ---------- SPRITE HELPERS ----------
function __spr(_name) { var s = asset_get_index(_name); return (s != -1) ? s : -1; }

function __unstick_from_wall()
{
    if (!rect_hits_solid(0,0)) return;
    for (var i = 1; i <= 6; i++) {
        if (!rect_hits_solid(-i,0)) { x -= i; return; }
        if (!rect_hits_solid( i,0)) { x += i; return; }
    }
}

function __set_sprite_keep_feet_once(_spr, _speed) {
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

// Sprites
var sprIdle     = __spr("spriteBotIdle");
var sprCharge   = __spr("spriteBotJumpCharge");
var sprJumping  = __spr("spriteBotJumping");
var sprGlide    = __spr("spriteBotGliding");
var sprLanding  = __spr("spriteBotLanding");
var sprDeath    = __spr("spriteBotDeath");

// Ensure solids tilemap
ensure_tm_solids();


// ----------------------------------------------------
// DEAD: lock gameplay + HOLD last death frame
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

        if (vsp != 0) {
            var sy_dead = sign(vsp);
            var my_dead = abs(vsp);

            repeat (floor(my_dead)) {
                if (!rect_hits_solid(0, sy_dead)) y += sy_dead;
                else { vsp = 0; break; }
            }

            var fy_dead = my_dead - floor(my_dead);
            if (fy_dead > 0 && vsp != 0) {
                if (!rect_hits_solid(0, sy_dead * fy_dead)) y += sy_dead * fy_dead;
                else vsp = 0;
            }
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


// ---------- INPUT ----------
var left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var dir_input = (right ? 1 : 0) - (left ? 1 : 0);

var jump_h = keyboard_check(vk_space) || keyboard_check(vk_up);
if (variable_global_exists("inp_jump_held")) jump_h = global.inp_jump_held;

var jump_p = (jump_h && !prev_jump_h);
var jump_r = (!jump_h && prev_jump_h);

if (dir_input != 0) facing = (dir_input > 0) ? 1 : -1;

if (wallhit_cd > 0) wallhit_cd--;
if (wallbounce_cd > 0) wallbounce_cd--;
if (wallhit_timer > 0) wallhit_timer--;
if (charge_start_lock > 0) charge_start_lock--;


// ---------- STANDING PLATFORM CARRY ----------
var riding_platform_now = false;
if (platform_stick_timer > 0) platform_stick_timer--;

if (instance_exists(standing_platform))
{
    var _plat = standing_platform;

    var _overlap =
        (bbox_right > _plat.bbox_left + _plat.ride_side_inset) &&
        (bbox_left  < _plat.bbox_right - _plat.ride_side_inset);

    var _feet_close =
        (bbox_bottom >= _plat.bbox_top - 2) &&
        (bbox_bottom <= _plat.bbox_top + _plat.ride_top_tolerance + 2);

    var _allow_ride = !((vsp < 0) && !jump_charging);
    var _ride_ok = _overlap && _feet_close && _allow_ride;

    if (_ride_ok)
    {
        riding_platform_now = true;

        if (abs(vsp) <= 1.5) platform_stick_timer = max(platform_stick_timer, 6);

        if (jump_charging)
        {
            x = _plat.x + standing_platform_xoff;
            y += _plat.dy;
            var _snap_charge = _plat.bbox_top - bbox_bottom;
            if (abs(_snap_charge) <= _plat.ride_top_tolerance + 2) y += _snap_charge;
            hsp = 0;
        }
        else
        {
            x += _plat.dx;
            y += _plat.dy;

            var _snap = _plat.bbox_top - bbox_bottom;
            if (abs(_snap) <= _plat.ride_top_tolerance + 2) y += _snap;

            if (platform_stick_timer > 0) {
                x = _plat.x + standing_platform_xoff;
                hsp = 0;
            } else {
                standing_platform_xoff = x - _plat.x;
                var _rel_h = hsp * 0.15;
                if (abs(_rel_h) < 0.05) _rel_h = 0;
                hsp = _rel_h;
            }
        }

        ground_stick = max(ground_stick, 1);
        ground_frames = max(ground_frames, 1);
        prev_on_ground = true;

        if (jump_charging) {
            charge_grace  = max(charge_grace, 1);
            support_grace = max(support_grace, 1);
        }
    }
    else {
        standing_platform = noone;
        platform_stick_timer = 0;
    }
}
else {
    standing_platform = noone;
    platform_stick_timer = 0;
}


// ---------- Ground support count helpers ----------
function __ground_support_count()
{
    if (vsp < 0) return 0;
    var ytest = bbox_bottom + 1;
    var inset = ground_probe_inset;
    var l = bbox_left + inset, r = bbox_right - inset;
    if (l > r) { l = (bbox_left + bbox_right) * 0.5; r = l; }
    var m1 = lerp(l, r, 0.25), m2 = lerp(l, r, 0.50), m3 = lerp(l, r, 0.75);
    var c = 0;
    if (tile_any_solid_at(l,  ytest)) c++;
    if (tile_any_solid_at(m1, ytest)) c++;
    if (tile_any_solid_at(m2, ytest)) c++;
    if (tile_any_solid_at(m3, ytest)) c++;
    if (tile_any_solid_at(r,  ytest)) c++;
    return c;
}

function __ground_support_count_soft()
{
    if (vsp < 0) return 0;
    var ytest = bbox_bottom + 1;
    var inset = vertical_probe_inset;
    var l = bbox_left + inset, r = bbox_right - inset;
    if (l > r) { l = (bbox_left + bbox_right) * 0.5; r = l; }
    var m1 = lerp(l, r, 0.25), m2 = lerp(l, r, 0.50), m3 = lerp(l, r, 0.75);
    var c = 0;
    if (tile_any_solid_at(l,  ytest)) c++;
    if (tile_any_solid_at(m1, ytest)) c++;
    if (tile_any_solid_at(m2, ytest)) c++;
    if (tile_any_solid_at(m3, ytest)) c++;
    if (tile_any_solid_at(r,  ytest)) c++;
    return c;
}


// ---------- Ground stability at frame start ----------
var feet_ground_start      = on_ground_check();
var feet_ground_start_soft = on_ground_soft_check();
var support_start          = __ground_support_count();
var support_start_soft     = __ground_support_count_soft();

var edge_perched_start =
    (!feet_ground_start) && feet_ground_start_soft &&
    (support_start_soft >= edge_perch_support_needed) &&
    (abs(vsp) <= edge_perch_v_max);

var ledge_supported_start =
    (!feet_ground_start) && feet_ground_start_soft &&
    (support_start_soft >= edge_perch_support_needed) &&
    (abs(vsp) <= ledge_support_v_max) &&
    (ground_frames > 0 || ground_stick > 0 || ledge_support_grace > 0);

if (feet_ground_start || edge_perched_start || riding_platform_now) ledge_support_grace = ledge_support_grace_max;
else if (ledge_support_grace > 0) ledge_support_grace--;

if ((support_start >= charge_support_min && feet_ground_start) || edge_perched_start || ledge_supported_start || riding_platform_now) support_stable_frames++;
else support_stable_frames = 0;

if (jump_charging) {
    if (support_start <= 0 && !feet_ground_start && !ledge_supported_start && !riding_platform_now) edge_charge_fail++;
    else edge_charge_fail = 0;
} else edge_charge_fail = 0;

if (vsp < 0) ground_stick = 0;
if (feet_ground_start || edge_perched_start || ledge_supported_start || riding_platform_now) ground_stick = ground_stick_max;
else if (ground_stick > 0 && vsp >= 0) ground_stick--;

var on_ground_start = feet_ground_start || edge_perched_start || ledge_supported_start || riding_platform_now || (ground_stick > 0);

if (on_ground_start) ground_frames = ground_min_frames;
else if (ground_frames > 0) ground_frames--;

var grounded_stable_start = on_ground_start || (ground_frames > 0);
var grounded_for_state_start = feet_ground_start || edge_perched_start || ledge_supported_start || riding_platform_now || (ground_frames > 0);
if (grounded_for_state_start && vsp > 0) vsp = 0;

if (feet_ground_start || edge_perched_start || ledge_supported_start || riding_platform_now) charge_grace = charge_grace_max;
else if (charge_grace > 0) charge_grace--;

if (support_start >= 1 || edge_perched_start || ledge_supported_start || riding_platform_now) support_grace = support_grace_max;
else if (support_grace > 0) support_grace--;

var max_charge_level = (sprCharge != -1) ? max(0, sprite_get_number(sprCharge) - 1) : 3;


// ---------- APPLY PENDING LANDING BOUNCE ----------
if (bounce_pending) {
    bounce_timer--;
    if (bounce_timer <= 0) {
        bounce_pending = false;

        vsp = bounce_v;
        state = "jumping";
        __set_sprite_keep_feet_once(sprJumping, 0.35);

        ground_stick = 0;
        charge_grace = 0;
        charge_start_lock = 0;
        support_grace = 0;
        ground_frames = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;

        feet_ground_start = false;
        on_ground_start = false;
        grounded_stable_start = false;
        support_start = 0;
    }
}


// ---------- CHARGE LOGIC ----------
var can_start_charge =
    grounded_for_state_start &&
    (feet_ground_start || edge_perched_start || ledge_supported_start || riding_platform_now) &&
    ((support_start >= charge_support_min) || edge_perched_start || ledge_supported_start || riding_platform_now) &&
    (support_stable_frames >= support_stable_needed || ledge_supported_start || riding_platform_now) &&
    (abs(vsp) < 0.25) &&
    !bounce_pending &&
    (state != "landing");

var can_continue_charge =
    (charge_start_lock > 0) ||
    ((feet_ground_start || edge_perched_start || ledge_supported_start || riding_platform_now || charge_grace > 0 || support_grace > 0) && (abs(vsp) < 0.35));

if (!jump_charging) {
    if (jump_p && can_start_charge) {
        jump_charging = true;
        jump_charge = 0;
        jump_charge_level = 0;
        state = "jump_charge";
        charge_start_lock = charge_start_lock_max;
        edge_charge_fail = 0;
    }
} else {
    if (edge_charge_fail >= edge_charge_fail_max) {
        jump_charging = false;
        jump_charge = 0;
        jump_charge_level = 0;
        charge_start_lock = 0;
        support_grace = 0;
        charge_grace = 0;
        ground_frames = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;
        if (state == "jump_charge") state = (feet_ground_start || ledge_supported_start || riding_platform_now) ? "idle" : "glide";
    }

    if (jump_h) {
        jump_charge += 1;
        var steps_per_frame = max(1, jump_charge_frame_steps);
        jump_charge_level = clamp(floor(jump_charge / steps_per_frame), 0, max_charge_level);
    }

    if (jump_r) {
        var mult = 1.0 + (0.25 * jump_charge_level);

        vsp = jump_v_base * mult;
        hsp = jump_h_base * mult * facing;

        jump_charging = false;
        jump_charge = 0;
        jump_charge_level = 0;

        state = "jumping";
        __set_sprite_keep_feet_once(sprJumping, 0.35);

        ground_stick = 0;
        charge_grace = 0;
        charge_start_lock = 0;
        support_grace = 0;
        ground_frames = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;

        standing_platform = noone;
        platform_stick_timer = 0;

        feet_ground_start = false;
        on_ground_start = false;
        grounded_stable_start = false;
    }
    else if (!jump_h || !can_continue_charge) {
        jump_charging = false;
        jump_charge = 0;
        jump_charge_level = 0;
        charge_start_lock = 0;
        support_grace = 0;
        support_stable_frames = 0;
        edge_charge_fail = 0;

        if (state == "jump_charge") {
            state = (feet_ground_start || ledge_supported_start || riding_platform_now) ? "idle" : "glide";
        }
    }
}


// ---------- Ground friction / air drag ----------
if (grounded_for_state_start && !jump_charging && !bounce_pending &&
    state != "jumping" && state != "glide") {
    hsp = 0;
} else if (!grounded_for_state_start) {
    hsp *= 0.995;
}


// ---------- GRAVITY ----------
var g = gravity_amt;
if (!grounded_for_state_start) {
    if (vsp < 0) { if (!jump_h) g += gravity_amt * (low_jump_multiplier - 1.0); }
    else g += gravity_amt * (fall_multiplier - 1.0);
}
vsp += g;
if (vsp > max_fall) vsp = max_fall;


// ---------- COLLISIONS (H) + WALL BOUNCE ----------
var hit_wall = false;
var wall_dir = 0;
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

    var hard_ground_now = on_ground_check();
    var soft_ground_now = on_ground_soft_check();
    var near_ground_now = hard_ground_now || soft_ground_now || rect_hits_solid(0, 1);

    var airborne_for_bounce = !grounded_stable_start && (ground_stick <= 0) && !near_ground_now;

    if (wallbounce_enabled && airborne_for_bounce &&
        wall_impact >= wallbounce_threshold &&
        wallbounce_cd <= 0)
    {
        wallbounce_cd = wallbounce_cd_frames;

        var nb = -hsp_attempt * wallbounce_mult;
        if (abs(nb) < wallbounce_min_h) nb = wallbounce_min_h * sign(nb == 0 ? -wall_dir : nb);

        hsp = nb;
        if (wallbounce_upkick > 0) vsp = min(vsp, 0) - wallbounce_upkick;
        if (hsp != 0) facing = (hsp > 0) ? 1 : -1;
    }
    else hsp = 0;

    if (wallhit_enabled && wall_impact >= wallhit_threshold && wallhit_cd <= 0) {
        wallhit_cd = wallhit_cooldown_frames;
        wallhit_timer = ceil(room_speed * wallhit_hold_seconds);
    }
}


// ---------- COLLISIONS (V) ----------
var vsp_before_vcollide = vsp;

if (vsp != 0) {
    var sy = sign(vsp);
    var my = abs(vsp);

    repeat (floor(my)) {
        if (!rect_hits_solid(0, sy)) y += sy;
        else { vsp = 0; break; }
    }

    var fy = my - floor(my);
    if (fy > 0 && vsp != 0) {
        if (!rect_hits_solid(0, sy * fy)) y += sy * fy;
        else vsp = 0;
    }
}


// ---------- Ground after movement (FIXED) ----------
var feet_ground      = on_ground_check();
var feet_ground_soft = on_ground_soft_check();
var support_soft     = __ground_support_count_soft();

var blocked_down_on_soft_edge =
    (vsp_before_vcollide > 0) &&
    (vsp == 0) &&
    feet_ground_soft &&
    (support_soft >= edge_perch_support_needed);

var edge_perched =
    (
        (!feet_ground) &&
        feet_ground_soft &&
        (support_soft >= edge_perch_support_needed) &&
        (abs(vsp) <= edge_perch_v_max)
    )
    || blocked_down_on_soft_edge;

// Hard ground stays for true landing / bounce logic
if (edge_perched) feet_ground = true;

// -------- anti-tip-stick while moving upward --------
if (vsp_before_vcollide < 0 && vsp == 0)
{
    var pushed = false;
    for (var n = 1; n <= 4; n++) {
        if (!rect_hits_solid(-n, 0) && !rect_hits_solid(-n, -1)) { x -= n; pushed = true; break; }
        if (!rect_hits_solid( n, 0) && !rect_hits_solid( n, -1)) { x += n; pushed = true; break; }
    }
    // if no lateral escape, just ensure we don't get "support-grabbed" this frame
    if (!pushed) {
        // nothing else needed; ledge support below is vsp>=0 gated
    }
}

if (vsp < 0) ground_stick = 0;
if (feet_ground) ground_stick = ground_stick_max;
else if (ground_stick > 0 && vsp >= 0) ground_stick--;

var on_ground = feet_ground || (ground_stick > 0);

if (on_ground) ground_frames = ground_min_frames;
else if (ground_frames > 0) ground_frames--;

// stricter ledge support: never while moving upward
var ledge_supported =
    (vsp >= 0) &&
    (!feet_ground) &&
    feet_ground_soft &&
    (support_soft >= edge_perch_support_needed) &&
    (abs(vsp) <= ledge_support_v_max) &&
    (ground_frames > 0 || ground_stick > 0 || ledge_support_grace > 0);

// rare fake-air rescue
var near_ground_rescue =
    (!feet_ground) &&
    feet_ground_soft &&
    (support_soft >= 1) &&
    (vsp >= 0) &&
    (abs(vsp) <= 0.35) &&
    (
        rect_hits_solid(0, 1) ||
        rect_hits_solid(0, 2) ||
        ground_frames > 0 ||
        ground_stick > 0 ||
        ledge_support_grace > 0
    );

if (near_ground_rescue) {
    ledge_supported = true;
    if (vsp > 0) vsp = 0;
}

var grounded_stable = on_ground || ledge_supported || (ground_frames > 0);

// keep hard landing edge separate from ledge rescue
var just_landed = (!prev_on_ground && (feet_ground || on_ground));


// ---------- LANDING TRIGGER + OPTIONAL BOUNCE (FIXED) ----------
var impact = max(0, vsp_before_vcollide);
var landed_hard  = (feet_ground || on_ground);
var landed_ledge = (!landed_hard) && ledge_supported && (impact > 0.2);

// Enter landing state only on hard ground
if (just_landed && landed_hard) {
    state = "landing";
    __set_sprite_keep_feet_once(sprLanding, 0.4);
}

// Bounce from hard land or ledge catch
if ((just_landed && landed_hard) || landed_ledge) {
    if (bounce_enabled && impact >= bounce_threshold) {
        bounce_v = -clamp(impact * bounce_mult, bounce_min, bounce_max);
        bounce_timer = max(0, bounce_pause_frames);
        bounce_pending = true;
        hsp *= bounce_h_damp;
    } else if (just_landed && landed_hard) {
        hsp = 0;
        vsp = 0;
    }
}


// ---------- VISUAL GROUND ----------
var grounded_visual = grounded_stable || near_ground_rescue;
if (grounded_visual && state == "glide" && vsp >= 0 && abs(vsp) <= 0.35) state = "idle";


// ---------- ANIMATION ----------
if (grounded_visual) {
    if (state == "landing") {
        if (!bounce_pending) {
            if (image_index >= image_number - 1) {
                image_index = image_number - 1;
                image_speed = 0;
                state = "idle";
                __set_sprite_keep_feet_once(sprIdle, 1);
            }
        }
    }
    else if (state == "jump_charge" && jump_h) {
        if (sprCharge != -1) {
            __set_sprite_keep_feet_once(sprCharge, 0);
            image_speed = 0;
            image_index = jump_charge_level;
        } else {
            __set_sprite_keep_feet_once(sprIdle, 1);
        }
    }
    else {
        __set_sprite_keep_feet_once(sprIdle, 1);
    }
} else {
    if (state == "jumping") {
        if (image_index >= image_number - 1) {
            state = "glide";
            __set_sprite_keep_feet_once(sprGlide, 1);
        } else {
            __set_sprite_keep_feet_once(sprJumping, 0.35);
        }
    } else {
        state = "glide";
        __set_sprite_keep_feet_once(sprGlide, 1);
    }
}

image_xscale = facing;

prev_jump_h    = jump_h;
prev_on_ground = grounded_stable;