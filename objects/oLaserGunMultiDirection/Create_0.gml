/// oLaserGunMultiDirection — Create

event_inherited();

enabled = true;
active  = false;

solid_body = false;
solid_only_when_active = false;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    asset_get_index(
        "spriteLaserGunMultiDirection"
    );

image_speed = 0;
image_index = 0;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Optional patrol
// ----------------------------------------------------

if (!variable_instance_exists(id, "patrol_enabled"))
{
    patrol_enabled = false;
}

if (!variable_instance_exists(id, "patrol_id"))
{
    patrol_id = "";
}

if (!variable_instance_exists(id, "patrol_speed"))
{
    patrol_speed = 1.5;
}


// ----------------------------------------------------
// Firing timing
// ----------------------------------------------------

if (!variable_instance_exists(id, "wait_time_s"))
{
    wait_time_s = 2.0;
}

if (!variable_instance_exists(id, "fire_hold_time_s"))
{
    fire_hold_time_s = 0.70;
}


// ====================================================
// SHOOTING ANIMATION
//
// The final two subimages of the sprite are always the
// active firing loop. This avoids confusion between
// human frame counting and GameMaker's zero-based
// image_index values.
// ====================================================

if (!variable_instance_exists(id, "anim_speed"))
{
    // Approximately 11 sprite frames per second at
    // a 60 FPS game speed.
    anim_speed = 0.18;
}


// ----------------------------------------------------
// AUTOMATIC FIRING-FRAME RANGE
// ----------------------------------------------------

var gun_frame_count =
    max(
        1,
        sprite_get_number(sprite_index)
    );

fire_loop_end_frame =
    gun_frame_count - 1;

fire_loop_start_frame =
    max(
        0,
        gun_frame_count - 2
    );

fire_frame =
    fire_loop_start_frame;


// Separate firing-loop timer.
// Do not use image_index itself as the timer.
fire_anim_pos = 0;


// ----------------------------------------------------
// Laser length / collision
// ----------------------------------------------------

if (!variable_instance_exists(id, "max_laser_length"))
{
    max_laser_length = 640;
}


// Smaller step = more accurate wall stopping.
if (!variable_instance_exists(id, "ray_step"))
{
    ray_step = 2;
}


// Distance from gun centre to logical muzzle point.
if (!variable_instance_exists(id, "laser_start_dist"))
{
    laser_start_dist = 25;
}


// Prevent old room/editor values such as 34 from
// reintroducing the visible muzzle gap.
laser_start_dist =
    min(
        laser_start_dist,
        25
    );


// Visual beam overlaps backwards into muzzle.
if (!variable_instance_exists(id, "laser_visual_muzzle_overlap"))
{
    laser_visual_muzzle_overlap = 4;
}


// Visual beam overlaps slightly underneath impact FX.
if (!variable_instance_exists(id, "laser_visual_end_overlap"))
{
    laser_visual_end_overlap = 3;
}


// Lethal detection begins slightly behind ray start.
if (!variable_instance_exists(id, "laser_hit_start_back"))
{
    laser_hit_start_back = 5;
}


// Beam collision half-thickness.
if (!variable_instance_exists(id, "laser_hit_pad"))
{
    laser_hit_pad = 3;
}


// ----------------------------------------------------
// Debug
// ----------------------------------------------------

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// EIGHT DIRECTIONS
// ====================================================
//
//      90
//       ↑
//
//   135   45
//    ↖     ↗
//
// 180 ← ● → 0
//
//    ↙     ↘
//   225   315
//
//       ↓
//      270
//
// ====================================================

laser_dirs =
[
    0,
    45,
    90,
    135,
    180,
    225,
    270,
    315
];

laser_count =
    array_length(
        laser_dirs
    );


// ====================================================
// BEAM DATA
// ====================================================

laser_start_x =
    array_create(
        laser_count,
        x
    );

laser_start_y =
    array_create(
        laser_count,
        y
    );

laser_end_x =
    array_create(
        laser_count,
        x
    );

laser_end_y =
    array_create(
        laser_count,
        y
    );

laser_len =
    array_create(
        laser_count,
        0
    );

laser_fx_frame =
    0;


// ====================================================
// PATROL ROUTE
// ====================================================

patrol_start_x = x;
patrol_start_y = y;

patrol_end_x = x;
patrol_end_y = y;

patrol_point = noone;

patrol_t = 0;
patrol_direction = 1;


// ====================================================
// PATROL POINT FINDER
// ====================================================

