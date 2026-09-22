/// oBouncingScrapSpawner — Create


// ====================================================
// GENERAL
// ====================================================

enabled = true;
active  = false;

depth = 1000;


// ====================================================
// EDITOR VARIABLES
//
// scrap_size:
//     0 = small
//     1 = medium
//     2 = large
//     3 = random
//
// travel_direction:
//      1 = right
//     -1 = left
//
// spawn_mode:
//     0 = continuous
//     1 = single authored ball
//
// IMPORTANT:
//
// The stretched sprite / bbox is ONLY the activation
// trigger.
//
// Ball spawn position is based on this instance's
// x/y origin, NOT the trigger rectangle size.
// ====================================================

if (!variable_instance_exists(id, "scrap_size"))
{
    scrap_size = 1;
}


if (!variable_instance_exists(id, "travel_direction"))
{
    travel_direction = 1;
}


if (!variable_instance_exists(id, "spawn_interval_min_s"))
{
    spawn_interval_min_s = 0.75;
}


if (!variable_instance_exists(id, "spawn_interval_max_s"))
{
    spawn_interval_max_s = 1.25;
}


if (!variable_instance_exists(id, "horizontal_speed_mult"))
{
    horizontal_speed_mult = 1.0;
}


if (!variable_instance_exists(id, "bounce_height_mult"))
{
    bounce_height_mult = 1.0;
}


if (!variable_instance_exists(id, "spawn_width"))
{
    spawn_width = 160;
}


if (!variable_instance_exists(id, "spawn_x_offset"))
{
    spawn_x_offset = 0;
}


if (!variable_instance_exists(id, "spawn_y_offset"))
{
    spawn_y_offset = -64;
}


if (!variable_instance_exists(id, "start_immediately"))
{
    start_immediately = false;
}


if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// SINGLE-SPAWN VARIABLES
// ====================================================

if (!variable_instance_exists(id, "spawn_mode"))
{
    spawn_mode = 0;
}


if (!variable_instance_exists(id, "trigger_id"))
{
    trigger_id = 0;
}


if (!variable_instance_exists(id, "single_spawn_delay_s"))
{
    single_spawn_delay_s = 0.0;
}


// ====================================================
// NORMALIZE SETTINGS
// ====================================================

scrap_size =
    clamp(
        round(scrap_size),
        0,
        3
    );


travel_direction =
    (travel_direction < 0)
    ? -1
    : 1;


spawn_mode =
    clamp(
        round(spawn_mode),
        0,
        1
    );


trigger_id =
    round(trigger_id);


horizontal_speed_mult =
    max(
        0,
        horizontal_speed_mult
    );


bounce_height_mult =
    max(
        0,
        bounce_height_mult
    );


spawn_width =
    max(
        0,
        spawn_width
    );


single_spawn_delay_s =
    max(
        0,
        single_spawn_delay_s
    );


// ====================================================
// CONTINUOUS TIMING
// ====================================================

spawn_interval_min =
    max(
        1,
        round(
            spawn_interval_min_s *
            room_speed
        )
    );


spawn_interval_max =
    max(
        spawn_interval_min,
        round(
            spawn_interval_max_s *
            room_speed
        )
    );


spawn_timer =
    irandom_range(
        spawn_interval_min,
        spawn_interval_max
    );


// ====================================================
// SINGLE-SPAWN STATE
// ====================================================

single_fired = false;

single_triggered = false;

single_spawn_timer = 0;

player_was_inside = false;


// ====================================================
// EXTERNAL ACTIVATION
// ====================================================

force_active =
    start_immediately;


// ====================================================
// RANDOM SIZE
// ====================================================

choose_random_scrap_size =
function()
{
    return
        irandom_range(
            0,
            2
        );
};


// ====================================================
// SPAWN BALL
// ====================================================

spawn_bouncing_scrap =
function()
{
    // ------------------------------------------------
    // SPAWN POSITION
    //
    // SINGLE:
    // Exact authored position.
    //
    // CONTINUOUS:
    // Random X within spawn_width.
    //
    // Both use the spawner instance's x/y as the
    // anchor rather than its stretched bbox.
    // ------------------------------------------------

    var _spawn_x;


    if (spawn_mode == 1)
    {
        _spawn_x =
            x +
            spawn_x_offset;
    }
    else
    {
        _spawn_x =
            x
            +
            spawn_x_offset
            +
            random_range(
                -spawn_width * 0.5,
                 spawn_width * 0.5
            );
    }


    var _spawn_y =
        y +
        spawn_y_offset;


    // ------------------------------------------------
    // SIZE
    // ------------------------------------------------

    var _spawn_size =
        scrap_size;


    if (_spawn_size == 3)
    {
        _spawn_size =
            choose_random_scrap_size();
    }


    // ------------------------------------------------
    // CREATE BALL
    // ------------------------------------------------

    var _ball =
        instance_create_layer(
            _spawn_x,
            _spawn_y,
            "Instances",
            oBouncingScrap
        );


    if (_ball == noone)
    {
        return noone;
    }


    // ------------------------------------------------
    // CONFIGURE BALL
    // ------------------------------------------------

    _ball.scrap_size =
        _spawn_size;


    _ball.move_direction =
        travel_direction;


    _ball.horizontal_speed_mult =
        horizontal_speed_mult;


    _ball.bounce_height_mult =
        bounce_height_mult;


    _ball.setup_scrap();


    // ------------------------------------------------
    // FINAL HORIZONTAL VELOCITY
    // ------------------------------------------------

    var _base_hsp =
        _ball.medium_hsp;


    switch (_spawn_size)
    {
        case 0:
        {
            _base_hsp =
                _ball.small_hsp;
        }
        break;


        case 2:
        {
            _base_hsp =
                _ball.large_hsp;
        }
        break;
    }


    _ball.hsp =
        _base_hsp
        *
        horizontal_speed_mult
        *
        travel_direction;


    return _ball;
};