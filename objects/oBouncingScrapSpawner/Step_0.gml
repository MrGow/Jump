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
// PLAYER INSIDE TRIGGER
//
// The bbox is ONLY used for activation.
// Resizing the trigger does not change spawn position.
// ====================================================

var _player_inside =
    false;


if (_player_valid)
{
    _player_inside =
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
// SINGLE AUTHORED MODE
// ====================================================

if (spawn_mode == 1)
{
    // ------------------------------------------------
    // ALREADY FIRED
    // ------------------------------------------------

    if (single_fired)
    {
        active = false;

        player_was_inside =
            _player_inside;

        exit;
    }


    // ------------------------------------------------
    // DETECT PLAYER ENTERING TRIGGER
    // ------------------------------------------------

    var _entered =
        _player_inside
        &&
        !player_was_inside;


    if (
        !single_triggered
        &&
        (
            _entered
            ||
            force_active
        )
    )
    {
        single_triggered =
            true;


        active =
            true;


        single_spawn_timer =
            round(
                single_spawn_delay_s *
                room_speed
            );
    }


    // ------------------------------------------------
    // EXACT AUTHORED COUNTDOWN
    //
    // Once triggered, leaving the trigger does not
    // cancel the spawn.
    // ------------------------------------------------

    if (single_triggered)
    {
        active = true;


        if (single_spawn_timer > 0)
        {
            single_spawn_timer--;
        }
        else
        {
            // ========================================
            // SPAWN EXACTLY ONE BALL
            // ========================================

            spawn_bouncing_scrap();


            single_fired =
                true;


            single_triggered =
                false;


            active =
                false;
        }
    }
    else
    {
        active = false;
    }


    player_was_inside =
        _player_inside;


    exit;
}


// ====================================================
// CONTINUOUS MODE
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
        _player_inside;
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
// SPAWN BALL
// ====================================================

spawn_bouncing_scrap();


// ====================================================
// NEXT SPAWN
// ====================================================

spawn_timer =
    irandom_range(
        spawn_interval_min,
        spawn_interval_max
    );