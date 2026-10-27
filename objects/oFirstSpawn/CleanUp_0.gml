/// oFirstSpawn — Clean Up
// Safety when room changes unexpectedly during the cinematic.
if (instance_exists(player_ref) &&
    variable_instance_exists(player_ref, "first_spawn_locked") &&
    player_ref.first_spawn_locked)
{
    player_ref.first_spawn_locked = false;
    player_ref.jump_trail_enabled = old_trail_enabled;
}
if (instance_exists(camera_ref) && started)
    camera_ref.arena_lock_active = old_camera_locked;
