/// oSmasher — Create

event_inherited();

enabled = true;

base_x = x;
base_y = y;

// ----------------------------------------------------
// Child/instance overrides
// ----------------------------------------------------
if (!variable_instance_exists(id, "smasher_sprite")) {
    smasher_sprite = spriteHazardSmasherLength1Width1;
}

if (!variable_instance_exists(id, "mask_body_override")) {
    mask_body_override = spriteSmasherMaskSolid;
}

if (!variable_instance_exists(id, "mask_full_override")) {
    mask_full_override = spriteSmasherMask;
}

sprite_index = smasher_sprite;
image_speed  = 0;
image_index  = 0;

if (!variable_instance_exists(id, "debug_draw")) {
    debug_draw = false;
}

solid_body = true;
solid_only_when_active = false;

// ----------------------------------------------------
// Collision / active timing
// Children can override these before event_inherited()
// ----------------------------------------------------
if (!variable_instance_exists(id, "use_active_frames")) {
    use_active_frames = true;
}

if (!variable_instance_exists(id, "active_from")) {
    active_from = 6;
}

if (!variable_instance_exists(id, "active_to")) {
    active_to = 11;
}

if (!variable_instance_exists(id, "kill_band_h")) {
    kill_band_h = 8;
}

if (!variable_instance_exists(id, "sink_px")) {
    sink_px = 6;
}

if (!variable_instance_exists(id, "kill_only_when_falling")) {
    kill_only_when_falling = false;
}

mask_body = mask_body_override;
mask_full = mask_full_override;
mask_index = mask_body;

// ----------------------------------------------------
// SFX
// ----------------------------------------------------
if (!variable_instance_exists(id, "snd_smasher_down")) {
    snd_smasher_down = asset_get_index("SmasherDown1");
}

if (!variable_instance_exists(id, "snd_smasher_lift")) {
    snd_smasher_lift = asset_get_index("SmasherLift1");
}

if (!variable_instance_exists(id, "snd_smasher_floor_hit")) {
    snd_smasher_floor_hit = asset_get_index("SmasherFloorHit1");
}

if (!variable_instance_exists(id, "smasher_down_gain")) {
    smasher_down_gain = 0.55;
}

if (!variable_instance_exists(id, "smasher_lift_gain")) {
    smasher_lift_gain = 0.35;
}

if (!variable_instance_exists(id, "smasher_floor_hit_gain")) {
    smasher_floor_hit_gain = 0.80;
}

smasher_cycle_started = false;
smasher_floor_sfx_played = false;
smasher_lift_sfx_played = false;
smasher_player_hit_sfx_lock = false;

if (!variable_instance_exists(id, "smasher_sfx_inner_dist")) {
    smasher_sfx_inner_dist = 250;
}

if (!variable_instance_exists(id, "smasher_sfx_outer_dist")) {
    smasher_sfx_outer_dist = 400;
}

// ----------------------------------------------------
// Animation
// ----------------------------------------------------
if (!variable_instance_exists(id, "smasher_anim_speed")) {
    smasher_anim_speed = 0.33;
}

if (!variable_instance_exists(id, "smasher_pause_s")) {
    smasher_pause_s = 1.0;
}

smasher_pause_frames = round(room_speed * clamp(smasher_pause_s, 0, 7));
smasher_pause_timer  = smasher_pause_frames;

active = false;