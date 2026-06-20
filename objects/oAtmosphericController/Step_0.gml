/// oAtmosphereController - Step

if (atmo_started) exit;
if (atmo_sound == -1) exit;

if (!audio_group_is_loaded(audiogroupatmosphere)) {
    exit;
}

scr_settings_apply_audio_gains();

atmo_instance = audio_play_sound(
    atmo_sound,
    0,
    true
);

audio_sound_gain(atmo_instance, atmo_gain, 0);
audio_sound_pitch(atmo_instance, atmo_pitch);

atmo_started = true;

show_debug_message("ATMOS STARTED = " + room_get_name(room));