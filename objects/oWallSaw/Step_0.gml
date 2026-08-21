// ============================================================================
// oWallSaw — Step
// ============================================================================

/// oWallSaw — Step

if (!enabled)
{
    active = false;
    image_speed = 0;
    stop_saw_audio();
    exit;
}

active = true;

if (scr_game_frozen())
{
    image_speed = 0;
    stop_saw_audio();
    exit;
}

image_speed = blade_anim_speed;
apply_facing();

// ====================================================
// PATROL
// ====================================================

switch (patrol_state)
{
    case "stationary":
    {
        // No movement.
    }
    break;

    case "hold_start":
    {
        hold_timer--;

        if (hold_timer <= 0)
        {
            patrol_state = "to_end";
        }
    }
    break;

    case "to_end":
    {
        if (!instance_exists(patrol_point))
        {
            patrol_state = "stationary";
            break;
        }

        patrol_end_x = patrol_point.x;
        patrol_end_y = patrol_point.y;

        if (move_to_target(patrol_end_x, patrol_end_y))
        {
            if (hold_end_frames > 0)
            {
                patrol_state = "hold_end";
                hold_timer = hold_end_frames;
            }
            else
            {
                patrol_state = "to_start";
            }
        }
    }
    break;

    case "hold_end":
    {
        hold_timer--;

        if (hold_timer <= 0)
        {
            patrol_state = "to_start";
        }
    }
    break;

    case "to_start":
    {
        if (move_to_target(patrol_start_x, patrol_start_y))
        {
            if (hold_start_frames > 0)
            {
                patrol_state = "hold_start";
                hold_timer = hold_start_frames;
            }
            else
            {
                patrol_state = "to_end";
            }
        }
    }
    break;
}

// ====================================================
// PLAYER KILL — ENTIRE WALL SAW IS LETHAL
// ====================================================

var p = instance_place(x, y, oPlayer);

if (p != noone)
{
    var can_kill = true;

    if (
        variable_instance_exists(p, "state")
        && p.state == "dead"
    )
    {
        can_kill = false;
    }

    if (
        variable_instance_exists(p, "invincible")
        && p.invincible
    )
    {
        can_kill = false;
    }

    if (can_kill)
    {
        with (p)
        {
            scr_player_died();
        }
    }
}

// ====================================================
// DIRECTIONAL / DISTANCE AUDIO — CLOSEST THREE ONLY
// ====================================================

var audio_player = instance_find(oPlayer, 0);

saw_audio_allowed = saw_is_audio_candidate(audio_player);

if (
    audio_player == noone
    || !saw_audio_allowed
    || snd_saw_loop == -1
)
{
    stop_saw_audio();
}
else
{
    var audio_dist = point_distance(
        x,
        y,
        audio_player.x,
        audio_player.y
    );

    var target_gain = 1;

    if (audio_dist > saw_sound_inner_dist)
    {
        var gain_t = clamp(
            (audio_dist - saw_sound_inner_dist)
            /
            max(1, saw_sound_outer_dist - saw_sound_inner_dist),
            0,
            1
        );

        target_gain = power(
            1 - gain_t,
            saw_sound_falloff_curve
        );
    }

    target_gain *= saw_loop_gain;

    saw_current_gain = lerp(
        saw_current_gain,
        target_gain,
        saw_sound_gain_lerp
    );

    if (saw_emitter >= 0)
    {
        // Player-relative coordinates provide stereo direction.
        audio_emitter_position(
            saw_emitter,
            x - audio_player.x,
            y - audio_player.y,
            0
        );

        audio_emitter_gain(
            saw_emitter,
            saw_current_gain
        );

        if (
            saw_sound_instance == -1
            || !audio_is_playing(saw_sound_instance)
        )
        {
            saw_sound_instance = audio_play_sound_on(
                saw_emitter,
                snd_saw_loop,
                true,
                0
            );
        }
    }
}
