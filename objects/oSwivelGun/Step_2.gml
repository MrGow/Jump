/// oSwivelGun — End Step

if (scr_game_frozen()) exit;
if (!enabled) exit;

// ----------------------------------------------------
// Patrol scan
// ----------------------------------------------------
if (state == "patrol")
{
    var may_detect_player =
        respawn_safe_timer <= 0;

    update_beam(
        may_detect_player,
        scan_hit_pad
    );

    if (
        may_detect_player &&
        beam_hit_player != noone
    )
    {
        alert_target =
            beam_hit_player;

        alert_start_angle =
            beam_angle;

        alert_elapsed = 0;

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
// Alert beam
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
// Lethal firing beam
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

// No beam in cooldown.
laser_len = 0;