/// oMechaSoldier — Step


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
// HITBOX FOLLOW
// ====================================================

if (instance_exists(hitbox))
{
    hitbox.x = x;
    hitbox.y = y;
}


// ====================================================
// DEAD
// ====================================================

if (dead)
{
    move_x = 0;


    if (!death_finished)
    {
        image_speed =
            death_anim_speed;


        if (
            !death_parts_spawned
            &&
            image_index >=
                death_parts_spawn_frame
        )
        {
            soldier_spawn_parts();
        }


        if (
            image_index >=
            image_number - 1
        )
        {
            image_index =
                image_number - 1;


            image_speed = 0;


            death_finished =
                true;
        }
    }
    else
    {
        image_speed = 0;
    }


    exit;
}


// ====================================================
// TIMERS
// ====================================================

if (shot_cooldown > 0)
{
    shot_cooldown--;
}


if (player_hit_lock > 0)
{
    player_hit_lock--;
}


// ====================================================
// RECOIL
// ====================================================

recoil_amount =
    lerp(
        recoil_amount,
        0,
        0.25
    );


if (abs(recoil_amount) < 0.05)
{
    recoil_amount = 0;
}


// ====================================================
// MUZZLE FLASH
// ====================================================

if (muzzle_flash_active)
{
    muzzle_flash_frame +=
        muzzle_flash_speed;


    if (
        muzzle_flash_frame >=
        sprite_get_number(
            spr_muzzle
        )
    )
    {
        muzzle_flash_active =
            false;


        muzzle_flash_frame = 0;
    }
}


// ====================================================
// GROUND CHECK
// ====================================================

var _ground_start =
    soldier_find_floor(
        ground_attach_max,
        0
    );


grounded =
    _ground_start[0] != noone
    &&
    _ground_start[1] <=
        ground_attach_max
    &&
    vsp >= 0;


