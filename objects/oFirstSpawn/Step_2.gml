/// oFirstSpawn — End Step
// Player movement, collisions and bouncing are handled by oPlayer Step.

if (!started) exit;
if (!instance_exists(player_ref))
{
    instance_destroy();
    exit;
}

if (state == "empty_hold")
{
    // Hold JumpBot out of view until the delayed entrance begins.
    player_ref.x = landing_x + fall_offset_x;
    player_ref.y = landing_y - fall_height;
    player_ref.hsp = 0;
    player_ref.vsp = 0;
    player_ref.prev_on_ground = false;
    hold_tick++;
    if (hold_tick >= empty_hold_frames)
    {
        state = "fall";
        player_ref.hsp = fall_drift_speed;
    }
}
else if (state == "fall")
{
    // Natural fall and bounce. Detect first ground contact without
    // forcing any landing pose or moving the player to the marker.
    if (player_ref.prev_on_ground ||
        player_ref.bounce_pending ||
        player_ref.state == "landing")
    {
        has_landed = true;
        state = "wait_for_settle";
        settle_tick = 0;
    }
}
else if (state == "wait_for_settle")
{
    // Wait for the normal bounce to finish and player to be grounded.
    if (player_ref.prev_on_ground &&
        !player_ref.bounce_pending &&
        abs(player_ref.vsp) < 0.1)
    {
        settle_tick++;
        if (settle_tick >= settle_frames)
        {
            state = "bars_open";
            bars_tick = 0;
        }
    }
    else
    {
        settle_tick = 0;
    }
}
else if (state == "bars_open")
{
    bars_tick++;
    bars_amount = 1 -
        clamp(bars_tick / max(1, bars_open_frames), 0, 1);

    if (bars_tick >= bars_open_frames)
    {
        bars_amount = 0;
        global.first_spawn_played = true;
        player_ref.first_spawn_locked = false;
        player_ref.jump_trail_enabled = old_trail_enabled;
        player_ref.jump_trail_points = [];

        if (instance_exists(camera_ref))
            camera_ref.arena_lock_active = old_camera_locked;

        state = "done";
        instance_destroy();
    }
}
