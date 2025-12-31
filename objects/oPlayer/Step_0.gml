/// oPlayer — Step  (Forward impulse jump + Jumping->Gliding + Landing + Bounce + TIMED WallHit)


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

if (!variable_instance_exists(id,"prev_on_ground"))         prev_on_ground = false;

if (!variable_instance_exists(id,"facing"))                 facing = 1;
if (!variable_instance_exists(id,"state"))                  state = "idle";

// HP safety
if (!variable_instance_exists(id,"max_hp")) max_hp = 1;
if (!variable_instance_exists(id,"hp"))     hp = max_hp;

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

// Wallhit safety
if (!variable_instance_exists(id,"wallhit_enabled"))            wallhit_enabled = true;
if (!variable_instance_exists(id,"wallhit_threshold"))          wallhit_threshold = 3.5;
if (!variable_instance_exists(id,"wallhit_cooldown_frames"))    wallhit_cooldown_frames = 10;
if (!variable_instance_exists(id,"wallhit_cd"))                 wallhit_cd = 0;

if (!variable_instance_exists(id,"wallhit_hold_seconds"))       wallhit_hold_seconds = 1.25;
if (!variable_instance_exists(id,"wallhit_timer"))              wallhit_timer = 0;


// ---------- SPRITE HELPERS ----------
function __spr(_name) {
    var s = asset_get_index(_name);
    return (s != -1) ? s : -1;
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
}

// Sprites
var sprIdle     = __spr("spriteBotIdle");
var sprCharge   = __spr("spriteBotJumpCharge");
var sprJumping  = __spr("spriteBotJumping");
var sprGlide    = __spr("spriteBotGliding");
var sprLanding  = __spr("spriteBotLanding");
var sprWallHit  = __spr("spriteBotWallHit");

// ---------- Ensure solids tilemap ----------
ensure_tm_solids();

// ---------- INPUT (turning only; no walking) ----------
var left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var dir_input = (right ? 1 : 0) - (left ? 1 : 0);

var jump_h = keyboard_check(vk_space) || keyboard_check(vk_up);
if (variable_global_exists("inp_jump_held")) jump_h = global.inp_jump_held;

var jump_r = (!jump_h && prev_jump_h);

// Ground state at frame start (feet-only, safe near ledges)
var on_ground_start = on_ground_check();

// Turning
if (dir_input != 0) facing = (dir_input > 0) ? 1 : -1;

// Cooldown tick
if (wallhit_cd > 0) wallhit_cd -= 1;

// Wallhit active?
var wallhit_active = (state == "wallhit" && wallhit_timer > 0);

// Landing/bounce lockout
var landing_locked = (state == "landing") || (bounce_pending) || wallhit_active;


// ---------- APPLY PENDING BOUNCE ----------
if (bounce_pending) {
    bounce_timer -= 1;

    if (bounce_timer <= 0) {
        bounce_pending = false;

        vsp = bounce_v;

        state = "jumping";
        __set_sprite_keep_feet_once(sprJumping, 0.35);

        on_ground_start = false;
    }
}


// ---------- CHARGE LOGIC ----------
var max_charge_level;
if (sprCharge != -1) max_charge_level = max(0, sprite_get_number(sprCharge) - 1);
else                 max_charge_level = 3;

// ✅ EXTRA SAFETY: only allow charging if we are truly settled (no vertical motion)
var grounded_for_charge = on_ground_start && (abs(vsp) < 0.0001);

if (grounded_for_charge && !landing_locked) {

    if (jump_h && !jump_charging) {
        jump_charging = true;
        jump_charge = 0;
        jump_charge_level = 0;
        state = "jump_charge";
    }

    if (jump_charging && jump_h) {
        jump_charge += 1;
        var steps_per_frame = max(1, jump_charge_frame_steps);
        jump_charge_level = clamp(floor(jump_charge / steps_per_frame), 0, max_charge_level);
    }

    if (jump_charging && jump_r) {
        var mult = 1.0 + (0.25 * jump_charge_level);

        vsp = jump_v_base * mult;
        hsp = jump_h_base * mult * facing;

        jump_charging = false;
        jump_charge = 0;
        jump_charge_level = 0;

        state = "jumping";
        __set_sprite_keep_feet_once(sprJumping, 0.35);

        on_ground_start = false;
    }

} else {
    jump_charging = false;
    jump_charge = 0;
    jump_charge_level = 0;
    if (state == "jump_charge") state = "idle";
}


