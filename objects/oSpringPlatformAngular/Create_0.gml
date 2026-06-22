/// oSpringPlatformAngular — Create

event_inherited();

sprite_index = spriteHazardBouncePadWall;
mask_index   = spriteHazardBouncePadWall;

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;

image_speed = 1;
image_index = 0;

// Bounce SFX
snd_bounce_small = asset_get_index("SmallBouncePad1");
bounce_sfx_gain = 0.55;

// Editor variables:
// wall_dir = 1  launches up/right
// wall_dir = -1 launches up/left
if (!variable_instance_exists(id, "wall_dir")) wall_dir = 1;

// bounce_size = "small", "medium", "large"
if (!variable_instance_exists(id, "bounce_size")) bounce_size = "medium";

if (bounce_size == "small")
{
    angular_h_power = 3.5;
    angular_v_power = 8.5;
}
else if (bounce_size == "large")
{
    angular_h_power = 7.0;
    angular_v_power = 13.5;
}
else
{
    angular_h_power = 5.25;
    angular_v_power = 10.5;
}

player_retrigger_lock_frames = 8;

pressed_frames = 8;
pressed_timer  = 0;

debug_draw = false;