/// oSwivelGun — End Step

if (scr_game_frozen())
{
    exit;
}

if (!enabled)
{
    exit;
}

// ----------------------------------------------------
// Green detection beam
// ----------------------------------------------------
if (state == "patrol")
{
    update_beam(
        true,
        scan_hit_pad
    );

    if (beam_hit_player != noone)
    {
        // Lock at the current beam angle.
        state = "alert";
        state_timer = alert_frames;

        play_dist_sfx(
            snd_alert,
            alert_gain,
            random_range(
                0.98,
                1.02
            )
        );
    }

    exit;
}

// ----------------------------------------------------
// Locked warning beam
// ----------------------------------------------------
if (state == "alert")
{
    update_beam(
        false,
        scan_hit_pad
    );

    exit;
}

// ----------------------------------------------------
// Red lethal firing beam
// ----------------------------------------------------
if (state == "firing")
{
    update_beam(
        beam_lethal,
        fire_hit_pad
    );

    if (
        beam_lethal &&
        beam_hit_player != noone
    )
    {
        with (beam_hit_player)
        {
            scr_player_died();
        }
    }

    exit;
}

// No beam during cooldown.
laser_len = 0;