if (grounded)
{
    standing_surface =
        _ground_start[0];


    if (
        _ground_start[1] >= -2
        &&
        _ground_start[1] <=
            ground_attach_max
    )
    {
        y +=
            _ground_start[1];
    }


    if (vsp > 0)
    {
        vsp = 0;
    }
}
else
{
    standing_surface =
        noone;
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
// DISTANCES
// ====================================================

var _distance =
    999999;


var _horizontal_distance =
    999999;


if (_player_valid)
{
    _distance =
        point_distance(
            x,
            y,
            _player.x,
            _player.y
        );


    _horizontal_distance =
        abs(
            _player.x -
            x
        );
}


// ====================================================
// FACE PLAYER
// ====================================================

if (
    _player_valid
    &&
    _distance <=
        activation_range
)
{
    facing =
        (_player.x < x)
        ? -1
        : 1;
}


// ====================================================
// SOLDIER SEPARATION
//
// Soldiers remain completely non-solid to one another.
//
// If another living soldier is standing on roughly the
// same level and is closer than separation_distance,
// this soldier temporarily walks away.
//
// If two soldiers occupy the exact same X position,
// instance IDs deterministically make one choose left
// and the other choose right.
//
// Normal soldier_can_walk() is still used later, so
// separation cannot deliberately walk a soldier off a
// ledge or through a wall.
// ====================================================

var _separation_dir = 0;

var _separation_best_distance =
    separation_distance + 1;


if (grounded)
{
    var _soldier_count =
        instance_number(
            oMechaSoldier
        );


    for (
        var _si = 0;
        _si < _soldier_count;
        _si++
    )
    {
        var _other =
            instance_find(
                oMechaSoldier,
                _si
            );


        if (
            _other == noone
            ||
            _other == id
        )
        {
            continue;
        }


        // --------------------------------------------
        // IGNORE DEAD SOLDIERS
        // --------------------------------------------

        if (
            variable_instance_exists(
                _other,
                "dead"
            )
            &&
            _other.dead
        )
        {
            continue;
        }


        // --------------------------------------------
        // IGNORE DISABLED SOLDIERS
        // --------------------------------------------

        if (
            variable_instance_exists(
                _other,
                "enabled"
            )
            &&
            !_other.enabled
        )
        {
            continue;
        }


        // --------------------------------------------
        // SAME APPROXIMATE FLOOR LEVEL ONLY
        // --------------------------------------------

        var _sep_y =
            abs(
                _other.y -
                y
            );


        if (
            _sep_y >
            separation_vertical_tolerance
        )
        {
            continue;
        }


        // --------------------------------------------
        // HORIZONTAL DISTANCE
        // --------------------------------------------

        var _sep_x =
            _other.x -
            x;


        var _sep_distance =
            abs(
                _sep_x
            );


        if (
            _sep_distance >=
                separation_distance
            ||
            _sep_distance >=
                _separation_best_distance
        )
        {
            continue;
        }


        _separation_best_distance =
            _sep_distance;


        // --------------------------------------------
        // WALK AWAY FROM NEIGHBOUR
        // --------------------------------------------

        if (_sep_x > 0)
        {
            _separation_dir = -1;
        }
        else if (_sep_x < 0)
        {
            _separation_dir = 1;
        }
        else
        {
            // Exact overlap.
            //
            // Deterministically split the pair so they
            // don't both choose the same direction.

            _separation_dir =
                (id < _other.id)
                ? -1
                : 1;
        }
    }
}


// ====================================================
// STATE
//
// Separation takes priority over normal combat AI.
// ====================================================

move_x = 0;


if (_separation_dir != 0)
{
    state = "separate";
}
else if (!_player_valid)
{
    state = "idle";
}
else if (
    _distance >
    activation_range
)
{
    state = "idle";
}
else if (
    _horizontal_distance >
    preferred_range_max
)
{
    state = "approach";
}
else
{
    state = "aim";
}


// ====================================================
// IDLE
// ====================================================

if (state == "idle")
{
    sprite_index =
        spr_idle;


    image_speed =
        idle_anim_speed;


    move_x = 0;

    aim_timer = 0;
}


// ====================================================
// SEPARATE
//
// Walk away from another soldier who is standing too
// close.
//
// This uses the real walk animation rather than
// visually sliding the soldier across the ground.
// ====================================================

else if (state == "separate")
{
    sprite_index =
        spr_walk;


    image_speed =
        walk_anim_speed;


    aim_timer = 0;


    if (
        grounded
        &&
        _separation_dir != 0
    )
    {
        facing =
            _separation_dir;


        if (
            soldier_can_walk(
                _separation_dir,
                separation_move_speed
            )
        )
        {
            move_x =
                _separation_dir *
                separation_move_speed;
        }
    }
}


// ====================================================
// APPROACH
// ====================================================

else if (state == "approach")
{
    sprite_index =
        spr_walk;


    image_speed =
        walk_anim_speed;


    aim_timer = 0;


    if (
        grounded
        &&
        _player_valid
    )
    {
        var _walk_dir =
            sign(
                _player.x -
                x
            );


        if (_walk_dir != 0)
        {
            facing =
                _walk_dir;


            if (
                soldier_can_walk(
                    _walk_dir,
                    walk_speed
                )
            )
            {
                move_x =
                    _walk_dir *
                    walk_speed;
            }
        }
    }
}


// ====================================================
// AIM
// ====================================================

else if (state == "aim")
{
    move_x = 0;


    if (_player_valid)
    {
        soldier_update_aim(
            _player
        );
    }


    sprite_index =
        spr_aim;


    image_speed = 0;


    image_index =
        aim_frame;


    if (
        shot_cooldown <= 0
        &&
        _player_valid
    )
    {
        aim_timer++;


        if (
            aim_timer >=
            aim_before_shot_frames
        )
        {
            soldier_fire(
                _player
            );


            aim_timer = 0;


            shot_cooldown =
                shot_cooldown_frames;
        }
    }
    else
    {
        aim_timer = 0;
    }
}


// ====================================================
// HORIZONTAL MOVEMENT
// ====================================================

if (
    move_x != 0
    &&
    grounded
)
{
    var _remaining_x =
        abs(
            move_x
        );


    var _dir_x =
        sign(
            move_x
        );


    while (
        _remaining_x > 0
    )
    {
        var _step_x =
            min(
                1,
                _remaining_x
            );


        if (
            !soldier_can_walk(
                _dir_x,
                _step_x
            )
        )
        {
            break;
        }


        x +=
            _dir_x *
            _step_x;


        _remaining_x -=
            _step_x;
    }
}


// ====================================================
// RECHECK SUPPORT
// ====================================================

var _ground_after_x =
    soldier_find_floor(
        ground_attach_max,
        0
    );


grounded =
    _ground_after_x[0] != noone
    &&
    _ground_after_x[1] <=
        ground_attach_max
    &&
    vsp >= 0;


if (grounded)
{
    standing_surface =
        _ground_after_x[0];


    if (
        _ground_after_x[1] >= -2
        &&
        _ground_after_x[1] <=
            ground_attach_max
    )
    {
        y +=
            _ground_after_x[1];
    }


    if (vsp > 0)
    {
        vsp = 0;
    }
}
else
{
    standing_surface =
        noone;
}


// ====================================================
// GRAVITY
// ====================================================

if (!grounded)
{
    vsp +=
        gravity_amount;


    vsp =
        min(
            vsp,
            maximum_fall_speed
        );
}
else
{
    vsp = 0;
}


// ====================================================
// VERTICAL MOVEMENT
// ====================================================

if (vsp > 0)
{
    var _remaining_y =
        vsp;


    while (
        _remaining_y > 0
    )
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


        var _landing =
            soldier_find_floor(
                1,
                0
            );


        if (
            _landing[0] != noone
            &&
            _landing[1] <= 0
            &&
            _landing[1] >= -2
        )
        {
            y +=
                _landing[1];


            vsp = 0;

            grounded = true;

            standing_surface =
                _landing[0];


            break;
        }
    }
}


