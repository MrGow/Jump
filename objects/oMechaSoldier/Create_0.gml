/// oMechaSoldier — Create


// ====================================================
// GENERAL
// ====================================================

enabled = true;
dead = false;

depth = -200;


// ====================================================
// SPRITES
// ====================================================

spr_idle =
    spriteMechaSoldierIdle;

spr_walk =
    spriteMechaSoldierWalk;

spr_aim =
    spriteMechaSoldierAim;

spr_death =
    spriteMechaSoldierDeath;

spr_body_parts =
    spriteMechaSoldierBodyParts;

spr_muzzle =
    spriteMechaSoldierMuzzleFlash;


// ====================================================
// COMBAT
// ====================================================

activation_range = 380;

walk_speed = 0.8;

preferred_range_min = 150;
preferred_range_max = 260;

aim_before_shot_frames = 18;
shot_cooldown_frames = 75;

projectile_speed = 6;


// ====================================================
// PLAYER SMASH
// ====================================================

smash_speed_required = 5.5;

failed_hit_bounce = 4;

successful_hit_bounce = 2.5;

player_hit_lock = 0;


// ====================================================
// VISUAL FLOOR INSET
// ====================================================

draw_floor_inset = 8;


// ====================================================
// PHYSICS
// ====================================================

vsp = 0;

gravity_amount = 0.25;

maximum_fall_speed = 8;

ground_snap_max = 6;

ground_attach_max = 2;

ground_min_overlap = 4;

ledge_probe_forward = 4;

wall_probe_top_margin = 8;
wall_probe_bottom_margin = 18;

grounded = false;

standing_surface = noone;


// ====================================================
// ANIMATION
// ====================================================

idle_anim_speed = 1;
walk_anim_speed = 1;
death_anim_speed = 1;

muzzle_flash_speed = 1;


// ====================================================
// STATE
// ====================================================

facing = 1;

state = "idle";

move_x = 0;

aim_timer = 0;

shot_cooldown = 0;


// ====================================================
// AIM
// ====================================================

aim_angle = 0;

aim_frame = 0;

locked_shot_angle = 0;

locked_aim_frame = 0;


// ====================================================
// AIM POSES
//
// Frames 0-6:
// straight -> progressively upward.
//
// Frames 7-12:
// progressively downward.
// ====================================================

aim_pose_angles =
[
     0,
    14,
    28,
    43,
    57,
    72,
    86,

   -14,
   -28,
   -42,
   -55,
   -69,
   -84
];


aim_frame_count =
    array_length(
        aim_pose_angles
    );


// ====================================================
// MUZZLE POSITION PER AIM FRAME
// ====================================================

aim_muzzle_x =
[
    27,
    26,
    24,
    21,
    17,
    12,
     6,

    27,
    25,
    22,
    18,
    13,
     7
];


aim_muzzle_y =
[
   -29,
   -33,
   -37,
   -41,
   -44,
   -47,
   -49,

   -25,
   -21,
   -17,
   -13,
    -9,
    -6
];


// ====================================================
// MUZZLE FLASH
// ====================================================

muzzle_flash_active = false;

muzzle_flash_frame = 0;


// ====================================================
// RECOIL
// ====================================================

recoil_amount = 0;

recoil_strength = 2;


// ====================================================
// DEATH
// ====================================================

death_parts_spawned = false;

death_finished = false;

death_impact_hsp = 0;

death_impact_vsp = 0;


// GameMaker frame 6 = visible frame 7.
death_parts_spawn_frame = 6;


// ====================================================
// SHADOW
// ====================================================

shadow_enabled = true;

shadow_max_distance = 80;

shadow_width = 20;
shadow_height = 5;

shadow_breathe_amount_x = 1.5;
shadow_breathe_amount_y = 0.5;

shadow_breathe_speed = 0.055;

shadow_phase =
    random_range(
        0,
        pi * 2
    );

shadow_alpha = 0.20;

shadow_ground_distance = -1;

shadow_ground_y = y;

shadow_offset_x = 6;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// SOLIDS TILEMAP
// ====================================================

solid_tilemap = -1;


if (layer_exists("Solids"))
{
    var _solid_layer =
        layer_get_id(
            "Solids"
        );


    if (_solid_layer != -1)
    {
        solid_tilemap =
            layer_tilemap_get_id(
                _solid_layer
            );
    }
}


// ====================================================
// GENERIC SOLID CHECK
// ====================================================

soldier_solid_at =
function(_x, _y)
{
    var _dyn =
        asset_get_index(
            "oSolidDyn"
        );


    if (_dyn != -1)
    {
        if (
            instance_position(
                _x,
                _y,
                _dyn
            )
            != noone
        )
        {
            return true;
        }
    }


    if (solid_tilemap != -1)
    {
        if (
            tilemap_get_at_pixel(
                solid_tilemap,
                _x,
                _y
            )
            != 0
        )
        {
            return true;
        }
    }


    return false;
};


