/// oBouncingScrapSpawner — Create


// ====================================================
// GENERAL
// ====================================================

enabled = true;

active = false;

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
// direction:
//     1 = right
//    -1 = left
// ====================================================

if (!variable_instance_exists(id, "scrap_size"))
{
    scrap_size = 1;
}


if (!variable_instance_exists(id, "direction"))
{
    direction = 1;
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


if (!variable_instance_exists(id, "spawn_y_offset"))
{
    spawn_y_offset = 48;
}


if (!variable_instance_exists(id, "spawn_edge_inset"))
{
    spawn_edge_inset = 20;
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
// NORMALIZE SETTINGS
// ====================================================

scrap_size =
    clamp(
        round(scrap_size),
        0,
        3
    );


direction =
    (direction < 0)
    ? -1
    : 1;


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


spawn_edge_inset =
    max(
        0,
        spawn_edge_inset
    );


// ====================================================
// TIMING
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
// EXTERNAL ACTIVATION
//
// If start_immediately is false, the player's overlap
// with the rectangle activates the spawner.
//
// This variable also gives another controller the
// ability to force the spawner on later if required.
//
// Example:
//
//     spawner.force_active = true;
//
// ====================================================

force_active =
    start_immediately;


// ====================================================
// CHOOSE RANDOM SIZE
// ====================================================

choose_random_scrap_size =
function()
{
    // Equal random selection.
    //
    // Individual encounters can instead use a fixed
    // size through scrap_size 0/1/2.

    return
        irandom_range(
            0,
            2
        );
};