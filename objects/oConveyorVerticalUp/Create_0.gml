/// oConveyorVerticalUp — Create

event_inherited();

sprite_index = spriteArea2ConveyorMagneticUp;
mask_index   = spriteArea2ConveyorMagneticUp;

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;

image_speed = 1;
image_index = 0;

// ----------------------------------------------------
// Editor tuning
// ----------------------------------------------------
if (!variable_instance_exists(id, "magnet_speed"))  magnet_speed  = 3.0;
if (!variable_instance_exists(id, "fling_power"))   fling_power   = 8.5;
if (!variable_instance_exists(id, "snap_x_offset")) snap_x_offset = 0;

// Hit/attach area
if (!variable_instance_exists(id, "attach_pad_x")) attach_pad_x = 6;
if (!variable_instance_exists(id, "top_release_pad")) top_release_pad = 8;

player_lock = noone;

debug_draw = false;