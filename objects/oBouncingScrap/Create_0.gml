/// oBouncingScrap — Create


event_inherited();


// ====================================================
// GENERAL
// ====================================================

enabled = true;

active = true;

depth = -100;


// ====================================================
// SPAWNER INPUT
//
// scrap_size:
//     0 = small
//     1 = medium
//     2 = large
//
// move_direction:
//      1 = right
//     -1 = left
// ====================================================

scrap_size = 1;

move_direction = 1;


// Per-spawner modifiers.
//
// The spawner overwrites these before calling
// setup_scrap().

horizontal_speed_mult = 1.0;

bounce_height_mult = 1.0;


// ====================================================
// PHYSICS
// ====================================================

hsp = 0;
vsp = 0;

gravity_amount = 0.30;

maximum_fall_speed = 12;


// ====================================================
// BASE SIZE TUNING
//
// These are the MASTER values.
//
// Spawner multipliers modify these without changing
// the fundamental relationship between ball sizes.
// ====================================================


// ----------------------------------------------------
// SMALL
//
// Highest bounce.
// Fastest horizontal travel.
// Most generous window underneath.
// ----------------------------------------------------

small_hsp =
    2.5;

small_bounce_vsp =
    -9.0;


// ----------------------------------------------------
// MEDIUM
// ----------------------------------------------------

medium_hsp =
    2.1;

medium_bounce_vsp =
    -6.5;


// ----------------------------------------------------
// LARGE
//
// Lowest bounce.
// Slowest horizontal movement.
// Least space/time underneath.
// ----------------------------------------------------

large_hsp =
    1.7;

large_bounce_vsp =
    -4.5;


// ====================================================
// CURRENT BALL VALUES
// ====================================================

bounce_vsp =
    medium_bounce_vsp;


// ====================================================
// ANIMATION
//
// The sprites already contain their spinning
// animation.
//
// Do NOT rotate the instance with image_angle.
// ====================================================

normal_image_speed = 1;

image_speed =
    normal_image_speed;

image_angle = 0;


// ====================================================
// COLLISION
// ====================================================

kill_inset_x = 2;
kill_inset_y = 2;


// ====================================================
// FLOOR COLLISION
// ====================================================

ground_probe_max = 16;

ground_min_overlap = 4;

bounce_lock = 0;


// ====================================================
// LIFETIME
// ====================================================

life_timer =
    room_speed * 12;


// ====================================================
// FIND FLOOR
// ====================================================

scrap_find_floor =
function(_max_distance)
{
    var _floor_obj =
        asset_get_index(
            "oFloorSurface"
        );


    if (_floor_obj == -1)
    {
        return [
            noone,
            999999
        ];
    }


    var _best =
        noone;


    var _best_dy =
        999999;


    var _left =
        bbox_left;


    var _right =
        bbox_right;


    var _bottom =
        bbox_bottom;


    var _list =
        ds_list_create();


    var _count =
        collision_rectangle_list(
            _left,
            _bottom - 2,
            _right,
            _bottom + _max_distance,
            _floor_obj,
            false,
            true,
            _list,
            false
        );


    for (
        var _i = 0;
        _i < _count;
        _i++
    )
    {
        var _surface =
            _list[| _i];


        if (!instance_exists(_surface))
        {
            continue;
        }


        if (
            variable_instance_exists(
                _surface,
                "enabled"
            )
            &&
            !_surface.enabled
        )
        {
            continue;
        }


        if (
            variable_instance_exists(
                _surface,
                "active"
            )
            &&
            !_surface.active
        )
        {
            continue;
        }


        var _surface_left =
            _surface.bbox_left;


        var _surface_right =
            _surface.bbox_right;


        if (
            variable_instance_exists(
                _surface,
                "surface_inset_left"
            )
        )
        {
            _surface_left +=
                _surface.surface_inset_left;
        }


        if (
            variable_instance_exists(
                _surface,
                "surface_inset_right"
            )
        )
        {
            _surface_right -=
                _surface.surface_inset_right;
        }


        var _surface_y =
            _surface.bbox_top;


        if (
            variable_instance_exists(
                _surface,
                "surface_y"
            )
        )
        {
            _surface_y =
                _surface.surface_y;
        }


        var _overlap =
            min(
                _right,
                _surface_right
            )
            -
            max(
                _left,
                _surface_left
            );


        if (
            _overlap <
            ground_min_overlap
        )
        {
            continue;
        }


        var _dy =
            _surface_y -
            _bottom;


        if (_dy < -2)
        {
            continue;
        }


        if (
            _dy >
            _max_distance
        )
        {
            continue;
        }


        if (_dy < _best_dy)
        {
            _best =
                _surface;


            _best_dy =
                _dy;
        }
    }


    ds_list_destroy(
        _list
    );


    return [
        _best,
        _best_dy
    ];
};


// ====================================================
// SETUP SCRAP
//
// Called by the spawner after assigning:
//
//     scrap_size
//     move_direction
//     horizontal_speed_mult
//     bounce_height_mult
//
// A manually placed ball also receives the default
// medium setup at the end of Create.
// ====================================================

setup_scrap =
function()
{
    scrap_size =
        clamp(
            round(scrap_size),
            0,
            2
        );


    move_direction =
        (move_direction < 0)
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


    switch (scrap_size)
    {
        // --------------------------------------------
        // SMALL
        // --------------------------------------------

        case 0:
        {
            sprite_index =
                spriteBouncingScrapSmall;


            hsp =
                small_hsp
                *
                horizontal_speed_mult
                *
                move_direction;


            bounce_vsp =
                small_bounce_vsp
                *
                bounce_height_mult;
        }
        break;


        // --------------------------------------------
        // LARGE
        // --------------------------------------------

        case 2:
        {
            sprite_index =
                spriteBouncingScrapLarge;


            hsp =
                large_hsp
                *
                horizontal_speed_mult
                *
                move_direction;


            bounce_vsp =
                large_bounce_vsp
                *
                bounce_height_mult;
        }
        break;


        // --------------------------------------------
        // MEDIUM
        // --------------------------------------------

        default:
        {
            scrap_size = 1;


            sprite_index =
                spriteBouncingScrapMedium;


            hsp =
                medium_hsp
                *
                horizontal_speed_mult
                *
                move_direction;


            bounce_vsp =
                medium_bounce_vsp
                *
                bounce_height_mult;
        }
        break;
    }


    // ------------------------------------------------
    // ANIMATION
    // ------------------------------------------------

    image_index =
        irandom(
            max(
                0,
                image_number - 1
            )
        );


    image_speed =
        normal_image_speed;


    // Artwork itself spins.
    image_angle = 0;


    // ------------------------------------------------
    // INITIAL FALL
    // ------------------------------------------------

    vsp = 0;


    bounce_lock = 0;
};


// ====================================================
// DEFAULT SETUP
//
// A manually placed ball becomes a normal medium ball.
// The spawner calls setup_scrap() again immediately
// after assigning its authored settings.
// ====================================================

setup_scrap();