/// oSpringPlatformAngular — Step

if (!enabled) exit;

// Hot-reload safety
if (!variable_instance_exists(id, "snd_bounce_small")) snd_bounce_small = asset_get_index("SmallBouncePad1");
if (!variable_instance_exists(id, "bounce_sfx_gain")) bounce_sfx_gain = 0.55;

active = true;

if (pressed_timer > 0)
{
    pressed_timer--;

    if (image_number > 1)
    {
        var phase = 1 - (pressed_timer / max(1, pressed_frames));
        var ping  = 1 - abs(phase * 2 - 1);
        image_index = round(ping * (image_number - 1));
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