find_patrol_point = function()
{
    patrol_point =
        noone;

    patrol_end_x =
        patrol_start_x;

    patrol_end_y =
        patrol_start_y;


    if (!patrol_enabled)
    {
        return;
    }


    if (string(patrol_id) == "")
    {
        if (debug_draw)
        {
            show_debug_message(
                "oLaserGunMultiDirection: patrol_enabled but patrol_id is blank."
            );
        }

        return;
    }


    var point_obj =
        asset_get_index(
            "oFloatingLaserGunPatrolPoint"
        );


    if (point_obj == -1)
    {
        return;
    }


    var count =
        instance_number(
            point_obj
        );


    for (
        var i = 0;
        i < count;
        i++
    )
    {
        var pt =
            instance_find(
                point_obj,
                i
            );


        if (pt == noone)
        {
            continue;
        }


        var point_enabled =
            !variable_instance_exists(
                pt,
                "enabled"
            )
            ||
            pt.enabled;


        if (!point_enabled)
        {
            continue;
        }


        if (
            variable_instance_exists(
                pt,
                "patrol_id"
            )
            &&
            string(pt.patrol_id)
            ==
            string(patrol_id)
        )
        {
            patrol_point =
                pt;

            patrol_end_x =
                pt.x;

            patrol_end_y =
                pt.y;

            return;
        }
    }


    if (debug_draw)
    {
        show_debug_message(
            "oLaserGunMultiDirection: no patrol point matched patrol_id = "
            +
            string(patrol_id)
        );
    }
};


// ====================================================
// TIMING
// ====================================================

wait_frames =
    max(
        1,
        round(
            room_speed *
            wait_time_s
        )
    );


fire_hold_frames =
    max(
        1,
        round(
            room_speed *
            fire_hold_time_s
        )
    );


state =
    "waiting";

timer =
    wait_frames;

fire_timer =
    0;


// ====================================================
// AUDIO
// ====================================================

snd_laser_shoot =
    -1;

laser_shoot_gain =
    0.9;

laser_sfx_inner_dist =
    120;

laser_sfx_outer_dist =
    520;

laser_shot_sfx_played =
    false;


// ====================================================
// LASER SFX
// ====================================================

play_laser_sfx = function()
{
    if (snd_laser_shoot == -1)
    {
        return;
    }


    var p =
        instance_find(
            oPlayer,
            0
        );


    if (p == noone)
    {
        return;
    }


    var dist =
        point_distance(
            x,
            y,
            p.x,
            p.y
        );


    if (dist >= laser_sfx_outer_dist)
    {
        return;
    }


    var gain =
        1;


    if (dist > laser_sfx_inner_dist)
    {
        var t =
            (
                dist -
                laser_sfx_inner_dist
            )
            /
            max(
                1,
                laser_sfx_outer_dist -
                laser_sfx_inner_dist
            );


        gain =
            1 -
            clamp(
                t,
                0,
                1
            );
    }


    scr_play_sfx(
        snd_laser_shoot,
        laser_shoot_gain *
        gain,
        random_range(
            0.98,
            1.02
        )
    );
};


// ====================================================
// DOES THIS INSTANCE BLOCK A LASER?
// ====================================================

laser_instance_blocks =
function(_inst)
{
    if (_inst == noone)
    {
        return false;
    }


    // ------------------------------------------------
    // NEVER HIT OUR OWN COLLISION HELPER
    // ------------------------------------------------

    if (
        variable_instance_exists(
            _inst,
            "owner_gun"
        )
        &&
        _inst.owner_gun == id
    )
    {
        return false;
    }


    // Extra direct safety.
    if (
        variable_instance_exists(
            id,
            "solid_inst"
        )
        &&
        instance_exists(
            solid_inst
        )
        &&
        _inst == solid_inst
    )
    {
        return false;
    }


    // ------------------------------------------------
    // DISABLED / INACTIVE BLOCKERS
    // ------------------------------------------------

    if (
        variable_instance_exists(
            _inst,
            "enabled"
        )
        &&
        !_inst.enabled
    )
    {
        return false;
    }


    if (
        variable_instance_exists(
            _inst,
            "active"
        )
        &&
        !_inst.active
    )
    {
        return false;
    }


    return true;
};


// ====================================================
// BEAM SOLID TEST
//
// IMPORTANT:
//
// This checks ALL dynamic-solid instances at the point
// rather than calling instance_position() once.
//
// That matters because oLaserGunMultiDirectionSolid is
// itself a dynamic solid. The gun must ignore its OWN
// helper while still recognising another real solid at
// the same position.
// ====================================================

