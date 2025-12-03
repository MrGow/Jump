/// oPlayer — Step  (JumpBot, tile collisions + variable jump)

// ---------- Hot-reload safety for movement vars ----------
if (!variable_instance_exists(id,"hsp"))                 hsp = 0;
if (!variable_instance_exists(id,"vsp"))                 vsp = 0;
if (!variable_instance_exists(id,"move_speed"))          move_speed = 2.5;
if (!variable_instance_exists(id,"jump_speed"))          jump_speed = -5.0;
if (!variable_instance_exists(id,"gravity_amt"))         gravity_amt = 0.25;
if (!variable_instance_exists(id,"max_fall"))            max_fall = 8.0;
if (!variable_instance_exists(id,"fall_speed_peak"))     fall_speed_peak = 0;
if (!variable_instance_exists(id,"low_jump_multiplier")) low_jump_multiplier = 1.7; // extra gravity when button released
if (!variable_instance_exists(id,"fall_multiplier"))     fall_multiplier    = 1.4; // extra gravity when falling
if (!variable_instance_exists(id,"state"))               state = "idle";

// ---------- SPRITE HELPERS ----------
function __spr(_name) {
    var s = asset_get_index(_name);
    return (s != -1) ? s : -1;
}

function __set_sprite_keep_feet(_spr,_speed){
    if (_spr == -1) return;
    var cur_yoff = sprite_get_yoffset(sprite_index);
    var cur_bot  = sprite_get_bbox_bottom(sprite_index);
    var feet_y   = y - cur_yoff + cur_bot;

    sprite_index = _spr;
    if (!is_undefined(_speed)) image_speed = _speed;

    var new_yoff = sprite_get_yoffset(sprite_index);
    var new_bot  = sprite_get_bbox_bottom(sprite_index);
    y = feet_y - (new_bot - new_yoff);
}

// Look up bot sprites
var sprIdle_step = __spr("spriteBotIdle");
var sprJump_step = __spr("spriteBotJumping");
var sprFall_step = __spr("spriteBotGliding"); // falling / gliding

// ---------- TILEMAP ACCESS ----------
if (!variable_global_exists("tm_solids"))      global.tm_solids = undefined;
if (!variable_global_exists("tm_solids_name")) global.tm_solids_name = "";
if (!variable_global_exists("tm_walls"))       global.tm_walls  = undefined; // unused for now

function __ensure_tm_solids() {
    if (!is_undefined(global.tm_solids) && global.tm_solids != -1) {
        return global.tm_solids;
    }

    // Prefer a layer called "Solids"
    var lid = layer_get_id("Solids");
    if (lid != -1) {
        var elems = layer_get_all_elements(lid);
        for (var i = 0; i < array_length(elems); i++) {
            var el = elems[i];
            if (layer_get_element_type(el) == layerelementtype_tilemap) {
                global.tm_solids      = el;
                global.tm_solids_name = layer_get_name(lid);
                return el;
            }
        }
    }

    // Fallback: first tilemap in the room
    var layers = layer_get_all();
    for (var j = 0; j < array_length(layers); j++) {
        var lid2  = layers[j];
        var els   = layer_get_all_elements(lid2);
        for (var k = 0; k < array_length(els); k++) {
            var el2 = els[k];
            if (layer_get_element_type(el2) == layerelementtype_tilemap) {
                global.tm_solids      = el2;
                global.tm_solids_name = layer_get_name(lid2);
                return el2;
            }
        }
    }

    global.tm_solids      = undefined;
    global.tm_solids_name = "";
    return undefined;
}
__ensure_tm_solids();

// ---------- COLLISION HELPERS ----------
function __tile_any_solid_at(_x,_y) {
    if (!is_undefined(global.tm_solids)) {
        var _data  = tilemap_get_at_pixel(global.tm_solids, _x, _y);
        var _index = tile_get_index(_data); // -1 = no tile, 0+ = real tile
        if (_index != -1) return true;
    }
    // if you later add global.tm_walls, also check it here
    return false;
}

