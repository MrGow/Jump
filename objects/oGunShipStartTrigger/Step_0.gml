/// oGunShipStartTrigger — Step


// ====================================================
// COMPLETED BOSS
// ====================================================

if (completed)
{
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}


// ====================================================
// PLAYER / TRIGGER OVERLAP
// ====================================================

var touching =
    p.bbox_right > bbox_left
    &&
    p.bbox_left < bbox_right
    &&
    p.bbox_bottom > bbox_top
    &&
    p.bbox_top < bbox_bottom;


// ====================================================
// DEATH PRESENTATION
//
// Keep the encounter visually frozen until the player
// confirms the death menu. That confirmation calls
// cleanup_encounter().
// ====================================================

var player_dead =
    variable_instance_exists(p, "state")
    &&
    p.state == "dead";

var death_state =
    variable_global_exists("game_phase")
    &&
    (
        global.game_phase == "death_delay"
        ||
        global.game_phase == "death_menu"
    );

if (
    player_dead ||
    death_state
)
{
    exit;
}


// ====================================================
// WAIT FOR PLAYER TO LEAVE TRIGGER AFTER RESPAWN
// ====================================================

if (waiting_for_player_clear)
{
    if (!touching)
    {
        waiting_for_player_clear = false;
    }

    exit;
}


// ====================================================
// GAME FROZEN
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ENCOUNTER ALREADY ACTIVE
// ====================================================

if (activated)
{
    // Unexpected destruction or direct testing recovery.
    // Normal victory is handled by "completed" above.
    if (
        encounter_active &&
        !instance_exists(oGunShip)
    )
    {
        activated = false;
        encounter_active = false;

        waiting_for_player_clear = true;

        if (instance_exists(oGunShipController))
        {
            with (oGunShipController)
            {
                ship = noone;
                active = false;
            }
        }
    }

    exit;
}


// ====================================================
// START ENCOUNTER
// ====================================================

if (!touching)
{
    exit;
}


// ----------------------------------------------------
// Remove stale instances from direct testing.
// This runs only when starting a new attempt.
// ----------------------------------------------------

with (oGunShip)
{
    instance_destroy();
}

with (oGunShipMine)
{
    instance_destroy();
}

with (oMissile)
{
    instance_destroy();
}


// ====================================================
// CAMERA
// ====================================================

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


// ====================================================
// SPAWN POSITION
// ====================================================

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


// ====================================================
// CREATE GUNSHIP
// ====================================================

var ship = instance_create_depth(
    ship_x,
    ship_y,
    -5000,
    oGunShip
);

if (ship == noone)
{
    exit;
}

if (spawn_side >= 0)
{
    ship.facing = -1;
}
else
{
    ship.facing = 1;
}

ship.enabled = true;
ship.ai_enabled = true;
ship.scripted_override = false;


// ====================================================
// CONNECT BOSS CONTROLLER
// ====================================================

var controller =
    instance_find(oGunShipController, 0);

if (instance_exists(controller))
{
    controller.ship = ship;
    controller.hp = controller.max_hp;
    controller.active = true;

    ship.boss_controller = controller;
    ship.boss_trigger = id;
}

activated = true;
encounter_active = true;