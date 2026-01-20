/// oHazard - Collision with oPlayer (PARENT)

// Basic gates
if (!enabled) exit;
if (!active && kill_mode == "active_only") exit;

// Call death handler on the PLAYER instance
with (other) scr_player_died();

