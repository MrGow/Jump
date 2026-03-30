/// @func scr_player_died([_lock_feet_y], [_fall_death])
/// @desc Handle player death:
///       - normal hazards freeze/sink in place
///       - death zones can pass _fall_death=true so the corpse keeps falling
///       - for death-zone deaths, capture the current camera view so the camera can lock
/// @param _lock_feet_y Optional: world Y where the player's FEET should be placed
/// @param _fall_death  Optional: true = keep falling while dead

function scr_player_died(_lock_feet_y, _fall_death)
{
    // Don't double-trigger
    if (state == "dead") return;

    if (is_undefined(_fall_death)) _fall_death = false;

    // Store fall-death behaviour on player
    death_fall = _fall_death;

    // Store exact current camera view on player for pit/death-zone deaths
    if (death_fall)
    {
        // ALWAYS overwrite so these never go stale across deaths
        death_cam_lock_x = x;
        death_cam_lock_y = y;

        if (instance_exists(oCamera))
        {
            var _cam_inst = instance_find(oCamera, 0);
            if (_cam_inst != noone)
            {
                death_cam_lock_x = camera_get_view_x(_cam_inst.cam);
                death_cam_lock_y = camera_get_view_y(_cam_inst.cam);

                // Cancel any in-progress fade/zone transition so the camera doesn't try to
                // transition while dead
                if (variable_instance_exists(_cam_inst, "fade_state"))   _cam_inst.fade_state = 0;
                if (variable_instance_exists(_cam_inst, "fade_alpha"))   _cam_inst.fade_alpha = 0;
                if (variable_instance_exists(_cam_inst, "pending_zone")) _cam_inst.pending_zone = noone;
                if (variable_instance_exists(_cam_inst, "fade_hold"))    _cam_inst.fade_hold = 0;
            }
        }
    }

    // Optional: sink/lock feet to a specific Y (used by crushers)
    if (!is_undefined(_lock_feet_y))
    {
        var dy = _lock_feet_y - bbox_bottom;
        y += dy;
    }

    // --- Enter death state ---
    state = "dead";

    // Stop horizontal motion
    hsp = 0;

    // Freeze vertical only for non-fall deaths
    if (!death_fall) {
        vsp = 0;
    }

    // Clear jump / grounding state so nothing weird lingers
    jump_charging     = false;
    jump_charge       = 0;
    jump_charge_level = 0;
    charge_grace      = 0;
    support_grace     = 0;
    charge_start_lock = 0;
    ground_stick      = 0;
    ground_frames     = 0;
    bounce_pending    = false;
    bounce_timer      = 0;

    // --- Play death animation FAST and ONCE ---
    sprite_index = spriteBotDeath;
    image_index  = 0;
    image_speed  = 0.60;
    image_xscale = facing;

    // --- Bank scrap from this run ---
    if (!variable_global_exists("scrap_total")) global.scrap_total = 0;
    if (!variable_global_exists("scrap_run"))   global.scrap_run   = 0;

    global.scrap_total += global.scrap_run;
    global.scrap_run = 0;

    // --- Switch phase + open menu (once) ---
    global.game_phase = "death_menu";

    if (!instance_exists(oDeathMenu))
    {
        var layer_name = layer_exists("GUI") ? "GUI" : "Instances";
        instance_create_layer(x, y, layer_name, oDeathMenu);
    }
}