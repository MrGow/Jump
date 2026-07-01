/// oChipBankPopup — Step

timer++;

// Fade
if (timer < 12) {
    alpha = timer / 12;
} else if (timer > timer_max - 24) {
    alpha = clamp((timer_max - timer) / 24, 0, 1);
} else {
    alpha = 1;
}

// Main entrance scale settles down
var settle = clamp(timer / 14, 0, 1);
scale = lerp(1.6, 1.0, settle);

// Count changes after short pause
if (!count_done && timer >= count_delay) {
    display_count = to_count;
    count_done = true;
    number_pop_timer = 14;

    if (snd_chip_bank != -1) {
        scr_play_sfx(snd_chip_bank, chip_bank_gain, random_range(0.98, 1.02));
    }
}

if (number_pop_timer > 0) {
    number_pop_timer--;
}

if (timer >= timer_max) {
    instance_destroy();
}