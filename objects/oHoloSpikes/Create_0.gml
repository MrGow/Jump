/// oHoloSpike — Create

event_inherited();

enabled = true;
active  = false;

solid_body = false;
solid_only_when_active = false;


// ====================================================
// SPRITE
// ====================================================

sprite_index = spriteHoloSpike;

image_speed = 0;
image_index = 0;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Direction
//
// Source artwork points UP.
//
// 0 = up
// 1 = right
// 2 = down
// 3 = left
// ----------------------------------------------------

if (!variable_instance_exists(id, "spike_direction"))
{
    spike_direction = 0;
}


// Time fully retracted / safe.
if (!variable_instance_exists(id, "retracted_time_s"))
{
    retracted_time_s = 1.5;
}


// Time fully extended / lethal.
if (!variable_instance_exists(id, "up_time_s"))
{
    up_time_s = 1.0;
}


// Extension / retraction animation speed.
if (!variable_instance_exists(id, "spike_anim_speed"))
{
    spike_anim_speed = 0.35;
}


// During retraction, the spike becomes safe once
// image_index reaches this frame or lower.
//
// GameMaker frame 2 = visible sprite frame 3.
if (!variable_instance_exists(id, "retract_safe_frame"))
{
    retract_safe_frame = 2;
}


// Slight collision forgiveness.
if (!variable_instance_exists(id, "hit_pad"))
{
    hit_pad = 2;
}


// Debug display.
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// ROTATION
// ====================================================

update_spike_rotation = function()
{
    spike_direction =
        ((round(spike_direction) mod 4) + 4) mod 4;


    switch (spike_direction)
    {
        // Up
        case 0:
            image_angle = 0;
        break;


        // Right
        case 1:
            image_angle = 270;
        break;


        // Down
        case 2:
            image_angle = 180;
        break;


        // Left
        case 3:
            image_angle = 90;
        break;
    }
};


update_spike_rotation();


// ====================================================
// TIMING
// ====================================================

retracted_frames =
    max(
        0,
        round(
            retracted_time_s *
            room_speed
        )
    );


up_frames =
    max(
        0,
        round(
            up_time_s *
            room_speed
        )
    );


retracted_timer =
    retracted_frames;


up_timer =
    up_frames;


// ====================================================
// ANIMATION FRAMES
// ====================================================

// First frame = fully retracted.
idle_frame = 0;


// Sixth sprite frame.
//
// GameMaker starts at 0:
// frame 1 = 0
// frame 2 = 1
// ...
// frame 6 = 5
up_hold_frame = 5;


// Safety in case sprite changes later.
up_hold_frame =
    clamp(
        up_hold_frame,
        0,
        image_number - 1
    );


retract_safe_frame =
    clamp(
        retract_safe_frame,
        idle_frame,
        up_hold_frame
    );


// ====================================================
// STATE
// ====================================================

state = "retracted";


// ====================================================
// INITIAL VISUAL STATE
// ====================================================

image_index = idle_frame;
image_speed = 0;

active = false;


// ====================================================
// AUDIO
// ====================================================

snd_holo_extend =
    asset_get_index(
        "HoloSpikesExtend1"
    );


snd_holo_retract =
    asset_get_index(
        "HoloSpikesRetract1"
    );


// Overall volume.
holo_spike_sound_gain =
    0.65;


// Full volume inside this distance.
holo_spike_sound_inner_dist =
    90;


// Completely inaudible beyond this distance.
holo_spike_sound_outer_dist =
    420;


// Distance falloff.
holo_spike_sound_falloff_curve =
    1.35;


// Only the four closest holo spikes can emit
// their movement sounds.
holo_spike_sound_max_voices =
    4;


// ====================================================
// PLAY HOLO SPIKE SOUND
//
// Distance-based one-shot.
//
// Only one of the N closest enabled holo spikes to
// the player is allowed to emit its sound.
// ====================================================

holo_spike_play_sound =
function(_sound)
{
    if (_sound == -1)
    {
        return;
    }


    // ------------------------------------------------
    // PLAYER
    // ------------------------------------------------

    var _p =
        instance_find(
            oPlayer,
            0
        );


    if (_p == noone)
    {
        return;
    }


    // ------------------------------------------------
    // OUR DISTANCE
    // ------------------------------------------------

    var _dist =
        point_distance(
            x,
            y,
            _p.x,
            _p.y
        );


    if (
        _dist >=
        holo_spike_sound_outer_dist
    )
    {
        return;
    }


    // ------------------------------------------------
    // CLOSEST-SPIKE LIMIT
    // ------------------------------------------------

    var _closer_count =
        0;


    var _count =
        instance_number(
            oHoloSpikes
        );


    for (
        var _i = 0;
        _i < _count;
        _i++
    )
    {
        var _spike =
            instance_find(
                oHoloSpikes,
                _i
            );


        if (
            _spike == noone
            ||
            _spike == id
        )
        {
            continue;
        }


        // Disabled spikes do not count.
        if (
            variable_instance_exists(
                _spike,
                "enabled"
            )
            &&
            !_spike.enabled
        )
        {
            continue;
        }


        var _other_dist =
            point_distance(
                _spike.x,
                _spike.y,
                _p.x,
                _p.y
            );


        if (_other_dist < _dist)
        {
            _closer_count++;


            if (
                _closer_count >=
                holo_spike_sound_max_voices
            )
            {
                return;
            }
        }
    }


    // ------------------------------------------------
    // DISTANCE GAIN
    // ------------------------------------------------

    var _gain =
        holo_spike_sound_gain;


    if (
        _dist >
        holo_spike_sound_inner_dist
    )
    {
        var _t =
            (
                _dist
                -
                holo_spike_sound_inner_dist
            )
            /
            max(
                1,
                holo_spike_sound_outer_dist
                -
                holo_spike_sound_inner_dist
            );


        _t =
            clamp(
                _t,
                0,
                1
            );


        _gain *=
            power(
                1 - _t,
                holo_spike_sound_falloff_curve
            );
    }


    if (_gain <= 0)
    {
        return;
    }


    // ------------------------------------------------
    // PLAY ONE-SHOT
    // ------------------------------------------------

    if (!audio_group_is_loaded(audiogroupsfx))
    {
        return;
    }


    var _voice =
        audio_play_sound(
            _sound,
            -50,
            false
        );


    if (_voice != -1)
    {
        audio_sound_gain(
            _voice,
            _gain,
            0
        );
    }
};