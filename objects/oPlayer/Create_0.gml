/// oPlayer — Create

// --------- Movement config ---------
gravity_amt = 0.25;
max_fall    = 8.0;

// Jump impulse (Jump King style)
jump_v_base = -4.0;  // vertical (up). more negative = higher
jump_h_base =  4.0;  // horizontal (forward)

// Physics state
hsp = 0;
vsp = 0;

// Facing / state
state  = "idle";
facing = 1;

// --- HP (used by DeathMenu etc.) ---
max_hp = 1;
hp     = max_hp;

// --------- Jump charge ---------
jump_charge_frame_steps = 6;
jump_charge       = 0;
jump_charge_level = 0;
jump_charging     = false;
prev_jump_h       = false;

// Landing detection
prev_on_ground = false;

// ✅ Ground-stick stability (prevents tiny platforms flicker / landing reset loop)
ground_stick_max = 4; // frames of "sticky ground" (3–6 is fine)
ground_stick     = 0;

// Variable-jump feel
low_jump_multiplier = 1.7;
fall_multiplier    = 1.4;

// --------- Bounce-on-landing (HARD MODE) ---------
bounce_enabled      = true;
bounce_threshold    = 2.0;
bounce_mult         = 0.55;
bounce_min          = 2.0;
bounce_max          = 6.0;
bounce_pause_frames = 1;
bounce_h_damp       = 0.65;

bounce_pending = false;
bounce_timer   = 0;
bounce_v       = 0;

// --------- Wall hit (BONK) ---------
wallhit_enabled          = true;
wallhit_threshold        = 3.5;
wallhit_cooldown_frames  = 10;
wallhit_cd               = 0;

wallhit_hold_seconds = 0.4;
wallhit_timer        = 0;

// Visual
sprite_index = spriteBotIdle;
image_speed  = 0.2;
image_xscale = 1;


// --------- Tilemap collision wiring (STRICT: "Solids" tile layer ONLY) ---------
if (!variable_global_exists("tm_solids"))      global.tm_solids = undefined;
if (!variable_global_exists("tm_solids_room")) global.tm_solids_room = -1;

ensure_tm_solids = function() {
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
};

tile_any_solid_at = function(_x, _y) {
    ensure_tm_solids();
    if (is_undefined(global.tm_solids) || global.tm_solids == -1) return false;

    var _data = tilemap_get_at_pixel(global.tm_solids, _x, _y);
    return (_data != 0);
};

rect_hits_solid = function(_dx, _dy) {
    var l = bbox_left   + _dx;
    var r = bbox_right  + _dx;
    var t = bbox_top    + _dy;
    var b = bbox_bottom + _dy;

    var e      = 0.1;
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
};

// FEET-ONLY ground check (stable near walls/ledges) + never while rising
on_ground_check = function() {
    if (vsp < 0) return false;

    var ytest = bbox_bottom + 1;

    // sample more points for tiny platforms
    var inset = 2;
    var l = bbox_left  + inset;
    var r = bbox_right - inset;

    // if the bbox is narrow, ensure l <= r
    if (l > r) { l = (bbox_left + bbox_right) * 0.5; r = l; }

    var m1 = lerp(l, r, 0.25);
    var m2 = lerp(l, r, 0.50);
    var m3 = lerp(l, r, 0.75);

    if (tile_any_solid_at(l,  ytest)) return true;
    if (tile_any_solid_at(m1, ytest)) return true;
    if (tile_any_solid_at(m2, ytest)) return true;
    if (tile_any_solid_at(m3, ytest)) return true;
    if (tile_any_solid_at(r,  ytest)) return true;

    return false;
};

ensure_tm_solids();


// --------- Spawn bird companion ---------
bird = instance_create_layer(x, y, "Instances", oBirdCompanion);
if (instance_exists(bird)) bird.owner = id;
