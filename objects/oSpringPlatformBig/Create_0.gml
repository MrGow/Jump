/// oSpringPlatformBig — Create

event_inherited();

sprite_index = spriteHazardBouncePadLarge;
mask_index   = spriteSpringPlatformBigSolidMask;

enabled = true;
active  = true;

// The visible spring itself is handled as a floor surface.
// The separate oSpringPlatformBigSolid instance handles full body collision.
solid_body = false;
solid_only_when_active = false;

image_speed = 1;
image_index = 0;

// ----------------------------------------------------
// Bounce size tuning
// Editor variable: bounce_size = "small", "medium", "large"
// ----------------------------------------------------
if (!variable_instance_exists(id, "bounce_size"))
{
    bounce_size = "medium";
}

if (bounce_size == "small")
{
    spring_power      = 9;
    spring_h_mult     = 1.0;
    spring_min_h_kick = 1.2;
    spring_max_h_kick = 2.4;
}
else if (bounce_size == "large")
{
    spring_power      = 16;
    spring_h_mult     = 1.0;
    spring_min_h_kick = 2.5;
    spring_max_h_kick = 4.5;
}
else
{
    spring_power      = 12;
    spring_h_mult     = 1.0;
    spring_min_h_kick = 1.8;
    spring_max_h_kick = 3.25;
}

// ----------------------------------------------------
// Standing surface tuning
// ----------------------------------------------------
top_inset        = -2;
surface_y_offset = 1;
surface_x_offset = 0;
min_overlap_px   = 6;
edge_bias_px     = 3;

player_retrigger_lock_frames = 4;

surface_inset_left  = top_inset;
surface_inset_right = top_inset;
surface_y           = bbox_top + surface_y_offset;

dx = 0;
dy = 0;

// ----------------------------------------------------
// Animation
// ----------------------------------------------------
pressed_frames = 8;
pressed_timer  = 0;

// ----------------------------------------------------
// Solid helper
// ----------------------------------------------------
solid_inst = noone;

// Change these only if the solid mask origin does not match
// the visible sprite origin.
solid_offset_x = 0;
solid_offset_y = 0;

// Set true while testing.
debug_draw = true;

solid_inst = instance_create_layer(
    x + solid_offset_x,
    y + solid_offset_y,
    "Instances",
    oSpringPlatformBigSolid
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