function __rect_hits_solid(_dx,_dy) {
    var l = bbox_left  + _dx;
    var r = bbox_right + _dx;
    var t = bbox_top   + _dy;
    var b = bbox_bottom+ _dy;

    var e      = 0.1; // inward epsilon
    var step_v = 4;
    var step_h = 4;

    // left & right edges
    var yy = t + e;
    while (yy <= b - e + 0.0001) {
        if (__tile_any_solid_at(l + e, yy)) return true;
        if (__tile_any_solid_at(r - e, yy)) return true;
        yy += step_v;
    }
    if (__tile_any_solid_at(l + e, b - e)) return true;
    if (__tile_any_solid_at(r - e, b - e)) return true;

    // top & bottom edges
    var xx = l + e;
    while (xx <= r - e + 0.0001) {
        if (__tile_any_solid_at(xx, t + e)) return true;
        if (__tile_any_solid_at(xx, b - e)) return true;
        xx += step_h;
    }
    if (__tile_any_solid_at(r - e, t + e)) return true;
    if (__tile_any_solid_at(r - e, b - e)) return true;

    return false;
}

// Ground check: use the same rect logic as vertical collision
function __on_ground_check() {
    return __rect_hits_solid(0, 1);
}

// ---------- INPUT ----------
// Keyboard fallback
var kx = (keyboard_check(vk_right) || keyboard_check(ord("D")))
       - (keyboard_check(vk_left)  || keyboard_check(ord("A")));
kx = clamp(kx, -1, 1);

var k_jump_p = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up);
var k_jump_h = keyboard_check(vk_space)         || keyboard_check(vk_up);

var move_x = kx;
var jump_p = k_jump_p;
var jump_h = k_jump_h;

// If oInput is feeding globals, let that override
if (variable_global_exists("inp_move")) {
    // Use stick/keyboard from oInput if present
    move_x = clamp(global.inp_move, -1, 1);
}
if (variable_global_exists("inp_jump_press")) {
    if (global.inp_jump_press) jump_p = true;
}
if (variable_global_exists("inp_jump_held")) {
    if (global.inp_jump_held)  jump_h = true;
}

// ---------- BASIC PHYSICS ----------
var on_ground = __on_ground_check();

// Horizontal speed
hsp = move_x * move_speed;

// Jump (only from ground)
if (on_ground && jump_p) {
    vsp = jump_speed;
    fall_speed_peak = 0;
}

// Variable gravity
var g = gravity_amt;

if (!on_ground) {
    if (vsp < 0) {
        // Going up: if we RELEASE jump, apply extra gravity so short-hops are possible
        if (!jump_h) {
            g += gravity_amt * (low_jump_multiplier - 1.0);
        }
    } else {
        // Falling: heavier gravity so falls feel snappy
        g += gravity_amt * (fall_multiplier - 1.0);
    }
}

vsp += g;
if (vsp > max_fall) vsp = max_fall;

// ---------- COLLISIONS (H) ----------
if (hsp != 0) {
    var sx = sign(hsp);
    var mx = abs(hsp);

    repeat (floor(mx)) {
        if (!__rect_hits_solid(sx, 0)) x += sx;
        else { hsp = 0; break; }
    }

    var fx = mx - floor(mx);
    if (fx > 0 && hsp != 0) {
        if (!__rect_hits_solid(sx * fx, 0)) x += sx * fx;
        else hsp = 0;
    }
}

// ---------- COLLISIONS (V) ----------
if (vsp != 0) {
    var sy = sign(vsp);
    var my = abs(vsp);

    repeat (floor(my)) {
        if (!__rect_hits_solid(0, sy)) y += sy;
        else { vsp = 0; break; }
    }

    var fy = my - floor(my);
    if (fy > 0 && vsp != 0) {
        if (!__rect_hits_solid(0, sy * fy)) y += sy * fy;
        else vsp = 0;
    }
}

// Track peak downward speed (for future landing dust, etc.)
if (!__on_ground_check() && vsp > 0) {
    if (vsp > fall_speed_peak) fall_speed_peak = vsp;
}

// ---------- ANIMATION ----------
on_ground = __on_ground_check();

if (!on_ground) {
    if (vsp < 0) {
        if (sprJump_step != -1) { __set_sprite_keep_feet(sprJump_step, 0.3); state = "jump"; }
        else state = "jump";
    } else {
        if (sprFall_step != -1) { __set_sprite_keep_feet(sprFall_step, 0.3); state = "fall"; }
        else state = "fall";
    }
} else {
    if (abs(move_x) > 0.001) {
        if (sprIdle_step != -1) { __set_sprite_keep_feet(sprIdle_step, 0.4); state = "move"; }
        else state = "move";
    } else {
        if (sprIdle_step != -1) { __set_sprite_keep_feet(sprIdle_step, 0.4); state = "idle"; }
        else state = "idle";
    }
}

// Face movement direction
if (abs(move_x) > 0.001) {
    image_xscale = (move_x > 0) ? 1 : -1;
}
