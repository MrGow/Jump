/// oGunShipStartTrigger — Step

var p = instance_find(oPlayer, 0);
if (!instance_exists(p)) exit;

// Remember the controller's authored position before the
// first arena changes its X position.
var ctrl = instance_find(oGunShipController, 0);

if (instance_exists(ctrl) &&
    controller_start_x == noone)
{
    controller_start_x = ctrl.x;
}

var touching =
    p.bbox_right > bbox_left &&
    p.bbox_left < bbox_right &&
    p.bbox_bottom > bbox_top &&
    p.bbox_top < bbox_bottom;

// Keep the encounter on screen during the player's death
// animation, delay, and death menu. The death menu calls
// cleanup_encounter() when reinitializing.
var player_dead =
    variable_instance_exists(p, "state") &&
    p.state == "dead";

var death_phase =
    variable_global_exists("game_phase") &&
    (
        global.game_phase == "death_delay" ||
        global.game_phase == "death_menu"
    );

if (player_dead || death_phase)
    exit;

if (waiting_for_player_clear)
{
    if (!touching)
        waiting_for_player_clear = false;

    exit;
}

if (scr_game_frozen())
    exit;

// The fourth hit marks this trigger completed when the
// gunship finishes retracting its weak spot.
if (completed)
    exit;

if (activated)
{
    // Recovery if the ship vanishes unexpectedly during
    // active gameplay. Completion is handled above.
    if (encounter_active &&
        !instance_exists(oGunShip))
    {
        cleanup_encounter();
    }

    exit;
}

if (!touching)
    exit;

// The HP controller should be placed in the room.
if (!instance_exists(ctrl))
    exit;

// Clear stale test instances only when starting an attempt.
with (oGunShip)
    instance_destroy();

with (oGunShipMine)
    instance_destroy();

var cam = view_camera[0];
var cam_x = 0;
var cam_y = 0;
var cam_w = 640;

if (cam != -1)
{
    cam_x = camera_get_view_x(cam);
    cam_y = camera_get_view_y(cam);
    cam_w = camera_get_view_width(cam);
}

var ship_x;

if (spawn_side >= 0)
{
    ship_x =
        cam_x +
        cam_w +
        spawn_margin;
}
else
{
    ship_x =
        cam_x -
        spawn_margin;
}

var ship_y =
    cam_y +
    spawn_screen_y;

var ship = instance_create_depth(
    ship_x,
    ship_y,
    -5000,
    oGunShip
);

if (!instance_exists(ship))
    exit;

ship.facing =
    (spawn_side >= 0)
    ? -1
    : 1;

ship.enabled = true;
ship.ai_enabled = true;
ship.scripted_override = false;
ship.arena_phase_active = false;

// Connect both directions so the ship can remove HP,
// update the bar, and mark this encounter complete.
ship.boss_controller = ctrl;
ship.boss_trigger = id;

ctrl.max_hp = 4;
ctrl.hp = 4;
ctrl.active = true;
ctrl.ship = ship;

activated = true;
encounter_active = true;