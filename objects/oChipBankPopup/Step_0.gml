/// oChipBankPopup — Step

timer++;


// ----------------------------------------------------
// Fade
// ----------------------------------------------------

if (timer < 12)
{
    alpha =
        timer / 12;
}
else if (timer > timer_max - 24)
{
    alpha =
        clamp(
            (
                timer_max -
                timer
            )
            /
            24,
            0,
            1
        );
}
else
{
    alpha = 1;
}


// ----------------------------------------------------
// Main entrance scale settles down
// ----------------------------------------------------

var settle =
    clamp(
        timer / 14,
        0,
        1
    );

scale =
    lerp(
        1.6,
        1.0,
        settle
    );


// ====================================================
// COUNT CHANGES AFTER SHORT PAUSE
// ====================================================

if (
    !count_done &&
    timer >= count_delay
)
{
    display_count =
        to_count;

    count_done = true;

    number_pop_timer = 14;


    // ----------------------------------------------------
    // Bank sound
    // ----------------------------------------------------

    if (snd_chip_bank != -1)
    {
        scr_play_sfx(
            snd_chip_bank,
            chip_bank_gain,
            random_range(
                0.98,
                1.02
            )
        );
    }


    // ====================================================
    // CHIP BANK RUMBLE
    //
    // More substantial than pickup because this is when
    // the collectible becomes permanent.
    //
    // Banking several chips together produces a slightly
    // stronger pulse, but remains deliberately restrained.
    // ====================================================

    var chips_banked =
        max(
            1,
            to_count -
            from_count
        );

    var bank_amount_fraction =
        clamp(
            (
                chips_banked -
                1
            )
            /
            4,
            0,
            1
        );

    var bank_rumble_low =
        lerp(
            0.17,
            0.27,
            bank_amount_fraction
        );

    var bank_rumble_high =
        lerp(
            0.15,
            0.20,
            bank_amount_fraction
        );

    var bank_rumble_frames =
        round(
            lerp(
                5,
                7,
                bank_amount_fraction
            )
        );


    scr_rumble_play(
        bank_rumble_low,
        bank_rumble_high,
        bank_rumble_frames,
        false
    );
}


// ----------------------------------------------------
// Number pop timer
// ----------------------------------------------------

if (number_pop_timer > 0)
{
    number_pop_timer--;
}


// ----------------------------------------------------
// End popup
// ----------------------------------------------------

if (timer >= timer_max)
{
    instance_destroy();
}