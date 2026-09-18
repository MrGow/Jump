/// oBouncingScrapSpawner — Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active = false;

    exit;
}


// ====================================================
// PLAYER
// ====================================================

var _player =
    instance_find(
        oPlayer,
        0
    );


var _player_valid =
    instance_exists(
        _player
    );


if (_player_valid)
{
    if (
        variable_instance_exists(
            _player,
            "state"
        )
        &&
        _player.state == "dead"
    )
    {
        _player_valid =
            false;
    }
}


// ====================================================
// ACTIVATION
//
// start_immediately:
//     Begins active immediately.
//
// force_active:
//     Allows another controller to activate it.
//
// Otherwise:
//     Player must overlap the spawner's editor
//     rectangle.
// ====================================================

active =
    force_active;


if (
    !active
    &&
    _player_valid
)
{
    active =
        _player.bbox_right >
            bbox_left
        &&
        _player.bbox_left <
            bbox_right
        &&
        _player.bbox_bottom >
            bbox_top
        &&
        _player.bbox_top <
            bbox_bottom;
}


// ====================================================
// NOT ACTIVE
// ====================================================

if (!active)
{
    exit;
}


// ====================================================
// SPAWN TIMER
// ====================================================

spawn_timer--;


if (spawn_timer > 0)
{
    exit;
}


// ====================================================
// SPAWN AREA
//
// The width of the editor rectangle determines the
// horizontal spawn range.
//
// Balls appear above the TOP of the rectangle.
// ====================================================

var _spawn_left =
    bbox_left +
    spawn_edge_inset;


var _spawn_right =
    bbox_right -
    spawn_edge_inset;


// Narrow-trigger safety.

if (_spawn_right < _spawn_left)
{
    var _middle =
        (
            bbox_left +
            bbox_right
        )
        * 0.5;


    _spawn_left =
        _middle;


    _spawn_right =
        _middle;
}


var _spawn_x =
    random_range(
        _spawn_left,
        _spawn_right
    );


var _spawn_y =
    bbox_top -
    spawn_y_offset;


// ====================================================
// SIZE
// ====================================================

var _spawn_size =
    scrap_size;


if (_spawn_size == 3)
{
    _spawn_size =
        choose_random_scrap_size();
}


// ====================================================
// CREATE BALL
// ====================================================

var _ball =
    instance_create_layer(
        _spawn_x,
        _spawn_y,
        "Instances",
        oBouncingScrap
    );


if (_ball != noone)
{
    _ball.scrap_size =
        _spawn_size;


    _ball.move_direction =
        direction;


    _ball.horizontal_speed_mult =
        horizontal_speed_mult;


    _ball.bounce_height_mult =
        bounce_height_mult;


    _ball.setup_scrap();
}


// ====================================================
// NEXT SPAWN
// ====================================================

spawn_timer =
    irandom_range(
        spawn_interval_min,
        spawn_interval_max
    );