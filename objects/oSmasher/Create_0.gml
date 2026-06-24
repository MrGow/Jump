/// oSmasher — Create

event_inherited();

enabled = true;

base_x = x;
base_y = y;

// Child/instance overrides
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

debug_draw = false;

solid_body = true;

use_active_frames = true;
active_from = 6;
active_to   = 11;

kill_band_h = 8;
sink_px     = 6;
kill_only_when_falling = false;

mask_body = mask_body_override;
mask_full = mask_full_override;
mask_index = mask_body;

solid_only_when_active = false;

// SFX
snd_smasher_down      = asset_get_index("SmasherDown1");
snd_smasher_lift      = asset_get_index("SmasherLift1");
snd_smasher_floor_hit = asset_get_index("SmasherFloorHit1");

smasher_down_gain      = 0.55;
smasher_lift_gain      = 0.35;
smasher_floor_hit_gain = 0.80;

smasher_cycle_started = false;
smasher_player_hit_sfx_lock = false;

smasher_sfx_inner_dist = 250;
smasher_sfx_outer_dist = 400;

// Animation
if (!variable_instance_exists(id, "smasher_anim_speed")) {
    smasher_anim_speed = 0.33;
}

if (!variable_instance_exists(id, "smasher_pause_s")) {
    smasher_pause_s = 1.0;
}

smasher_pause_frames = round(room_speed * clamp(smasher_pause_s, 0, 7));
smasher_pause_timer  = smasher_pause_frames;

active = false;