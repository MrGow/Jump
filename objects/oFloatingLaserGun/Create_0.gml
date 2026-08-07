/// oFloatingLaserGun — Create

event_inherited();

enabled = true;
active  = false;

// The gun instance itself is NOT the physical solid.
// oFloatingLaserGunSolid handles that.
solid_body = false;
solid_only_when_active = false;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    asset_get_index(
        "spriteLaserGunFloating"
    );

image_speed = 0;
image_index = 0;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Facing
//
// Sprite is authored pointing UP.
//
// Valid:
// "up"
// "right"
// "down"
// "left"
// ----------------------------------------------------
if (!variable_instance_exists(id, "laser_facing"))
{
    laser_facing = "up";
}


// ----------------------------------------------------
// Patrol
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
    wait_time_s = 1.5;
}

if (!variable_instance_exists(id, "fire_hold_time_s"))
{
    fire_hold_time_s = 0.75;
}


// ----------------------------------------------------
// Shooting animation
// ----------------------------------------------------
if (!variable_instance_exists(id, "fire_frame"))
{
    fire_frame = 8;
}

if (!variable_instance_exists(id, "anim_speed"))
{
    anim_speed = 0.35;
}


// ----------------------------------------------------
// Laser tuning
// ----------------------------------------------------
if (!variable_instance_exists(id, "max_laser_length"))
{
    max_laser_length = 640;
}

if (!variable_instance_exists(id, "ray_step"))
{
    ray_step = 4;
}

if (!variable_instance_exists(id, "laser_start_dist"))
{
    laser_start_dist = 46;
}

if (!variable_instance_exists(id, "laser_hit_start_back"))
{
    laser_hit_start_back = 10;
}

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
// FACING SETUP
// ====================================================

laser_dir = 90;
image_angle = 0;

switch (string_lower(string(laser_facing)))
{
    case "right":
    {
        laser_dir = 0;
        image_angle = 270;
    }
    break;

    case "down":
    {
        laser_dir = 270;
        image_angle = 180;
    }
    break;

    case "left":
    {
        laser_dir = 180;
        image_angle = 90;
    }
    break;

    case "up":
    default:
    {
        laser_dir = 90;
        image_angle = 0;
    }
    break;
}


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


// ----------------------------------------------------
// Find patrol point by matching patrol_id
// ----------------------------------------------------
if (patrol_enabled)
{
    var point_obj =
        asset_get_index(
            "oFloatingLaserGunPatrolPoint"
        );

    if (
        point_obj != -1 &&
        string(patrol_id) != ""
    )
    {
        var point_count =
            instance_number(
                point_obj
            );

        for (
            var i = 0;
            i < point_count;
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
                ) ||
                pt.enabled;

            if (!point_enabled)
            {
                continue;
            }

            if (
                variable_instance_exists(
                    pt,
                    "patrol_id"
                ) &&
                string(pt.patrol_id) ==
                string(patrol_id)
            )
            {
                patrol_point = pt;
                break;
            }
        }
    }


    if (patrol_point != noone)
    {
        patrol_end_x =
            patrol_point.x;

        patrol_end_y =
            patrol_point.y;
    }
    else
    {
        patrol_enabled = false;

        if (debug_draw)
        {
            show_debug_message(
                "oFloatingLaserGun: no matching patrol point for patrol_id = "
                + string(patrol_id)
            );
        }
    }
}


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

state = "waiting";

timer = wait_frames;
fire_timer = 0;


// ====================================================
// LASER STATE
// ====================================================

laser_start_x =
    x +
    lengthdir_x(
        laser_start_dist,
        laser_dir
    );

laser_start_y =
    y +
    lengthdir_y(
        laser_start_dist,
        laser_dir
    );

laser_end_x =
    laser_start_x;

laser_end_y =
    laser_start_y;

laser_len = 0;

laser_fx_frame = 0;


// ====================================================
// SFX
// ====================================================

snd_laser_shoot =
    asset_get_index(
        "LaserGunShoot1"
    );

laser_shoot_gain = 0.9;

laser_sfx_inner_dist = 120;
laser_sfx_outer_dist = 520;

laser_shot_sfx_played = false;


// ====================================================
// SPAWN PHYSICAL SOLID HELPER
// ====================================================

solid_inst =
    instance_create_layer(
        x,
        y,
        "Instances",
        oFloatingLaserGunSolid
    );

if (solid_inst != noone)
{
    solid_inst.owner_gun = id;

    solid_inst.x = x;
    solid_inst.y = y;

    solid_inst.image_angle =
        image_angle;

    solid_inst.enabled =
        enabled;

    solid_inst.active = true;

    // Let the main object's debug setting control
    // whether the mask is visible for testing.
    solid_inst.debug_draw =
        debug_draw;
}


// ====================================================
// DISTANCE-BASED LASER SFX
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

    var gain = 1;

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
// SOLID TEST FOR LASER
// ====================================================

laser_point_hits_solid =
function(_x, _y)
{
    // ------------------------------------------------
    // Tile solids
    // ------------------------------------------------
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
                    ) != 0
                )
                {
                    return true;
                }
            }
        }
    }


    // ------------------------------------------------
    // Dynamic solids
    // ------------------------------------------------
    var dyn_obj =
        asset_get_index(
            "oSolidDyn"
        );

    if (dyn_obj != -1)
    {
        if (
            instance_position(
                _x,
                _y,
                dyn_obj
            ) != noone
        )
        {
            return true;
        }
    }


    // ------------------------------------------------
    // Spinner platforms
    // ------------------------------------------------
    var spinner_obj =
        asset_get_index(
            "oSpinnerPlatform"
        );

    if (spinner_obj != -1)
    {
        var sp =
            instance_position(
                _x,
                _y,
                spinner_obj
            );

        if (sp != noone)
        {
            var sp_enabled =
                !variable_instance_exists(
                    sp,
                    "enabled"
                ) ||
                sp.enabled;

            var sp_active =
                !variable_instance_exists(
                    sp,
                    "active"
                ) ||
                sp.active;

            if (
                sp_enabled &&
                sp_active
            )
            {
                return true;
            }
        }
    }


    // ------------------------------------------------
    // Breaking platforms
    // ------------------------------------------------
    var breaking_obj =
        asset_get_index(
            "oBreakingPlatform"
        );

    if (breaking_obj != -1)
    {
        var bp =
            instance_position(
                _x,
                _y,
                breaking_obj
            );

        if (bp != noone)
        {
            var bp_enabled =
                !variable_instance_exists(
                    bp,
                    "enabled"
                ) ||
                bp.enabled;

            var bp_active =
                !variable_instance_exists(
                    bp,
                    "active"
                ) ||
                bp.active;

            if (
                bp_enabled &&
                bp_active
            )
            {
                return true;
            }
        }
    }


    return false;
};