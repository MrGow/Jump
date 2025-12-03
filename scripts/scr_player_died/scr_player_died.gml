/// @func scr_player_died()
/// @desc Handle player death: lock state, play death anim, notify run controller.

function scr_player_died() {
    // This script is meant to be called from oPlayer.
    // 'self' = the player instance.

    // Don't double-trigger
    if (state == "dead") return;

    // Basic death state
    state = "dead";

    // Stop movement
    hsp = 0;
    vsp = 0;

    // Play death animation
    sprite_index = spriteBotDeath;
    image_speed  = 0.25;
    image_index  = 0;
    image_xscale = facing; // keep facing direction

    // TODO: optional: play SFX, spawn particles, etc.
    // audio_play_sound(snd_death, 1, false);

    // Tell the run controller to schedule a respawn
    if (instance_exists(oRunController)) {
        with (oRunController) {
            if (!is_resetting) {
                is_resetting = true;
                alarm[0] = respawn_delay; // set in oRunController Create
            }
        }
    }
}
