/// oAirVentLarge — Begin Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}


// ====================================================
// STATE MACHINE
// ====================================================


// ----------------------------------------------------
// CLOSED
// ----------------------------------------------------

if (vent_state == VENT_CLOSED)
{
    image_index =
        closed_frame;

    vent_anim_position =
        closed_frame;

    state_timer--;

    if (state_timer <= 0)
    {
        // Opening animation starts from artist frame 1.
        vent_state =
            VENT_OPENING;

        vent_anim_position =
            0;

        image_index =
            0;
    }
}


// ----------------------------------------------------
// OPENING
//
// Artist frames:
// 1 -> 2 -> 3
//
// GameMaker:
// 0 -> 1 -> 2
// ----------------------------------------------------

else if (vent_state == VENT_OPENING)
{
    vent_anim_position +=
        opening_speed;

    if (vent_anim_position >= open_frame)
    {
        vent_anim_position =
            open_frame;

        image_index =
            open_frame;

        vent_state =
            VENT_OPEN;

        state_timer =
            on_frames;
    }
    else
    {
        image_index =
            floor(
                vent_anim_position
            );
    }
}


// ----------------------------------------------------
// OPEN
// ----------------------------------------------------

else if (vent_state == VENT_OPEN)
{
    image_index =
        open_frame;

    vent_anim_position =
        open_frame;

    state_timer--;

    if (state_timer <= 0)
    {
        vent_state =
            VENT_CLOSING;

        vent_anim_position =
            open_frame;

        image_index =
            open_frame;
    }
}


// ----------------------------------------------------
// CLOSING
//
// Artist frames:
// 3 -> 4 -> 5
//
// GameMaker:
// 2 -> 3 -> 4
// ----------------------------------------------------

else if (vent_state == VENT_CLOSING)
{
    vent_anim_position +=
        closing_speed;

    if (vent_anim_position >= closed_frame)
    {
        vent_anim_position =
            closed_frame;

        image_index =
            closed_frame;

        vent_state =
            VENT_CLOSED;

        state_timer =
            off_frames;
    }
    else
    {
        image_index =
            floor(
                vent_anim_position
            );
    }
}


// ====================================================
// AIR ONLY EXISTS WHILE FULLY OPEN
// ====================================================

if (vent_state != VENT_OPEN)
{
    exit;
}


// ====================================================
// ADVANCE AIR ANIMATION
// ====================================================

wind_frame_position +=
    wind_animation_speed;


// ====================================================
// FIND PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}

if (
    variable_instance_exists(
        p,
        "state"
    )
    &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// AIR SPRITE DIMENSIONS
// ====================================================

var _air_width =
    sprite_get_width(
        spriteAirVentLargeAir
    );

var _air_height =
    sprite_get_height(
        spriteAirVentLargeAir
    );

var _tile_step =
    _air_width +
    air_tile_gap;


// ====================================================
// WIND LENGTH
// ====================================================

var _wind_length =
    air_repeats *
    _tile_step;


// ====================================================
// WIND START
//
// Air begins at the outward-facing side of the vent.
// ====================================================

var _vent_half_width =
    sprite_get_width(
        spriteAirVentLarge
    )
    *
    0.5
    *
    abs(image_xscale);

var _wind_start_x =
    x +
    direction *
    _vent_half_width;


// ====================================================
// WIND RECTANGLE
// ====================================================

var _wind_left;
var _wind_right;

if (direction > 0)
{
    _wind_left =
        _wind_start_x;

    _wind_right =
        _wind_start_x +
        _wind_length;
}
else
{
    _wind_left =
        _wind_start_x -
        _wind_length;

    _wind_right =
        _wind_start_x;
}


var _collision_height =
    _air_height *
    wind_collision_height_scale;

var _wind_top =
    y -
    _collision_height * 0.5;

var _wind_bottom =
    y +
    _collision_height * 0.5;


// ====================================================
// PLAYER / WIND OVERLAP
// ====================================================

var _inside_wind =
    p.bbox_right >
        _wind_left
    &&
    p.bbox_left <
        _wind_right
    &&
    p.bbox_bottom >
        _wind_top
    &&
    p.bbox_top <
        _wind_bottom;

if (!_inside_wind)
{
    exit;
}


// ====================================================
// APPLY HORIZONTAL WIND
//
// This does NOT replace the player's normal state.
//
// Jumping, charging, landing etc. continue to work.
// We only modify the resulting horizontal movement.
// ====================================================


// ----------------------------------------------------
// Is player currently trying to move AGAINST the wind?
//
// Wind right:
// negative hsp = fighting wind.
//
// Wind left:
// positive hsp = fighting wind.
// ----------------------------------------------------

var _moving_against_wind =
    (
        direction > 0 &&
        p.hsp < 0
    )
    ||
    (
        direction < 0 &&
        p.hsp > 0
    );


// ----------------------------------------------------
// HEAVILY REDUCE PROGRESS AGAINST WIND
// ----------------------------------------------------

if (_moving_against_wind)
{
    p.hsp *=
        against_wind_mult;
}


// ----------------------------------------------------
// CONSTANT WIND FORCE
//
// Even a stationary player is gradually pushed.
// ----------------------------------------------------

p.hsp +=
    direction *
    wind_strength;


// ----------------------------------------------------
// LIMIT SPEED IN WIND DIRECTION
// ----------------------------------------------------

if (direction > 0)
{
    p.hsp =
        min(
            p.hsp,
            wind_max_speed
        );
}
else
{
    p.hsp =
        max(
            p.hsp,
            -wind_max_speed
        );
}