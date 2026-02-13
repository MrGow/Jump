/// @func scr_player_died([_lock_feet_y])
/// @desc Handle player death: lock state, play death anim once (hold last frame),
///       bank run scrap, show death menu.
/// @param _lock_feet_y Optional: world Y where the player's FEET should be placed (sink into teeth)

function scr_player_died(_lock_feet_y)
{
    // Don't double-trigger
    if (state == "dead") return;

    // Optional: sink/lock feet to a specific Y (used by crushers)
    if (!is_undefined(_lock_feet_y))
    {
        // Move the instance so bbox_bottom == _lock_feet_y
        var dy = _lock_feet_y - bbox_bottom;
        y += dy;
    }

    // --- Enter death state ---
    state = "dead";

    // Stop movement
    hsp = 0;
    vsp = 0;

    // --- Play death animation FAST and ONCE ---
    sprite_index = spriteBotDeath;
    image_index  = 0;
    image_speed  = 0.60;   // tweak 0.45–0.80
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


