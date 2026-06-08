/// oSpringPlatformAngular — Step

if (!enabled) exit;

active = true;

// Auto-read flipped sprite direction unless manually overridden
if (!variable_instance_exists(id, "wall_dir")) {
    wall_dir = (image_xscale >= 0) ? 1 : -1;
}

// Press/recover animation
if (pressed_timer > 0) {
    pressed_timer--;

    if (image_number > 1) {
        var phase = 1 - (pressed_timer / max(1, pressed_frames));
        var ping  = 1 - abs(phase * 2 - 1);
        image_index = round(ping * (image_number - 1));
    } else {
        image_index = 0;
    }
}
else {
    image_index = 0;
}