/// oGunShipStartTrigger — Create

visible = false;


// ====================================================
// ENCOUNTER STATE
// ====================================================

activated = false;
encounter_active = false;


// After death we wait until the player is completely
// outside the trigger before allowing it to fire again.
//
// This prevents accidental instant retriggering if a
// checkpoint or respawn point is ever placed too close.
waiting_for_player_clear = false;


// ====================================================
// GUNSHIP SPAWN
// ====================================================

// 1 = enter from RIGHT
// -1 = enter from LEFT
spawn_side = 1;


// Distance outside camera when initially created.
spawn_margin = 170;


// Vertical position relative to top of camera.
//
// oGunShip will take over its own hovering immediately.
spawn_screen_y = 82;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// CLEANUP HELPER
//
// Removes every part of the encounter.
// ====================================================

cleanup_encounter = function()
{
    // Main boss.
    with (oGunShip)
    {
        instance_destroy();
    }


    // Any mines already dropped.
    if (asset_get_index("oGunShipMine") != -1)
    {
        with (oGunShipMine)
        {
            instance_destroy();
        }
    }


    activated = false;
    encounter_active = false;

    waiting_for_player_clear = true;
};