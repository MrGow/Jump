/// oSpringPlatform — Step

if (!enabled) exit;

// Keep inherited-style flags sane
active = true;

// Keep floor-surface data updated
surface_inset_left  = top_inset;
surface_inset_right = top_inset;
surface_y           = bbox_top + surface_y_offset;
dx = 0;
dy = 0;

// ----------------------------------------------------
// Simple press/recover animation
// ----------------------------------------------------
if (pressed_timer > 0) {
    pressed_timer--;

    if (image_number > 1) {
        var phase = 1 - (pressed_timer / max(1, pressed_frames)); // 0..1
        var ping  = 1 - abs(phase * 2 - 1);                       // 0..1..0
        image_index = round(ping * (image_number - 1));
    } else {
        image_index = 0;
    }
}
else {
    image_index = 0;
}

if (instance_exists(solid_inst))
{
    solid_inst.x = x;
    solid_inst.y = y;
    solid_inst.image_angle = image_angle;
    solid_inst.enabled = enabled;
    solid_inst.active = active;
}