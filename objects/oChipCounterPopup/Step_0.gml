/// oChipCounterPopup — Step

if (global.chips_carried > 0) {
    // Stay visible while carrying chips
    timer = timer_max;
    alpha = 1;
} else {
    timer--;
    alpha = clamp(timer / 20, 0, 1);

    if (timer <= 0) {
        instance_destroy();
    }
}