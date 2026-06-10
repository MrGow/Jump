/// oAreaTitleDisplay — Step

timer++;

var len = string_length(area_name);

if (state == "typing") {
    alpha = min(1, alpha + 0.08);

    shown_chars = min(len, floor(timer / type_speed));

    if (shown_chars >= len) {
        state = "hold";
        timer = 0;
    }
}
else if (state == "hold") {
    alpha = 1;

    if (timer >= hold_time) {
        state = "fade";
        timer = 0;
    }
}
else if (state == "fade") {
    alpha = 1 - clamp(timer / fade_time, 0, 1);

    if (alpha <= 0) {
        instance_destroy();
    }
}