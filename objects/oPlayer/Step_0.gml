/// oPlayer — Step  (FULL)


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

if (!variable_instance_exists(id,"prev_on_ground"))         prev_on_ground = false;

if (!variable_instance_exists(id,"ground_stick_max"))       ground_stick_max = 4;
if (!variable_instance_exists(id,"ground_stick"))           ground_stick = 0;

if (!variable_instance_exists(id,"facing"))                 facing = 1;
if (!variable_instance_exists(id,"state"))                  state = "idle";

// Bounce safety
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

// Wallhit overlay safety
if (!variable_instance_exists(id,"wallhit_enabled"))            wallhit_enabled = true;
if (!variable_instance_exists(id,"wallhit_threshold"))          wallhit_threshold = 3.5;
if (!variable_instance_exists(id,"wallhit_cooldown_frames"))    wallhit_cooldown_frames = 10;
if (!variable_instance_exists(id,"wallhit_cd"))                 wallhit_cd = 0;
if (!variable_instance_exists(id,"wallhit_hold_seconds"))       wallhit_hold_seconds = 0.40;
if (!variable_instance_exists(id,"wallhit_timer"))              wallhit_timer = 0;

// Wallbounce safety
if (!variable_instance_exists(id,"wallbounce_enabled"))         wallbounce_enabled = true;
if (!variable_instance_exists(id,"wallbounce_threshold"))       wallbounce_threshold = 2.8;
if (!variable_instance_exists(id,"wallbounce_mult"))            wallbounce_mult = 0.60;
if (!variable_instance_exists(id,"wallbounce_min_h"))           wallbounce_min_h = 1.5;
if (!variable_instance_exists(id,"wallbounce_upkick"))          wallbounce_upkick = 0.15;
if (!variable_instance_exists(id,"wallbounce_cd_frames"))       wallbounce_cd_frames = 3;
if (!variable_instance_exists(id,"wallbounce_cd"))              wallbounce_cd = 0;


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

// Ensure solids tilemap
ensure_tm_solids();


// ---------- INPUT ----------
var left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var dir_input = (right ? 1 : 0) - (left ? 1 : 0);

var jump_h = keyboard_check(vk_space) || keyboard_check(vk_up);
if (variable_global_exists("inp_jump_held")) jump_h = global.inp_jump_held;

var jump_r = (!jump_h && prev_jump_h);

if (dir_input != 0) facing = (dir_input > 0) ? 1 : -1;

// Cooldowns
if (wallhit_cd > 0) wallhit_cd--;
if (wallbounce_cd > 0) wallbounce_cd--;
if (wallhit_timer > 0) wallhit_timer--;

if (charge_start_lock > 0) charge_start_lock--;


// ---------- Ground support count ----------
function __ground_support_count()
{
    if (vsp < 0) return 0;

    var ytest = bbox_bottom + 1;

    var inset = 2;
    var l = bbox_left  + inset;
    var r = bbox_right - inset;

    if (l > r) { l = (bbox_left + bbox_right) * 0.5; r = l; }

    var m1 = lerp(l, r, 0.25);
    var m2 = lerp(l, r, 0.50);
    var m3 = lerp(l, r, 0.75);

    var c = 0;
    if (tile_any_solid_at(l,  ytest)) c++;
    if (tile_any_solid_at(m1, ytest)) c++;
    if (tile_any_solid_at(m2, ytest)) c++;
    if (tile_any_solid_at(m3, ytest)) c++;
    if (tile_any_solid_at(r,  ytest)) c++;
    return c;
}


// ---------- Ground stability at frame start ----------
var feet_ground_start = on_ground_check();
var support_start     = __ground_support_count();

if (vsp < 0) ground_stick = 0;

if (feet_ground_start) ground_stick = ground_stick_max;
else if (ground_stick > 0 && vsp >= 0) ground_stick--;

var on_ground_start = feet_ground_start || (ground_stick > 0);

// Stabilize tiny downward on ground
if (on_ground_start && vsp > 0) vsp = 0;

// Charge grace refresh/decay
if (feet_ground_start) charge_grace = charge_grace_max;
else if (charge_grace > 0) charge_grace--;

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

        feet_ground_start = false;
        on_ground_start   = false;
        support_start     = 0;
    }
}


