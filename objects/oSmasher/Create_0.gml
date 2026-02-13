/// oSmasher — Create (FULL)
event_inherited();

enabled = true;

// hard lock position (sprite anim supplies motion)
base_x = x;
base_y = y;

sprite_index = spriteHazardSmasher;
image_speed  = 0.33;

debug_draw = false;

// MUST be TRUE so player treats it as a blocker
solid_body = true;

// Active (killing) frames
use_active_frames = true;
active_from = 6;
active_to   = 11;

kill_band_h = 8;
sink_px     = 6;
kill_only_when_falling = false;

// Masks:
// - BODY ONLY (always blocks)  -> spriteSmasherMaskSolid
// - BODY+PLATE (blocks when down) -> spriteSmasherMask
mask_body   = spriteSmasherMaskSolid;
mask_full   = spriteSmasherMask;

// Start with body-only mask
mask_index  = mask_body;

solid_only_when_active = true;
