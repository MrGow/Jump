/// oDeathMenu — Create

// Safety: never exist unless the player actually died
if (
    !variable_global_exists("game_phase") ||
    global.game_phase != "death_menu"
)
{
    instance_destroy();
    exit;
}

alpha = 0;
fade_speed = 0.1;

// ====================================================
// DEATH UI AUDIO
// ====================================================

snd_death_screen =
    asset_get_index("RespawnDeathScreen1");

snd_respawn_confirm =
    asset_get_index("RespawnConfirmation1");

snd_player_respawn =
    asset_get_index("RespawnSound1");

death_screen_sfx_gain = 1.0;
respawn_confirm_sfx_gain = 1.0;
player_respawn_sfx_gain = 1.0;

// Play once when the death UI appears.
if (
    snd_death_screen != -1 &&
    audio_group_is_loaded(audiogroupui)
)
{
    var death_screen_voice =
        audio_play_sound(
            snd_death_screen,
            110,
            false
        );

    if (death_screen_voice != noone)
    {
        audio_sound_gain(
            death_screen_voice,
            death_screen_sfx_gain,
            0
        );
    }
}