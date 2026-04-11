/// oElectricCable — Create
event_inherited();

enabled = true;
active  = true;

// Not solid: this is a kill hazard only
solid_body = false;
solid_only_when_active = false;

// Sprite
sprite_index = spriteHazardElectricCable;
image_speed  = 0.35;

// ----------------------------------------------------
// Orientation
// Use image_angle in 90-degree steps:
//   0   = floor-mounted, electricity points upward
//   90  = left wall-mounted, electricity points right
//   180 = ceiling-mounted, electricity points downward
//   270 = right wall-mounted, electricity points left
// ----------------------------------------------------
image_angle = round(image_angle / 90) * 90;

// ----------------------------------------------------
// Hurtbox tuning (for default floor/up orientation)
// These are LOCAL offsets from the object origin.
// They describe the yellow electrical part only.
// ----------------------------------------------------
hurt_left   = -8;
hurt_right  =  8;
hurt_top    = -22;
hurt_bottom = -4;

// Optional small shrink so edges feel fairer
hurt_inset = 1;

// Debug
debug_draw = false;

// Safety: short per-player hit lock
player_hit_lock_frames = 6;