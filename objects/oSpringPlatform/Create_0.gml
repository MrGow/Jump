/// oSpringPlatform — Create

event_inherited();

sprite_index = spriteHazardBouncePad;
mask_index   = spriteSpringPlatformMask;

enabled = true;
active  = true;

// The visible spring provides the top standing surface.
// oSpringPlatformSolid provides side/base collision.
solid_body = false;
solid_only_when_active = false;

image_speed = 1;
image_index = 0;

// ----------------------------------------------------
// Bounce SFX
// ----------------------------------------------------
snd_bounce_small = asset_get_index("SmallBouncePad1");
bounce_sfx_gain  = 0.55;

// ----------------------------------------------------
// Vertical bounce size
//
// Editor variable:
// bounce_size = "small", "medium", or "large"
// ----------------------------------------------------
if (!variable_instance_exists(id, "bounce_size"))
{
    bounce_size = "medium";
}

if (bounce_size == "small")
{
    spring_power = 9;
}
else if (bounce_size == "large")
{
    spring_power = 16;
}
else
{
    spring_power = 12;
}

// ----------------------------------------------------
// Forced horizontal push
//
// spring_push_direction:
// "left" or "right"
//
// spring_push_power:
// 1  = very weak
// 10 = extremely strong
// ----------------------------------------------------
if (!variable_instance_exists(id, "spring_push_direction"))
{
    spring_push_direction = "right";
}

if (!variable_instance_exists(id, "spring_push_power"))
{
    spring_push_power = 5;
}

// The horizontal speeds represented by power 1 and power 10.
if (!variable_instance_exists(id, "spring_push_speed_min"))
{
    spring_push_speed_min = 1.5;
}

if (!variable_instance_exists(id, "spring_push_speed_max"))
{
    spring_push_speed_max = 8;
}

// ----------------------------------------------------
// Top surface tuning
// ----------------------------------------------------
top_inset        = -2;
surface_y_offset = 1;
surface_x_offset = 0;
min_overlap_px   = 5.5;

player_retrigger_lock_frames = 4;

surface_inset_left  = top_inset;
surface_inset_right = top_inset;
surface_y           = bbox_top + surface_y_offset;

dx = 0;
dy = 0;

// ----------------------------------------------------
// Press animation
// ----------------------------------------------------
pressed_frames = 8;
pressed_timer  = 0;

// ----------------------------------------------------
// Debug
// ----------------------------------------------------
debug_draw = false;

// ----------------------------------------------------
// Separate side/base collision
// ----------------------------------------------------
solid_offset_x = 0;
solid_offset_y = 0;

solid_inst = instance_create_layer(
    x + solid_offset_x,
    y + solid_offset_y,
    "Instances",
    oSpringPlatformSolid
);

if (instance_exists(solid_inst))
{
    solid_inst.owner = id;

    solid_inst.x = x + solid_offset_x;
    solid_inst.y = y + solid_offset_y;

    solid_inst.image_xscale = image_xscale;
    solid_inst.image_yscale = image_yscale;
    solid_inst.image_angle  = image_angle;

    solid_inst.enabled    = enabled;
    solid_inst.active     = active;
    solid_inst.debug_draw = debug_draw;
}