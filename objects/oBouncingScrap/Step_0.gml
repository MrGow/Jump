/// oBouncingScrap — Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    image_speed = 0;

    exit;
}


// ====================================================
// ANIMATION
// ====================================================

image_speed =
    normal_image_speed;

image_angle = 0;


// ====================================================
// TIMERS
// ====================================================

if (bounce_lock > 0)
{
    bounce_lock--;
}


life_timer--;


if (life_timer <= 0)
{
    instance_destroy();

    exit;
}


// ====================================================
// HORIZONTAL MOVEMENT
// ====================================================

x += hsp;


// ====================================================
// GRAVITY
// ====================================================

vsp +=
    gravity_amount;


vsp =
    min(
        vsp,
        maximum_fall_speed
    );


// ====================================================
// VERTICAL MOVEMENT
// ====================================================

if (vsp > 0)
{
    var _remaining_y =
        vsp;


    while (_remaining_y > 0)
    {
        var _step_y =
            min(
                1,
                _remaining_y
            );


        y +=
            _step_y;


        _remaining_y -=
            _step_y;


        var _floor =
            scrap_find_floor(
                2
            );


        if (
            _floor[0] != noone
            &&
            _floor[1] <= 0
            &&
            _floor[1] >= -2
        )
        {
            // ========================================
            // SNAP TO 8 PX INSET FLOOR LINE
            // ========================================

            y +=
                _floor[1];


            // ========================================
            // BOUNCE
            // ========================================

            if (bounce_lock <= 0)
            {
                vsp =
                    bounce_vsp;


                bounce_lock = 3;
            }


            break;
        }
    }
}
else
{
    y +=
        vsp;
}


// ====================================================
// PLAYER
// ====================================================

var _player =
    instance_find(
        oPlayer,
        0
    );


if (_player == noone)
{
    exit;
}


if (
    variable_instance_exists(
        _player,
        "state"
    )
    &&
    _player.state == "dead"
)
{
    exit;
}


// ====================================================
// PLAYER COLLISION
// ====================================================

var _left =
    bbox_left +
    kill_inset_x;


var _right =
    bbox_right -
    kill_inset_x;


var _top =
    bbox_top +
    kill_inset_y;


var _bottom =
    bbox_bottom -
    kill_inset_y;


var _hit =
    _player.bbox_right >
        _left
    &&
    _player.bbox_left <
        _right
    &&
    _player.bbox_bottom >
        _top
    &&
    _player.bbox_top <
        _bottom;


// ====================================================
// KILL PLAYER
// ====================================================

if (_hit)
{
    with (_player)
    {
        scr_player_died();
    }
}