// ====================================================
// FIND FLOOR SURFACE
// ====================================================

soldier_find_floor =
function(_max_distance, _offset_x)
{
    if (is_undefined(_offset_x))
    {
        _offset_x = 0;
    }


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
        bbox_left +
        _offset_x;


    var _right =
        bbox_right +
        _offset_x;


    var _bottom =
        bbox_bottom;


    var _list =
        ds_list_create();


    var _count =
        collision_rectangle_list(
            _left,
            _bottom - 4,
            _right,
            _bottom + _max_distance + 4,
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


        if (_dy > _max_distance)
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
// FLOOR AHEAD
// ====================================================

soldier_floor_ahead =
function(_dir, _amount)
{
    var _offset =
        _dir *
        (
            _amount +
            ledge_probe_forward
        );


    var _floor =
        soldier_find_floor(
            ground_snap_max,
            _offset
        );


    return
        _floor[0] != noone;
};


// ====================================================
// WALL AHEAD
// ====================================================

soldier_wall_ahead =
function(_dir, _amount)
{
    if (_dir == 0)
    {
        return false;
    }


    var _probe_x;


    if (_dir > 0)
    {
        _probe_x =
            bbox_right +
            _amount;
    }
    else
    {
        _probe_x =
            bbox_left -
            _amount;
    }


    var _top =
        bbox_top +
        wall_probe_top_margin;


    var _bottom =
        bbox_bottom -
        wall_probe_bottom_margin;


    if (_bottom < _top)
    {
        _bottom = _top;
    }


    var _middle =
        (_top + _bottom) *
        0.5;


    if (
        soldier_solid_at(
            _probe_x,
            _top
        )
    )
    {
        return true;
    }


    if (
        soldier_solid_at(
            _probe_x,
            _middle
        )
    )
    {
        return true;
    }


    if (
        soldier_solid_at(
            _probe_x,
            _bottom
        )
    )
    {
        return true;
    }


    return false;
};


// ====================================================
// CAN WALK
// ====================================================

soldier_can_walk =
function(_dir, _amount)
{
    if (!grounded)
    {
        return false;
    }


    if (
        soldier_wall_ahead(
            _dir,
            _amount
        )
    )
    {
        return false;
    }


    if (
        !soldier_floor_ahead(
            _dir,
            _amount
        )
    )
    {
        return false;
    }


    return true;
};


// ====================================================
// SELECT AIM FRAME
// ====================================================

soldier_select_aim_frame =
function(_local_angle)
{
    var _best_frame = 0;

    var _best_difference =
        999999;


    for (
        var _i = 0;
        _i < aim_frame_count;
        _i++
    )
    {
        var _difference =
            abs(
                angle_difference(
                    _local_angle,
                    aim_pose_angles[_i]
                )
            );


        if (
            _difference <
            _best_difference
        )
        {
            _best_difference =
                _difference;


            _best_frame =
                _i;
        }
    }


    return _best_frame;
};


// ====================================================
// UPDATE AIM
//
// IMPORTANT:
//
// Our authored table treats:
//
// positive = upward
// negative = downward
//
// GameMaker's angle difference needs to be inverted
// for the right-facing version.
// ====================================================

soldier_update_aim =
function(_player)
{
    if (!instance_exists(_player))
    {
        return;
    }


    // ------------------------------------------------
    // FACE PLAYER
    // ------------------------------------------------

    if (_player.x < x)
    {
        facing = -1;
    }
    else
    {
        facing = 1;
    }


    // ------------------------------------------------
    // GUN CENTRE
    //
    // Include visual floor inset so aiming uses the
    // position at which the soldier is actually drawn.
    // ------------------------------------------------

    var _gun_x =
        x +
        8 *
        facing;


    var _gun_y =
        y +
        draw_floor_inset -
        29;


    // ------------------------------------------------
    // WORLD ANGLE TO PLAYER
    // ------------------------------------------------

    aim_angle =
        point_direction(
            _gun_x,
            _gun_y,
            _player.x,
            _player.y
        );


    // ------------------------------------------------
    // WORLD -> LOCAL AIM ANGLE
    // ------------------------------------------------

    var _local_angle;


    if (facing > 0)
    {
        _local_angle =
            -angle_difference(
                aim_angle,
                0
            );
    }
    else
    {
        _local_angle =
            angle_difference(
                aim_angle,
                180
            );
    }


    _local_angle =
        clamp(
            _local_angle,
            -90,
            90
        );


    aim_frame =
        soldier_select_aim_frame(
            _local_angle
        );
};


// ====================================================
// GET MUZZLE POSITION
// ====================================================

soldier_get_muzzle =
function(
    _frame,
    _base_x,
    _base_y
)
{
    _frame =
        clamp(
            round(_frame),
            0,
            aim_frame_count - 1
        );


    var _mx =
        _base_x +
        aim_muzzle_x[_frame] *
        facing;


    var _my =
        _base_y +
        aim_muzzle_y[_frame];


    return [
        _mx,
        _my
    ];
};


// ====================================================
// FIRE
// ====================================================

soldier_fire =
function(_player)
{
    if (!instance_exists(_player))
    {
        return;
    }


    // Final aim update immediately before firing.
    soldier_update_aim(
        _player
    );


    locked_aim_frame =
        aim_frame;


    // Use the VISUAL soldier position so the actual
    // projectile originates from the visible weapon.
    var _muzzle =
        soldier_get_muzzle(
            locked_aim_frame,
            x,
            y + draw_floor_inset
        );


    var _mx =
        _muzzle[0];


    var _my =
        _muzzle[1];


    // Projectile precisely targets the player's
    // position at the instant of firing.
    locked_shot_angle =
        point_direction(
            _mx,
            _my,
            _player.x,
            _player.y
        );


    // ------------------------------------------------
    // PROJECTILE
    // ------------------------------------------------

    var _shot_obj =
        asset_get_index(
            "oMechaSoldierLaserShot"
        );


    if (_shot_obj != -1)
    {
        var _shot =
            instance_create_depth(
                _mx,
                _my,
                depth - 1,
                _shot_obj
            );


        if (_shot != noone)
        {
            _shot.move_angle =
                locked_shot_angle;


            _shot.move_speed =
                projectile_speed;


            _shot.owner =
                id;


            if (
                variable_instance_exists(
                    _shot,
                    "setup_projectile"
                )
            )
            {
                _shot.setup_projectile();
            }
        }
    }


    // ------------------------------------------------
    // MUZZLE FLASH
    // ------------------------------------------------

    muzzle_flash_active =
        true;


    muzzle_flash_frame =
        0;


    // ------------------------------------------------
    // RECOIL
    // ------------------------------------------------

    recoil_amount =
        recoil_strength;
};


// ====================================================
// SPAWN BODY PARTS
// ====================================================

soldier_spawn_parts =
function()
{
    if (death_parts_spawned)
    {
        return;
    }


    var _part_obj =
        asset_get_index(
            "oMechaSoldierBodyPart"
        );


    if (_part_obj == -1)
    {
        return;
    }


    if (spr_body_parts == -1)
    {
        return;
    }


    var _part_count =
        sprite_get_number(
            spr_body_parts
        );


    death_parts_spawned =
        true;


    for (
        var _i = 0;
        _i < _part_count;
        _i++
    )
    {
        var _burst_angle =
            random_range(
                0,
                360
            );


        var _burst_speed =
            random_range(
                4.5,
                8
            );


        var _burst_hsp =
            lengthdir_x(
                _burst_speed,
                _burst_angle
            );


        var _burst_vsp =
            lengthdir_y(
                _burst_speed,
                _burst_angle
            );


        _burst_hsp +=
            death_impact_hsp *
            0.18;


        _burst_vsp +=
            death_impact_vsp *
            0.10;


        var _spin =
            random_range(
                -18,
                18
            );


        if (abs(_spin) < 5)
        {
            _spin =
                5 *
                choose(
                    -1,
                    1
                );
        }


        var _spawn_radius =
            random_range(
                0,
                5
            );


        var _spawn_x =
            x +
            lengthdir_x(
                _spawn_radius,
                _burst_angle
            );


        var _spawn_y =
            y -
            18 +
            lengthdir_y(
                _spawn_radius,
                _burst_angle
            );


        instance_create_depth(
            _spawn_x,
            _spawn_y,
            depth - 1,
            _part_obj,
            {
                part_sprite :
                    spr_body_parts,

                part_frame :
                    _i,

                hsp :
                    _burst_hsp,

                vsp :
                    _burst_vsp,

                spin_speed :
                    _spin,

                start_angle :
                    random_range(
                        0,
                        359
                    )
            }
        );
    }
};


// ====================================================
// DIE
// ====================================================

soldier_die =
function(
    _impact_hsp,
    _impact_vsp
)
{
    if (dead)
    {
        return;
    }


    dead = true;

    state = "dead";

    move_x = 0;

    vsp = 0;


    death_impact_hsp =
        _impact_hsp;


    death_impact_vsp =
        _impact_vsp;


    death_parts_spawned =
        false;


    death_finished =
        false;


    muzzle_flash_active =
        false;


    recoil_amount =
        0;


    sprite_index =
        spr_death;


    image_index =
        0;


    image_speed =
        death_anim_speed;
};


// ====================================================
// INITIAL APPEARANCE
// ====================================================

sprite_index =
    spr_idle;


image_index = 0;

image_speed =
    idle_anim_speed;


image_xscale =
    facing;