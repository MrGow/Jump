/// oGunShipArenaTrigger — Step

if (scr_game_frozen())
{
    exit;
}

var p = instance_find(oPlayer, 0);

if (!instance_exists(p))
{
    exit;
}

if (p.state == "dead")
{
    exit;
}


// ====================================================
// ACTIVE ARENA
// ====================================================

if (active)
{
    if (!instance_exists(arena_ship))
    {
        active = false;

        var lost_cam =
            instance_find(oCamera, 0);

        if (instance_exists(lost_cam))
        {
            lost_cam.arena_lock_active = false;
        }

        exit;
    }

    if (
        instance_exists(arena_ship.boss_controller) &&
        arena_ship.boss_controller.hp < hp_at_start
    )
    {
        active = false;
        completed = true;

        arena_ship.arena_phase_active = false;
        arena_ship.scripted_override = false;

        if (instance_exists(arena_launcher))
        {
            arena_launcher.arena_disabled = true;
        }

        var exit_cam =
            instance_find(oCamera, 0);

        if (instance_exists(exit_cam))
        {
            exit_cam.arena_lock_active = false;
        }
    }

    exit;
}


// ====================================================
// COMPLETED ARENA
// ====================================================

if (completed)
{
    go_flash += 0.11;
    exit;
}


// ====================================================
// PLAYER ENTERS THE TRIGGER RECTANGLE
//
// The sprite's collision mask defines the trigger area.
// ====================================================

var touching =
    p.bbox_right > bbox_left
    &&
    p.bbox_left < bbox_right
    &&
    p.bbox_bottom > bbox_top
    &&
    p.bbox_top < bbox_bottom;

if (!touching)
{
    exit;
}


// ====================================================
// REQUIRED INSTANCES
// ====================================================

var ship =
    instance_find(oGunShip, 0);

var cam_inst =
    instance_find(oCamera, 0);

var ctrl =
    instance_find(oGunShipController, 0);

if (
    !instance_exists(ship) ||
    !instance_exists(cam_inst) ||
    !instance_exists(ctrl)
)
{
    exit;
}

if (cam_inst.fade_state != 0)
{
    exit;
}

if (
    ship.state == "boss_crashing" ||
    ship.state == "boss_exposed" ||
    ship.state == "boss_retracting" ||
    ship.state == "boss_recovering"
)
{
    exit;
}


// ====================================================
// CAMERA POSITION
//
// Use the left edge of the trigger sprite as the
// entrance point, regardless of the sprite's origin.
// ====================================================

var view_w =
    camera_get_view_width(cam_inst.cam);

var left_x = clamp(
    round(bbox_left - entry_screen_x),
    0,
    max(0, room_width - view_w)
);


// ====================================================
// FIND THIS ARENA'S LAUNCHER
// ====================================================

var launcher = noone;
var best_dist = 1000000;

for (
    var i = 0;
    i < instance_number(oMissileLauncher);
    i++
)
{
    var candidate =
        instance_find(oMissileLauncher, i);

    if (
        candidate.x <= left_x + 140 ||
        candidate.x >= left_x + view_w - 90
    )
    {
        continue;
    }

    var d =
        abs(
            candidate.x -
            (left_x + view_w * 0.55)
        );

    if (d < best_dist)
    {
        best_dist = d;
        launcher = candidate;
    }
}

if (!instance_exists(launcher))
{
    exit;
}


// ====================================================
// START ARENA
// ====================================================

arena_ship = ship;
arena_launcher = launcher;

arena_camera_x = left_x;
arena_camera_y = cam_inst.cam_logic_y;

hp_at_start = ctrl.hp;

active = true;
go_flash = 0;


// Keep the crash centered on this arena's silo.
ctrl.x = launcher.x;
ctrl.ship = ship;
ctrl.active = true;

ship.boss_controller = ctrl;

ship.boss_clear_attacks();

ship.state = "hover";
ship.scripted_override = true;

ship.arena_phase_active = true;
ship.arena_phase_frame = 0;

ship.arena_target_x = launcher.x;
ship.arena_target_y =
    arena_camera_y +
    ship.hover_screen_y;

ship.hover_hspeed = 0;
ship.hover_vspeed = 0;
ship.gun_state = "idle";


// ====================================================
// LOCK CAMERA AND ENABLE LAUNCHER
// ====================================================

cam_inst.arena_lock_x = arena_camera_x;
cam_inst.arena_lock_y = arena_camera_y;
cam_inst.arena_lock_active = true;

launcher.arena_disabled = false;