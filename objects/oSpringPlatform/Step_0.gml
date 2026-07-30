/// oSpringPlatform — Step

// ----------------------------------------------------
// Hot-reload safety
// ----------------------------------------------------
if (!variable_instance_exists(id, "snd_bounce_small"))
{
    snd_bounce_small = asset_get_index("SmallBouncePad1");
}

if (!variable_instance_exists(id, "bounce_sfx_gain"))
{
    bounce_sfx_gain = 0.55;
}

if (!variable_instance_exists(id, "spring_push_direction"))
{
    spring_push_direction = "right";
}

if (!variable_instance_exists(id, "spring_push_power"))
{
    spring_push_power = 5;
}

if (!variable_instance_exists(id, "spring_push_speed_min"))
{
    spring_push_speed_min = 1.5;
}

if (!variable_instance_exists(id, "spring_push_speed_max"))
{
    spring_push_speed_max = 8;
}

if (!variable_instance_exists(id, "solid_offset_x"))
{
    solid_offset_x = 0;
}

if (!variable_instance_exists(id, "solid_offset_y"))
{
    solid_offset_y = 0;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

// ----------------------------------------------------
// Disabled state
// ----------------------------------------------------
if (!enabled)
{
    active = false;

    if (instance_exists(solid_inst))
    {
        solid_inst.enabled = false;
        solid_inst.active  = false;
    }

    exit;
}

active = true;

// ----------------------------------------------------
// Keep floor-surface data updated
// ----------------------------------------------------
surface_inset_left  = top_inset;
surface_inset_right = top_inset;
surface_y           = bbox_top + surface_y_offset;

dx = 0;
dy = 0;

// ----------------------------------------------------
// Press/recover animation
// ----------------------------------------------------
if (pressed_timer > 0)
{
    pressed_timer--;

    if (image_number > 1)
    {
        var phase =
            1 -
            (pressed_timer / max(1, pressed_frames));

        var ping =
            1 -
            abs(phase * 2 - 1);

        image_index =
            round(ping * (image_number - 1));
    }
    else
    {
        image_index = 0;
    }
}
else
{
    image_index = 0;
}

// ----------------------------------------------------
// Recreate side collision helper if necessary
// ----------------------------------------------------
if (!instance_exists(solid_inst))
{
    solid_inst = instance_create_layer(
        x + solid_offset_x,
        y + solid_offset_y,
        "Instances",
        oSpringPlatformSolid
    );

    if (instance_exists(solid_inst))
    {
        solid_inst.owner = id;
    }
}

// ----------------------------------------------------
// Synchronise side collision helper
// ----------------------------------------------------
if (instance_exists(solid_inst))
{
    solid_inst.x = x + solid_offset_x;
    solid_inst.y = y + solid_offset_y;

    solid_inst.image_xscale = image_xscale;
    solid_inst.image_yscale = image_yscale;
    solid_inst.image_angle  = image_angle;

    solid_inst.enabled    = enabled;
    solid_inst.active     = active;
    solid_inst.debug_draw = debug_draw;
}