// ====================================================
// FINAL GROUND SNAP
// ====================================================

if (
    !grounded
    &&
    vsp >= 0
)
{
    var _snap =
        soldier_find_floor(
            ground_snap_max,
            0
        );


    if (_snap[0] != noone)
    {
        y +=
            _snap[1];


        vsp = 0;

        grounded = true;

        standing_surface =
            _snap[0];
    }
}


// ====================================================
// HITBOX FINAL POSITION
// ====================================================

if (instance_exists(hitbox))
{
    hitbox.x = x;
    hitbox.y = y;
}


// ====================================================
// SHADOW
// ====================================================

shadow_ground_distance =
    -1;


if (shadow_enabled)
{
    var _shadow_floor =
        soldier_find_floor(
            shadow_max_distance,
            0
        );


    if (_shadow_floor[0] != noone)
    {
        shadow_ground_distance =
            max(
                0,
                _shadow_floor[1]
            );


        var _shadow_surface =
            _shadow_floor[0];


        shadow_ground_y =
            _shadow_surface.bbox_top;


        if (
            variable_instance_exists(
                _shadow_surface,
                "surface_y"
            )
        )
        {
            shadow_ground_y =
                _shadow_surface.surface_y;
        }
    }
}


// ====================================================
// PLAYER COLLISION / SMASH
//
// Too slow:
//     JumpBot is bounced away.
//
// Fast enough:
//     Soldier dies.
//     JumpBot continues THROUGH the soldier while
//     retaining only part of his incoming momentum.
// ====================================================

if (
    _player_valid
    &&
    player_hit_lock <= 0
    &&
    instance_exists(hitbox)
)
{
    var _overlap =
        hitbox.bbox_right >
            _player.bbox_left
        &&
        hitbox.bbox_left <
            _player.bbox_right
        &&
        hitbox.bbox_bottom >
            _player.bbox_top
        &&
        hitbox.bbox_top <
            _player.bbox_bottom;


    if (_overlap)
    {
        var _phsp = 0;
        var _pvsp = 0;


        if (
            variable_instance_exists(
                _player,
                "hsp"
            )
        )
        {
            _phsp =
                _player.hsp;
        }


        if (
            variable_instance_exists(
                _player,
                "vsp"
            )
        )
        {
            _pvsp =
                _player.vsp;
        }


        var _impact_speed =
            point_distance(
                0,
                0,
                _phsp,
                _pvsp
            );


        // ============================================
        // SUCCESSFUL KILL
        // ============================================

        if (
            _impact_speed >=
            smash_speed_required
        )
        {
            // ========================================
            // KEEP MOVING THROUGH SOLDIER
            // ========================================

            _player.hsp =
                _phsp *
                successful_hit_momentum_keep;


            _player.vsp =
                _pvsp *
                successful_hit_momentum_keep;


            // ========================================
            // HITSTOP
            // ========================================

            scr_hitstop(3);


            // ========================================
            // IMPACT CAMERA SHAKE
            // ========================================

            global.shake_mag = 7;
            global.shake_time = 11;


            // ========================================
            // KILL SOLDIER
            // ========================================

            soldier_die(
                _phsp,
                _pvsp
            );
        }


        // ============================================
        // TOO SLOW
        // ============================================

        else
        {
            var _away =
                sign(
                    _player.x -
                    x
                );


            if (_away == 0)
            {
                _away =
                    -facing;
            }


            _player.hsp =
                _away *
                failed_hit_bounce;


            _player.vsp =
                min(
                    _player.vsp,
                    -1.5
                );


            player_hit_lock = 8;
        }
    }
}


// ====================================================
// FACING
// ====================================================

image_xscale =
    facing;