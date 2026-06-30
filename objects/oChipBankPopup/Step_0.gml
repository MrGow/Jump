/// oChipBankPopup — Step

timer++;

if (timer < 12) {
    alpha = timer / 12;
} else if (timer > timer_max - 20) {
    alpha = clamp((timer_max - timer) / 20, 0, 1);
} else {
    alpha = 1;
}

scale = 1 + sin(timer * 0.25) * 0.035;

if (!count_done && timer >= count_delay) {
    display_count = to_count;
    count_done = true;

    if (snd_chip_bank != -1) {
        scr_play_sfx(snd_chip_bank, chip_bank_gain, random_range(0.98, 1.02));
    }
}

if (timer >= timer_max) {
    instance_destroy();
}