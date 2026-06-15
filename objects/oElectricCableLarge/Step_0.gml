/// oElectricCableLarge — Step

if (!enabled) exit;

// Keep angle clean even if rotated in room editor
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

var fr = floor(image_index);
active = (fr >= active_from && fr <= active_to);

// Keep solid base attached
if (instance_exists(solid_inst))
{
    solid_inst.x = x;
    solid_inst.y = y;
    solid_inst.image_angle = image_angle;
}