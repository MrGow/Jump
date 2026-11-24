
/// oGunShipLaserTrigger — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);

if (!instance_exists(p))
{
    player_was_inside = false;
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// PLAYER OVERLAP
// ====================================================

var player_inside =
    p.bbox_right > bbox_left &&
    p.bbox_left < bbox_right &&
    p.bbox_bottom > bbox_top &&
    p.bbox_top < bbox_bottom;

var entered =
    player_inside &&
    !player_was_inside;

player_was_inside = player_inside;


// ====================================================
// COMPLETED
// ====================================================

if (completed)
{
    exit;
}


// ====================================================
// EXISTING REQUEST
// ====================================================

if (requested)
{
    // If the Gunship disappears, clear the pending
    // request safely.

    if (!instance_exists(trigger_ship))
    {
        requested = false;
        accepted = false;
        trigger_ship = noone;
    }

    exit;
}


// ====================================================
// TRIGGER ACTIVATION
// ====================================================

if (!entered)
{
    exit;
}


// ====================================================
// FIND GUNSHIP
// ====================================================

var ship = instance_find(oGunShip, 0);

if (!instance_exists(ship))
{
    exit;
}

if (!ship.enabled)
{
    exit;
}


// ====================================================
// SAFETY: BOSS ARENA
//
// Never request a horizontal laser while the Gunship
// is performing an arena phase or recovering.
// ====================================================

if (
    ship.arena_phase_active ||
    ship.scripted_override ||
    ship.state == "boss_crashing" ||
    ship.state == "boss_exposed" ||
    ship.state == "boss_retracting" ||
    ship.state == "boss_recovering"
)
{
    exit;
}


// ====================================================
// SAFETY: OTHER LASER REQUEST
// ====================================================

if (
    variable_instance_exists(
        ship,
        "laser_trigger_request"
    )
)
{
    if (instance_exists(ship.laser_trigger_request))
    {
        exit;
    }
}


// ====================================================
// PREPARE TARGET POSITION
// ====================================================

calculate_target();

request_direction =
    (fire_direction < 0) ? -1 : 1;


// ====================================================
// PREPARE ATTACK SETTINGS
// ====================================================

request_charge_frames = max(
    1,
    round(charge_duration * room_speed)
);

request_fire_frames = max(
    1,
    round(fire_duration * room_speed)
);

request_recovery_frames = max(
    1,
    round(recovery_duration * room_speed)
);

request_move_speed = max(
    0.1,
    move_speed
);

request_arrival_tolerance = max(
    0.1,
    arrival_tolerance
);


// ====================================================
// SEND REQUEST
//
// The Gunship Step event will later recognise this.
// ====================================================

trigger_ship = ship;

requested = true;
accepted = false;

ship.laser_trigger_request = id;
