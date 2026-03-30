depth = 0;

// --------- Movement config ---------
gravity_amt = 0.25;
max_fall    = 8.0;

// Jump impulse (Jump King style)
jump_v_base = -4.0;
jump_h_base =  4.0;

// Physics state
hsp = 0;
vsp = 0;

// Facing / state
state  = "idle";
facing = 1;

// --- HP ---
max_hp = 1;
hp     = max_hp;

// --------- Jump charge ---------
jump_charge_frame_steps = 6;
jump_charge       = 0;
jump_charge_level = 0;
jump_charging     = false;
prev_jump_h       = false;

// ★ Charge stability ★
charge_support_min = 1;  // allow edge starts again
charge_grace_max   = 5;  // grace while charging
charge_grace       = 0;

// lock charge for first few frames to prevent edge flicker cancel
charge_start_lock_max = 2;
charge_start_lock     = 0;

// Landing detection
prev_on_ground = false;

// Ground-stick stability
ground_stick_max = 4;
ground_stick     = 0;

// NEW: grounded stability buffer (prevents ledge-tip flicker loops)
ground_min_frames = 3;
ground_frames     = 0;

// Variable-jump feel
low_jump_multiplier = 1.7;
fall_multiplier    = 1.4;

// --------- Bounce-on-landing ----------
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

// --------- Wall hit (overlay timer) ----------
wallhit_enabled          = true;
wallhit_threshold        = 3.5;
wallhit_cooldown_frames  = 10;
wallhit_cd               = 0;

wallhit_hold_seconds     = 0.40;
wallhit_timer            = 0;

// --------- Wall bounce ----------
wallbounce_enabled    = true;
wallbounce_threshold  = 2.8;
wallbounce_mult       = 0.60;
wallbounce_min_h      = 1.5;
wallbounce_upkick     = 0.15;
wallbounce_cd_frames  = 3;
wallbounce_cd         = 0;

// Visual
sprite_index = spriteBotIdle;
image_speed  = 0.2;
image_xscale = 1;

// --------- Edge-charge anti-stuck ----------
edge_charge_fail_max = 2; // frames of "no real support" before cancel
edge_charge_fail     = 0;

// --------- Death fall flag ----------
death_fall = false;


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

// UPDATED: treat instance platforms (oSolidDyn children) as solids too
// PLUS: hazards that opt-in with `solid_body = true` are treated as solids (eg. smashers)
tile_any_solid_at = function(_x, _y) {

    // Normal dynamic solids
    if (instance_position(_x, _y, oSolidDyn) != noone) return true;

    // Hazard solids (opt-in)
    var hz = instance_position(_x, _y, oHazard);
    if (hz != noone) {

        // must be enabled (or missing flag)
        if (!variable_instance_exists(hz, "enabled") || hz.enabled) {

            // must opt-in to being solid
            if (variable_instance_exists(hz, "solid_body") && hz.solid_body) {

                // OPTIONAL: only solid when active (prevents blocking when plate is up)
                var only_active = (variable_instance_exists(hz, "solid_only_when_active") &&
                                   hz.solid_only_when_active);

                if (!only_active) {
                    return true;
                } else {
                    // if only-active, it must have active==true
                    if (variable_instance_exists(hz, "active") && hz.active) {
                        return true;
                    }
                }
            }
        }
    }

    // Tilemap solids
    ensure_tm_solids();
    if (is_undefined(global.tm_solids) || global.tm_solids == -1) return false;
    return (tilemap_get_at_pixel(global.tm_solids, _x, _y) != 0);
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

on_ground_check = function() {
    if (vsp < 0) return false;

    var ytest = bbox_bottom + 1;

    var inset = 2;
    var l = bbox_left  + inset;
    var r = bbox_right - inset;

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

// --------- Death handling ----------
death_timer_max = ceil(room_speed * 0.35); // 0.35s pause on death
death_timer     = 0;