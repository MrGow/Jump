/// oHoloSpikes — Create

event_inherited();

enabled = true;
active = false;
solid_body = false;
solid_only_when_active = false;

// Sprite origins (configure in Sprite Editor):
// Base (9,3), Middle (5,1), PointedEnd (4,3).
sprite_index = spriteHoloSpikeBase;
image_speed = 0;
image_index = 0;

// Editor variables: assign through Variable Definitions.
if (!variable_instance_exists(id, "spike_direction")) spike_direction = 0;
if (!variable_instance_exists(id, "extension_distance")) extension_distance = 64;
if (!variable_instance_exists(id, "extend_frames")) extend_frames = 16;
if (!variable_instance_exists(id, "retract_frames")) retract_frames = 16;
if (!variable_instance_exists(id, "retracted_time_s")) retracted_time_s = 1.5;
if (!variable_instance_exists(id, "up_time_s")) up_time_s = 1.0;
// Fraction of total extension that remains safe.
//
// 0.15 = first 15% of extension is harmless.
// The same threshold applies when retracting.
//
// 0.0 = lethal as soon as extension begins.
// 1.0 = lethal only at full extension.

if (!variable_instance_exists(id, "spike_grace_fraction"))
{
    spike_grace_fraction = 0.15;
}
if (!variable_instance_exists(id, "hit_pad")) hit_pad = 2;
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;

// Visual alignment. Positive moves shaft/tip right for upward spikes.
// This offset rotates with spike_direction.
if (!variable_instance_exists(id, "spike_side_offset")) spike_side_offset = 5;

// Start shaft at the centre of the base (0 = halfway inside housing).
if (!variable_instance_exists(id, "spike_shaft_start")) spike_shaft_start = 0;

// Pointed end overlaps the final shaft section by this many pixels.
if (!variable_instance_exists(id, "spike_tip_overlap")) spike_tip_overlap = 3;

spike_direction = ((round(spike_direction) mod 4) + 4) mod 4;
extension_distance = max(0, extension_distance);
extend_frames = max(1, round(extend_frames));
retract_frames = max(1, round(retract_frames));
retracted_frames = max(0, round(retracted_time_s * room_speed));
up_frames = max(0, round(up_time_s * room_speed));
spike_grace_fraction = clamp(spike_grace_fraction, 0, 1);

state = "retracted";
state_timer = retracted_frames;
extension = 0;
active = false;

snd_holo_extend = asset_get_index("HoloSpikesExtend1");
snd_holo_retract = asset_get_index("HoloSpikesRetract1");
holo_spike_sound_gain = 0.25;
holo_spike_sound_inner_dist = 90;
holo_spike_sound_outer_dist = 420;
holo_spike_sound_falloff_curve = 1.35;
holo_spike_sound_max_voices = 4;

// Original distance attenuation and closest-spike sound limiting.
holo_spike_play_sound = function(_sound)
{
    if (_sound == -1) return;
    var _p = instance_find(oPlayer, 0);
    if (_p == noone) return;
    var _dist = point_distance(x, y, _p.x, _p.y);
    if (_dist >= holo_spike_sound_outer_dist) return;

    var _closer_count = 0;
    var _count = instance_number(object_index);
    for (var _i = 0; _i < _count; _i++)
    {
        var _spike = instance_find(object_index, _i);
        if (_spike == noone || _spike == id) continue;
        if (variable_instance_exists(_spike, "enabled") && !_spike.enabled) continue;
        var _other_dist = point_distance(_spike.x, _spike.y, _p.x, _p.y);
        if (_other_dist < _dist)
        {
            _closer_count++;
            if (_closer_count >= holo_spike_sound_max_voices) return;
        }
    }

    var _gain = holo_spike_sound_gain;
    if (_dist > holo_spike_sound_inner_dist)
    {
        var _t = (_dist - holo_spike_sound_inner_dist) /
                 max(1, holo_spike_sound_outer_dist - holo_spike_sound_inner_dist);
        _gain *= power(1 - clamp(_t, 0, 1), holo_spike_sound_falloff_curve);
    }
    if (_gain <= 0) return;
    if (!audio_group_is_loaded(audiogroupsfx)) return;
    var _voice = audio_play_sound(_sound, -50, false);
    if (_voice != -1) audio_sound_gain(_voice, _gain, 0);
};
