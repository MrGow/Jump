/// oMechaSoldierLaserShot — Step


// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    exit;
}


// Keep projectile animation running at normal speed.
image_speed = 1;


// ====================================================
// LIFETIME
// ====================================================

life_frames--;


if (life_frames <= 0)
{
    instance_destroy();

    exit;
}


// ====================================================
// KEEP SPRITE ALIGNED WITH MOVEMENT
// ====================================================

image_angle =
    move_angle;


// ====================================================
// MOVEMENT VECTOR
// ====================================================

var _dx =
    lengthdir_x(
        move_speed,
        move_angle
    );


var _dy =
    lengthdir_y(
        move_speed,
        move_angle
    );


var _distance =
    point_distance(
        0,
        0,
        _dx,
        _dy
    );


if (_distance <= 0)
{
    exit;
}


// ====================================================
// SUBSTEP MOVEMENT
// ====================================================

var _steps =
    max(
        1,
        ceil(
            _distance /
            max_move_substep
        )
    );


var _step_x =
    _dx /
    _steps;


var _step_y =
    _dy /
    _steps;


// ====================================================
// MOVE / COLLIDE
// ====================================================

for (
    var _i = 0;
    _i < _steps;
    _i++
)
{
    var _next_x =
        x +
        _step_x;


    var _next_y =
        y +
        _step_y;


    // ------------------------------------------------
    // LEVEL GEOMETRY
    // ------------------------------------------------

    if (
        laser_solid_at(
            _next_x,
            _next_y
        )
    )
    {
        instance_destroy();

        exit;
    }


    // ------------------------------------------------
    // MOVE
    // ------------------------------------------------

    x =
        _next_x;


    y =
        _next_y;


    // ------------------------------------------------
    // PLAYER
    // ------------------------------------------------

    var _p =
        instance_place(
            x,
            y,
            oPlayer
        );


    if (_p != noone)
    {
        if (
            !variable_instance_exists(
                _p,
                "state"
            )
            ||
            _p.state != "dead"
        )
        {
            with (_p)
            {
                //scr_player_died();
            }
        }


        instance_destroy();

        exit;
    }
}