// ---------- Ground friction / air drag ----------
if (on_ground_start && !jump_charging && !bounce_pending && !wallhit_active &&
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


// ---------- COLLISIONS (H) + WALL HIT DETECT ----------
var hit_wall = false;
var wall_impact = 0;

var hsp_attempt = hsp;

if (hsp != 0) {
    var sx = sign(hsp);
    var mx = abs(hsp);

    repeat (floor(mx)) {
        if (!rect_hits_solid(sx, 0)) x += sx;
        else { hit_wall = true; hsp = 0; break; }
    }

    var fx = mx - floor(mx);
    if (fx > 0 && hsp != 0) {
        if (!rect_hits_solid(sx * fx, 0)) x += sx * fx;
        else { hit_wall = true; hsp = 0; }
    }
}

if (hit_wall) wall_impact = abs(hsp_attempt);

// Start timed wallhit
var wallhit_started_this_frame = false;

if (hit_wall && wallhit_enabled && (wall_impact >= wallhit_threshold) &&
    wallhit_cd <= 0 && wallhit_timer <= 0) {

    wallhit_cd = wallhit_cooldown_frames;
    wallhit_started_this_frame = true;

    wallhit_timer = ceil(room_speed * wallhit_hold_seconds);
    state = "wallhit";

    if (sprWallHit != -1) {
        __set_sprite_keep_feet_once(sprWallHit, 0);
        image_speed = 0;
        image_index = 0;
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

// Ground state after movement
var on_ground = on_ground_check();
var just_landed = (!prev_on_ground && on_ground);


// ---------- LANDING TRIGGER + OPTIONAL BOUNCE ----------
if (just_landed && !wallhit_started_this_frame && state != "wallhit") {

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


// ---------- ANIMATION / STATE MACHINE ----------
if (on_ground) {

    if (state == "wallhit") {
        if (wallhit_timer > 0) {
            wallhit_timer -= 1;
            if (sprWallHit != -1) {
                __set_sprite_keep_feet_once(sprWallHit, 0);
                image_speed = 0;
                image_index = 0;
            }
        } else {
            state = "idle";
            __set_sprite_keep_feet_once(sprIdle, 0.4);
        }
    }
    else if (state == "landing") {
        if (!bounce_pending) {
            if (image_index >= image_number - 1) {
                image_index = image_number - 1;
                image_speed = 0;
                state = "idle";
                __set_sprite_keep_feet_once(sprIdle, 0.4);
            }
        }
    }
    else if (state == "jump_charge" && jump_h) {
        if (sprCharge != -1) {
            __set_sprite_keep_feet_once(sprCharge, 0);
            image_speed = 0;
            image_index = jump_charge_level;
        } else {
            __set_sprite_keep_feet_once(sprIdle, 0.4);
        }
    }
    else {
        state = "idle";
        __set_sprite_keep_feet_once(sprIdle, 0.4);
    }

} else {
    // Airborne
    if (state == "wallhit") {
        if (wallhit_timer > 0) {
            wallhit_timer -= 1;
            if (sprWallHit != -1) {
                __set_sprite_keep_feet_once(sprWallHit, 0);
                image_speed = 0;
                image_index = 0;
            }
        } else {
            state = "glide";
            __set_sprite_keep_feet_once(sprGlide, 0.25);
        }
    }
    else if (state == "jumping") {
        if (image_index >= image_number - 1) {
            state = "glide";
            __set_sprite_keep_feet_once(sprGlide, 0.25);
        } else {
            __set_sprite_keep_feet_once(sprJumping, 0.35);
        }
    }
    else {
        state = "glide";
        __set_sprite_keep_feet_once(sprGlide, 0.25);
    }
}

// Face direction
image_xscale = facing;

// Store for next frame
prev_jump_h    = jump_h;
prev_on_ground = on_ground;
