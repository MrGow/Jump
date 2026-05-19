/// oElectricCable — Step

enabled = true;
active  = true;

// Keep angle clean even if rotated in room editor
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;