/// oMainMenuRoomController — Clean Up

// ====================================================
// MAIN MENU THEME
// ====================================================

if (
    menu_theme_voice != noone &&
    audio_is_playing(
        menu_theme_voice
    )
)
{
    audio_stop_sound(
        menu_theme_voice
    );
}

menu_theme_voice =
    noone;