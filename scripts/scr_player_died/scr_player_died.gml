/// @func scr_player_died()
/// @desc Handle player death: lock state, play death anim once (hold last frame),
///       bank run scrap, show death menu.

function scr_player_died()
{
    // Don't double-trigger
    if (state == "dead") return;

    // --- Enter death state ---
    state = "dead";

    // Stop movement
    hsp = 0;
    vsp = 0;

    // --- Play death animation FAST and ONCE ---
    sprite_index = spriteBotDeath;
    image_index  = 0;
    image_speed  = 0.60;   // << faster (tweak: 0.45–0.80)
    image_xscale = facing;

    // Ensure it doesn't loop (if your sprite is set to loop)
    // We'll also hard-hold last frame in Step.
    // (No special sprite settings required.)

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


