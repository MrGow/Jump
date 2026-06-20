/// scr_play_sfx(_sound, _gain, _pitch)

function scr_play_sfx(_sound, _gain, _pitch)
{
    if (is_undefined(_sound)) return noone;
    if (_sound == -1) return noone;
    if (!audio_exists(_sound)) return noone;

    if (is_undefined(_gain))  _gain = 1;
    if (is_undefined(_pitch)) _pitch = 1;

    var inst = audio_play_sound(_sound, 1, false);

    audio_sound_gain(inst, _gain, 0);
    audio_sound_pitch(inst, _pitch);

    return inst;
}