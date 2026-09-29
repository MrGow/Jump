/// oGunShipStartTrigger — Create

// Leave the trigger's sprite/mask assigned so its bbox works.
// The custom Draw event keeps it invisible during gameplay.
visible = true;

activated = false;
encounter_active = false;
completed = false;

// After a reset, the player must leave the trigger before
// it can start another attempt.
waiting_for_player_clear = false;

// 1 = enter from the right; -1 = enter from the left.
spawn_side = 1;
spawn_margin = 170;
spawn_screen_y = 82;

debug_draw = false;

// Save the controller's original room position before an
// arena moves its crash anchor over a silo.
controller_start_x = noone;

cleanup_encounter = function()
{
    with (oGunShip)
        instance_destroy();

    with (oGunShipMine)
        instance_destroy();

    var cam_inst = instance_find(oCamera, 0);

    if (instance_exists(cam_inst))
        cam_inst.arena_lock_active = false;

    with (oGunShipArenaTrigger)
    {
        active = false;
        completed = false;
        arena_ship = noone;
        arena_launcher = noone;
        go_flash = 0;
    }

    with (oMissileLauncher)
    {
        arena_disabled = false;
        player_on_plate = false;
        needs_plate_release = true;
        show_launch_bar = false;
        launch_full_flash_timer = 0;
        launch_progress = 0;

        plate_visual_target = 0;
        plate_visual_offset = 0;
        plate_anim_position = 0;

        missile_state = MISSILE_READY;
        launcher_anim_position = launcher_closed_frame;
        image_index = launcher_closed_frame;
        missile_fired = false;
    }

    var ctrl = instance_find(oGunShipController, 0);

    if (instance_exists(ctrl))
    {
        ctrl.active = false;
        ctrl.ship = noone;
        ctrl.max_hp = 4;
        ctrl.hp = 4;

        if (controller_start_x != noone)
            ctrl.x = controller_start_x;
    }

    activated = false;
    encounter_active = false;
    completed = false;
    waiting_for_player_clear = true;
};