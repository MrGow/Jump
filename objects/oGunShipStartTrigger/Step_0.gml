/// oGunShipStartTrigger — Step

// ====================================================
// FIND PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}


// ====================================================
// PLAYER / TRIGGER OVERLAP
// ====================================================

var touching =
    (
        p.bbox_right >
        bbox_left
    )
    &&
    (
        p.bbox_left <
        bbox_right
    )
    &&
    (
        p.bbox_bottom >
        bbox_top
    )
    &&
    (
        p.bbox_top <
        bbox_bottom
    );


// ====================================================
// DEATH STATE
//
// IMPORTANT:
//
// Do NOT destroy the gunship here.
//
// The entire encounter should remain visually frozen
// during:
// - death animation
// - death delay
// - death menu
//
// Cleanup happens when the player confirms REINITIALIZE
// in oDeathMenu.
// ====================================================

var player_dead =
    variable_instance_exists(
        p,
        "state"
    )
    &&
    p.state == "dead";


var death_state =
    variable_global_exists(
        "game_phase"
    )
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
// WAIT FOR PLAYER TO CLEAR TRIGGER AFTER RESPAWN
//
// DeathMenu sets this true when resetting the encounter.
//
// Because your checkpoint is BEFORE this trigger, the
// respawned player should already be outside it.
//
// This extra guard prevents an immediate retrigger if
// you ever move the checkpoint closer in future.
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
    // Safety:
    // If the gunship disappears for some unrelated
    // reason while gameplay is active, allow the trigger
    // to recover.
    if (
        encounter_active &&
        !instance_exists(oGunShip)
    )
    {
        activated = false;
        encounter_active = false;

        waiting_for_player_clear = true;
    }

    exit;
}


// ====================================================
// START ENCOUNTER
// ====================================================

if (touching)
{
    // ------------------------------------------------
    // Clean stale instances from unusual direct testing
    // or hot reloads.
    //
    // This only happens when STARTING a new attempt,
    // never during the death presentation.
    // ------------------------------------------------

    with (oGunShip)
    {
        instance_destroy();
    }


    with (oGunShipMine)
    {
        instance_destroy();
    }


    // ------------------------------------------------
    // CAMERA
    // ------------------------------------------------

    var cam =
        view_camera[0];


    var cam_x = 0;
    var cam_y = 0;

    var cam_w = 640;


    if (cam != -1)
    {
        cam_x =
            camera_get_view_x(
                cam
            );

        cam_y =
            camera_get_view_y(
                cam
            );

        cam_w =
            camera_get_view_width(
                cam
            );
    }


    // =================================================
    // SPAWN POSITION
    // =================================================

    var ship_x;


    if (spawn_side >= 0)
    {
        // Spawn beyond right side of camera.
        ship_x =
            cam_x +
            cam_w +
            spawn_margin;
    }
    else
    {
        // Spawn beyond left side.
        ship_x =
            cam_x -
            spawn_margin;
    }


    var ship_y =
        cam_y +
        spawn_screen_y;


    // =================================================
    // CREATE GUNSHIP
    // =================================================

    var ship =
        instance_create_depth(
            ship_x,
            ship_y,
            -5000,
            oGunShip
        );


    if (ship != noone)
    {
        // --------------------------------------------
        // Face toward the play area initially.
        // --------------------------------------------

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


        activated = true;

        encounter_active = true;
    }
}