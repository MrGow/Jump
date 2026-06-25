/// oElectricCableLarge — Create

event_inherited();

sprite_index = spriteHazardElectricCableLarge;
mask_index   = spriteHazardElectricCableLargeMask;

enabled = true;
active  = false;

solid_body = false;
solid_only_when_active = false;

cable_anim_speed = 0.35;
image_speed = cable_anim_speed;
image_index = 0;

// Snap to 90-degree angle
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

// Dangerous frames
if (!variable_instance_exists(id, "active_from")) active_from = 6;
if (!variable_instance_exists(id, "active_to"))   active_to   = 16;

player_hit_lock_frames = 6;

debug_draw = false;

// Electric loop SFX
snd_electric_loop = asset_get_index("LargeElectricCableSound");
electric_loop_instance = noone;
electric_loop_gain = 0.35;
electric_loop_pitch = 1.0;

electric_loop_inner_dist = 90;
electric_loop_outer_dist = 320;

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