laser_point_hits_solid =
function(_x, _y)
{
    // =================================================
    // SOLIDS TILEMAP
    // =================================================

    if (layer_exists("Solids"))
    {
        var lid =
            layer_get_id(
                "Solids"
            );


        if (lid != -1)
        {
            var tm =
                layer_tilemap_get_id(
                    lid
                );


            if (tm != -1)
            {
                if (
                    tilemap_get_at_pixel(
                        tm,
                        _x,
                        _y
                    )
                    != 0
                )
                {
                    return true;
                }
            }
        }
    }


    // =================================================
    // DYNAMIC SOLIDS
    //
    // Collect every overlapping oSolidDyn and skip only
    // this gun's own helper.
    // =================================================

    var dyn_obj =
        asset_get_index(
            "oSolidDyn"
        );


    if (dyn_obj != -1)
    {
        var dyn_list =
            ds_list_create();


        var dyn_count =
            collision_point_list(
                _x,
                _y,
                dyn_obj,
                false,
                true,
                dyn_list,
                false
            );


        for (
            var di = 0;
            di < dyn_count;
            di++
        )
        {
            var dyn =
                dyn_list[| di];


            if (!instance_exists(dyn))
            {
                continue;
            }


            // ----------------------------------------
            // Ignore THIS gun's helper.
            // ----------------------------------------

            if (
                variable_instance_exists(
                    dyn,
                    "owner_gun"
                )
                &&
                dyn.owner_gun == id
            )
            {
                continue;
            }


            if (
                !laser_instance_blocks(
                    dyn
                )
            )
            {
                continue;
            }


            ds_list_destroy(
                dyn_list
            );

            return true;
        }


        ds_list_destroy(
            dyn_list
        );
    }


    // =================================================
    // SOLID-BODY HAZARDS
    // =================================================

    var hazard_obj =
        asset_get_index(
            "oHazard"
        );


    if (hazard_obj != -1)
    {
        var hazard_list =
            ds_list_create();


        var hazard_count =
            collision_point_list(
                _x,
                _y,
                hazard_obj,
                false,
                true,
                hazard_list,
                false
            );


        for (
            var hi = 0;
            hi < hazard_count;
            hi++
        )
        {
            var hz =
                hazard_list[| hi];


            if (!instance_exists(hz))
            {
                continue;
            }


            // Never treat this gun itself as a blocker.
            if (hz == id)
            {
                continue;
            }


            if (
                !laser_instance_blocks(
                    hz
                )
            )
            {
                continue;
            }


            if (
                !variable_instance_exists(
                    hz,
                    "solid_body"
                )
                ||
                !hz.solid_body
            )
            {
                continue;
            }


            var only_active =
                variable_instance_exists(
                    hz,
                    "solid_only_when_active"
                )
                &&
                hz.solid_only_when_active;


            if (!only_active)
            {
                ds_list_destroy(
                    hazard_list
                );

                return true;
            }


            if (
                variable_instance_exists(
                    hz,
                    "active"
                )
                &&
                hz.active
            )
            {
                ds_list_destroy(
                    hazard_list
                );

                return true;
            }
        }


        ds_list_destroy(
            hazard_list
        );
    }


    // =================================================
    // EXPLICIT PLATFORM BLOCKERS
    //
    // Some standable objects may not inherit oSolidDyn,
    // so keep these explicit.
    // =================================================

    var blocker_objects =
    [
        asset_get_index("oFloorSurface"),
        asset_get_index("oMovingPlatform"),
        asset_get_index("oSpringPlatform"),
        asset_get_index("oSpringPlatformBig"),
        asset_get_index("oBreakingPlatform"),
        asset_get_index("oSpinnerPlatform"),
        asset_get_index("oConveyorLeft"),
        asset_get_index("oConveyorRight"),
        asset_get_index("oTeleporterSolid")
    ];


    for (
        var bi = 0;
        bi < array_length(blocker_objects);
        bi++
    )
    {
        var obj =
            blocker_objects[bi];


        if (obj == -1)
        {
            continue;
        }


        var block_list =
            ds_list_create();


        var block_count =
            collision_point_list(
                _x,
                _y,
                obj,
                false,
                true,
                block_list,
                false
            );


        for (
            var bj = 0;
            bj < block_count;
            bj++
        )
        {
            var block_inst =
                block_list[| bj];


            if (!instance_exists(block_inst))
            {
                continue;
            }


            // Again: ignore our own gun helper if an
            // object hierarchy ever causes it to appear.
            if (
                variable_instance_exists(
                    block_inst,
                    "owner_gun"
                )
                &&
                block_inst.owner_gun == id
            )
            {
                continue;
            }


            if (
                laser_instance_blocks(
                    block_inst
                )
            )
            {
                ds_list_destroy(
                    block_list
                );

                return true;
            }
        }


        ds_list_destroy(
            block_list
        );
    }


    return false;
};


// ====================================================
// SPAWN PHYSICAL COLLISION HELPER
// ====================================================

solid_inst =
    instance_create_layer(
        x,
        y,
        "Instances",
        oLaserGunMultiDirectionSolid
    );


if (solid_inst != noone)
{
    solid_inst.owner_gun =
        id;

    solid_inst.x =
        x;

    solid_inst.y =
        y;

    solid_inst.enabled =
        enabled;

    solid_inst.active =
        true;

    solid_inst.debug_draw =
        debug_draw;
}
