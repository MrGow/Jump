
/// oHoloSpikes — Step

// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "extension"))
    extension = 0;

if (!variable_instance_exists(id, "state_timer"))
    state_timer = 0;

if (!variable_instance_exists(id, "extension_distance"))
    extension_distance = 64;

if (!variable_instance_exists(id, "extend_frames"))
    extend_frames = 16;

if (!variable_instance_exists(id, "retract_frames"))
    retract_frames = 16;

if (!variable_instance_exists(id, "spike_grace_fraction"))
    spike_grace_fraction = 0.15;

if (!variable_instance_exists(id, "hit_pad"))
    hit_pad = 2;

if (!variable_instance_exists(id, "spike_side_offset"))
    spike_side_offset = 5;


// ====================================================
// NORMALISE SETTINGS
// ====================================================

spike_direction =
    ((round(spike_direction) mod 4) + 4) mod 4;

var _max_ext =
    max(0, extension_distance);

var _extend_duration =
    max(1, round(extend_frames));

var _retract_duration =
    max(1, round(retract_frames));

var _grace =
    clamp(spike_grace_fraction, 0, 1);


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active = false;

    state = "retracted";

    extension = 0;

    state_timer =
        max(
            0,
            round(retracted_time_s * room_speed)
        );

    exit;
}


// ====================================================
// STATE MACHINE
// ====================================================

switch (state)
{
    // ------------------------------------------------
    // RETRACTED
    //
    // Completely harmless.
    // ------------------------------------------------

    case "retracted":
    {
        active = false;

        extension = 0;

        state_timer--;

        if (state_timer <= 0)
        {
            state = "extending";

            state_timer = 0;

            holo_spike_play_sound(
                snd_holo_extend
            );
        }
    }
    break;


    // ------------------------------------------------
    // EXTENDING
    //
    // Initially harmless.
    //
    // Becomes lethal once extension exceeds
    // the configured grace fraction.
    // ------------------------------------------------

    case "extending":
    {
        state_timer++;

        extension =
            _max_ext *
            min(
                1,
                state_timer / _extend_duration
            );

        // Grace period ends once enough of the
        // spike has emerged from the base.

        active =
            extension > _max_ext * _grace;


        if (state_timer >= _extend_duration)
        {
            extension = _max_ext;

            active = (_max_ext > 0);

            state = "extended";

            state_timer =
                max(
                    0,
                    round(up_time_s * room_speed)
                );
        }
    }
    break;


    // ------------------------------------------------
    // EXTENDED
    //
    // Fully extended and lethal.
    // ------------------------------------------------

    case "extended":
    {
        active = (_max_ext > 0);

        extension = _max_ext;

        state_timer--;

        if (state_timer <= 0)
        {
            state = "retracting";

            state_timer = 0;

            holo_spike_play_sound(
                snd_holo_retract
            );
        }
    }
    break;


    // ------------------------------------------------
    // RETRACTING
    //
    // Initially lethal.
    //
    // Becomes harmless again when extension
    // returns to the grace area.
    // ------------------------------------------------

    case "retracting":
    {
        state_timer++;

        extension =
            _max_ext *
            (
                1 -
                min(
                    1,
                    state_timer / _retract_duration
                )
            );

        active =
            extension > _max_ext * _grace;


        if (state_timer >= _retract_duration)
        {
            extension = 0;

            active = false;

            state = "retracted";

            state_timer =
                max(
                    0,
                    round(retracted_time_s * room_speed)
                );
        }
    }
    break;


    // ------------------------------------------------
    // SAFETY
    // ------------------------------------------------

    default:
    {
        state = "retracted";

        extension = 0;

        active = false;

        state_timer =
            max(
                0,
                round(retracted_time_s * room_speed)
            );
    }
    break;
}


// ====================================================
// ONLY CHECK COLLISION WHILE LETHAL
// ====================================================

if (!active)
{
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

var _p =
    instance_find(
        oPlayer,
        0
    );

if (_p == noone)
{
    exit;
}

if (
    variable_instance_exists(_p, "state")
    &&
    _p.state == "dead"
)
{
    exit;
}


// ====================================================
// COLLISION
//
// UNCHANGED from your current Step event.
//
// Includes the existing spike sideways offset,
// collision dimensions and pointed-end reach.
// ====================================================

var _side_x = 0;
var _side_y = 0;

switch (spike_direction)
{
    case 0:
        _side_x = 1;
        _side_y = 0;
    break;

    case 1:
        _side_x = 0;
        _side_y = 1;
    break;

    case 2:
        _side_x = -1;
        _side_y = 0;
    break;

    case 3:
        _side_x = 0;
        _side_y = -1;
    break;
}


var _cx =
    x + _side_x * spike_side_offset;

var _cy =
    y + _side_y * spike_side_offset;


var _pad =
    max(0, hit_pad);


// Original collision reach.
// Do not change these alignment values.

var _start = 4;

var _end = extension + 7;


if (_end <= _start)
{
    exit;
}


var _left;
var _right;
var _top;
var _bottom;


switch (spike_direction)
{
    case 0: // Up
    {
        _left = _cx - 5;
        _right = _cx + 5;

        _top = _cy - _end;
        _bottom = _cy - _start;
    }
    break;


    case 1: // Right
    {
        _left = _cx + _start;
        _right = _cx + _end;

        _top = _cy - 5;
        _bottom = _cy + 5;
    }
    break;


    case 2: // Down
    {
        _left = _cx - 5;
        _right = _cx + 5;

        _top = _cy + _start;
        _bottom = _cy + _end;
    }
    break;


    default: // Left
    {
        _left = _cx - _end;
        _right = _cx - _start;

        _top = _cy - 5;
        _bottom = _cy + 5;
    }
    break;
}


// ====================================================
// PLAYER OVERLAP
// ====================================================

var _hit =
    _p.bbox_right > _left + _pad
    &&
    _p.bbox_left < _right - _pad
    &&
    _p.bbox_bottom > _top + _pad
    &&
    _p.bbox_top < _bottom - _pad;


// ====================================================
// KILL PLAYER
// ====================================================

if (_hit)
{
    with (_p)
    {
        scr_player_died();
    }
}
