/// oBouncingScrap — Create


event_inherited();


// ====================================================
// GENERAL
// ====================================================

enabled = true;
active  = true;

depth = -1500;


// ====================================================
// SPAWNER INPUT
// ====================================================

scrap_size = 1;

move_direction = 1;

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
// ====================================================

// SMALL
small_hsp = 2.5;
small_bounce_vsp = -9.0;


// MEDIUM
medium_hsp = 2.1;
medium_bounce_vsp = -6.5;


// LARGE
large_hsp = 1.7;
large_bounce_vsp = -4.5;


// ====================================================
// CURRENT BALL VALUES
// ====================================================

bounce_vsp =
    medium_bounce_vsp;


// ====================================================
// ANIMATION
//
// Sprite sheets already contain the spinning.
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


// Visual floor line.
//
// Area floor tiles are oblique and characters visually
// sit 8 pixels into them. Scrap uses the same inset.

floor_visual_inset = 8;


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
            _bottom + _max_distance + floor_visual_inset,
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


        // ============================================
        // 8 PX OBLIQUE FLOOR INSET
        // ============================================

        _surface_y +=
            floor_visual_inset;


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


    // =================================================
    // SMALL
    // =================================================

    if (scrap_size == 0)
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


    // =================================================
    // LARGE
    // =================================================

    else if (scrap_size == 2)
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


    // =================================================
    // MEDIUM
    // =================================================

    else
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


    // =================================================
    // ANIMATION
    // =================================================

    image_index =
        irandom(
            max(
                0,
                image_number - 1
            )
        );


    image_speed =
        normal_image_speed;


    image_angle = 0;


    // =================================================
    // INITIAL FALL
    // =================================================

    vsp = 0;

    bounce_lock = 0;
};


// ====================================================
// DEFAULT SETUP
// ====================================================

setup_scrap();