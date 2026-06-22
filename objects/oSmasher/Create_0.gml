/// oSmasher — Create

event_inherited();

enabled = true;

base_x = x;
base_y = y;

sprite_index = spriteHazardSmasherLength1Width1;
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

mask_body = spriteSmasherMaskSolid;
mask_full = spriteSmasherMask;

mask_index = mask_body;

solid_only_when_active = false;

// SFX
snd_smasher_down      = asset_get_index("SmasherDown1");
snd_smasher_lift      = asset_get_index("SmasherLift1");
snd_smasher_floor_hit = asset_get_index("SmasherFloorHit1");

smasher_down_gain      = 0.55;
smasher_lift_gain      = 0.35;
smasher_floor_hit_gain = 0.80;

smasher_sfx_was_active = false;
smasher_sfx_was_moving = false;
smasher_player_hit_sfx_lock = false;

// Animation
if (!variable_instance_exists(id, "smasher_anim_speed")) smasher_anim_speed = 0.33;

// Editor variable: pause before smash
// 0 = no pause, 1-7 = seconds paused while raised
if (!variable_instance_exists(id, "smasher_pause_s")) smasher_pause_s = 1.0;

smasher_pause_frames = round(room_speed * clamp(smasher_pause_s, 0, 7));
smasher_pause_timer  = smasher_pause_frames;

active = false;