// ---------- CHARGE LOGIC (EDGE-FRIENDLY, NO LOOP) ----------
// Start: allow support>=1, but require near-zero vsp
var can_start_charge =
    feet_ground_start &&
    (support_start >= charge_support_min) &&
    (abs(vsp) < 0.25) &&
    !bounce_pending &&
    (state != "landing");

// Continue: allow grace + lock window
var can_continue_charge =
    (charge_start_lock > 0) ||
    ((feet_ground_start || charge_grace > 0) && (abs(vsp) < 0.35) && (support_start >= 1));

if (!jump_charging) {

    if (jump_h && can_start_charge) {
        jump_charging     = true;
        jump_charge       = 0;
        jump_charge_level = 0;
        state             = "jump_charge";

        // Lock charge briefly so ledge flicker can't cancel instantly
        charge_start_lock = charge_start_lock_max;
    }

} else {

    if (jump_h) {
        jump_charge += 1;
        var steps_per_frame = max(1, jump_charge_frame_steps);
        jump_charge_level = clamp(floor(jump_charge / steps_per_frame), 0, max_charge_level);
    }

    // RELEASE ALWAYS JUMPS
    if (jump_r) {
        var mult = 1.0 + (0.25 * jump_charge_level);

        vsp = jump_v_base * mult;
        hsp = jump_h_base * mult * facing;

        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;

        state = "jumping";
        __set_sprite_keep_feet_once(sprJumping, 0.35);

        ground_stick = 0;
        charge_grace = 0;
        charge_start_lock = 0;

        feet_ground_start = false;
        on_ground_start   = false;
    }
    else if (!jump_h || !can_continue_charge) {
        // Cancel (but not in the first lock frames)
        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;
        charge_start_lock = 0;
        if (state == "jump_charge") state = "idle";
    }
}


// ---------- Ground friction / air drag ----------
if (on_ground_start && !jump_charging && !bounce_pending &&
    state != "jumping" && state != "glide") {
    hsp = 0;
} else if (!on_ground_start) {
    hsp *= 0.995;
}


// ---------- GRAVITY ----------
var g = gravity_amt;

if (!on_ground_start) {
    if (vsp < 0) {
        if (!jump_h) g += gravity_amt * (low_jump_multiplier - 1.0);
    } else {
        g += gravity_amt * (fall_multiplier - 1.0);
    }
}

vsp += g;
if (vsp > max_fall) vsp = max_fall;


// ---------- COLLISIONS (H) + WALL BOUNCE ----------
var hit_wall       = false;
var wall_dir       = 0;
var wall_impact    = 0;

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

    var airborne_for_bounce = !on_ground_start && (ground_stick <= 0);

    if (wallbounce_enabled && airborne_for_bounce &&
        wall_impact >= wallbounce_threshold &&
        wallbounce_cd <= 0)
    {
        wallbounce_cd = wallbounce_cd_frames;

        var nb = -hsp_attempt * wallbounce_mult;
        if (abs(nb) < wallbounce_min_h)
            nb = wallbounce_min_h * sign(nb == 0 ? -wall_dir : nb);

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


// ---------- Ground after movement ----------
var feet_ground = on_ground_check();

if (vsp < 0) ground_stick = 0;

if (feet_ground) ground_stick = ground_stick_max;
else if (ground_stick > 0 && vsp >= 0) ground_stick--;

var on_ground = feet_ground || (ground_stick > 0);
var just_landed = (!prev_on_ground && on_ground);


// ---------- LANDING TRIGGER + OPTIONAL BOUNCE ----------
if (just_landed) {
    state = "landing";
    __set_sprite_keep_feet_once(sprLanding, 0.4);

    var impact = max(0, vsp_before_vcollide);

    if (bounce_enabled && impact >= bounce_threshold) {
        bounce_v = -clamp(impact * bounce_mult, bounce_min, bounce_max);
        bounce_timer = max(0, bounce_pause_frames);
        bounce_pending = true;

        hsp *= bounce_h_damp;
    } else {
        hsp = 0;
        vsp = 0;
    }
}


// ---------- ANIMATION ----------
if (on_ground) {
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
        state = "idle";
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
prev_on_ground = on_ground;
