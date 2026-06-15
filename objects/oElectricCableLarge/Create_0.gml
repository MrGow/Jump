/// oElectricCableLarge — Create

event_inherited();

sprite_index = spriteHazardElectricCableLarge;
mask_index   = spriteHazardElectricCableLargeMask;

enabled = true;
active  = false;

solid_body = false;
solid_only_when_active = false;

image_speed = 0.35;
image_index = 0;

// Snap to 90-degree angle
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

// Dangerous frames
if (!variable_instance_exists(id, "active_from")) active_from = 6;
if (!variable_instance_exists(id, "active_to"))   active_to   = 13;

player_hit_lock_frames = 6;

debug_draw = false;

// ----------------------------------------------------
// Spawn physical cable collision
// ----------------------------------------------------
solid_inst = instance_create_layer(
    x,
    y,
    layer,
    oElectricCableLargeSolid
);

solid_inst.image_angle = image_angle;