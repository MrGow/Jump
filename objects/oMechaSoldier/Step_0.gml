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
// DEAD
// ====================================================

if (dead)
{
    move_x = 0;


    image_speed =
        death_anim_speed;


    // ------------------------------------------------
    // BREAK APART
    //
    // GameMaker frame 6 = visible frame 7.
    // ------------------------------------------------

    if (
        !death_parts_spawned
        &&
        image_index >=
            death_parts_spawn_frame
    )
    {
        soldier_spawn_parts();
    }


    // ------------------------------------------------
    // FINISH DEATH ANIMATION
    // ------------------------------------------------

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


        instance_destroy();
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


        muzzle_flash_frame =
            0;
    }
}


// ====================================================
// GROUND CHECK AT START
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


    // Snap tiny gaps exactly onto the surface.
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
// FIND PLAYER
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
// DISTANCE TO PLAYER
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
// FACE PLAYER WHEN ACTIVE
// ====================================================

if (
    _player_valid
    &&
    _distance <=
        activation_range
)
{
    if (_player.x < x)
    {
        facing = -1;
    }
    else
    {
        facing = 1;
    }
}


// ====================================================
// STATE MACHINE
// ====================================================

move_x = 0;


// ----------------------------------------------------
// NO PLAYER
// ----------------------------------------------------

if (!_player_valid)
{
    state = "idle";
}


// ----------------------------------------------------
// OUTSIDE ACTIVATION RANGE
// ----------------------------------------------------

else if (
    _distance >
    activation_range
)
{
    state = "idle";
}


// ----------------------------------------------------
// APPROACH / AIM
// ----------------------------------------------------

else
{
    // Too far away to shoot.
    if (
        _horizontal_distance >
        preferred_range_max
    )
    {
        state = "approach";
    }

    // Inside firing range.
    else
    {
        state = "aim";
    }
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
// APPROACH
// ====================================================

else if (state == "approach")
{
    sprite_index =
        spr_walk;


    image_speed =
        walk_anim_speed;


    aim_timer = 0;


    // ------------------------------------------------
    // ONLY WALK WHILE GROUNDED
    //
    // If placed in the air, gravity handles the
    // soldier until he lands.
    // ------------------------------------------------

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


    // Aim is a POSE SHEET, not an animation.
    image_speed = 0;


    image_index =
        aim_frame;


    // ------------------------------------------------
    // FIRE TIMER
    // ------------------------------------------------

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
//
// Substep so the soldier cannot skip through walls or
// across the end of a floor.
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
// RECHECK SUPPORT AFTER HORIZONTAL MOVEMENT
//
// If the floor has disappeared beneath him, he becomes
// airborne and gravity immediately takes over.
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
//
// Move downward one pixel at a time and look for a
// FloorSurface after every step.
//
// This allows soldiers to be placed in mid-air.
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
//
// Catches small fractional gaps.
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
// SHADOW GROUND SEARCH
//
// Search farther than the normal standing check.
// Shadow stays on the ground while the soldier falls.
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
// ====================================================

if (
    _player_valid
    &&
    player_hit_lock <= 0
)
{
    var _overlap =
        bbox_right >
            _player.bbox_left
        &&
        bbox_left <
            _player.bbox_right
        &&
        bbox_bottom >
            _player.bbox_top
        &&
        bbox_top <
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


        // --------------------------------------------
        // SUCCESSFUL SMASH
        // --------------------------------------------

        if (
            _impact_speed >=
            smash_speed_required
        )
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
                successful_hit_bounce;


            _player.vsp =
                -successful_hit_bounce;


            soldier_die(
                _phsp,
                _pvsp
            );
        }


        // --------------------------------------------
        // TOO SLOW
        // --------------------------------------------

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


            player_hit_lock =
                8;
        }
    }
}


// ====================================================
// FACING
// ====================================================

image_xscale =
    facing;