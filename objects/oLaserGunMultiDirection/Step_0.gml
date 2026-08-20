// ============================================================================
// STEP
// ============================================================================

/// oLaserGunMultiDirection — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "anim_speed"))
{
    anim_speed = 0.35;
}

if (!variable_instance_exists(id, "patrol_speed"))
{
    patrol_speed = 1.5;
}

if (!variable_instance_exists(id, "laser_shot_sfx_played"))
{
    laser_shot_sfx_played = false;
}

if (!variable_instance_exists(id, "laser_visual_muzzle_overlap"))
{
    laser_visual_muzzle_overlap = 4;
}

if (!variable_instance_exists(id, "laser_visual_end_overlap"))
{
    laser_visual_end_overlap = 3;
}


// Safety against old broken editor value.
laser_start_dist =
    min(
        laser_start_dist,
        25
    );


// ====================================================
// FREEZE / PAUSE
//
// Preserve current beam arrays so the entire 8-way
// firing frame freezes intact on death/pause.
// ====================================================

if (scr_game_frozen())
{
    image_speed =
        0;


    if (
        variable_instance_exists(
            id,
            "solid_inst"
        )
        &&
        instance_exists(
            solid_inst
        )
    )
    {
        solid_inst.x =
            x;

        solid_inst.y =
            y;

        solid_inst.enabled =
            enabled;

        solid_inst.active =
            enabled;

        solid_inst.debug_draw =
            debug_draw;
    }


    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active =
        false;

    image_speed =
        0;


    for (
        var clear_disabled = 0;
        clear_disabled < laser_count;
        clear_disabled++
    )
    {
        laser_len[clear_disabled] =
            0;
    }


    if (
        variable_instance_exists(
            id,
            "solid_inst"
        )
        &&
        instance_exists(
            solid_inst
        )
    )
    {
        solid_inst.enabled =
            false;

        solid_inst.active =
            false;
    }


    exit;
}


// ====================================================
// PATROL MOVEMENT
// ====================================================

if (
    patrol_enabled
    &&
    patrol_point != noone
    &&
    instance_exists(
        patrol_point
    )
)
{
    patrol_end_x =
        patrol_point.x;

    patrol_end_y =
        patrol_point.y;


    var route_len =
        point_distance(
            patrol_start_x,
            patrol_start_y,
            patrol_end_x,
            patrol_end_y
        );


    if (route_len > 0.001)
    {
        patrol_t +=
            (
                patrol_speed /
                route_len
            )
            *
            patrol_direction;


        if (patrol_t >= 1)
        {
            patrol_t =
                1;

            patrol_direction =
                -1;
        }
        else if (patrol_t <= 0)
        {
            patrol_t =
                0;

            patrol_direction =
                1;
        }


        x =
            lerp(
                patrol_start_x,
                patrol_end_x,
                patrol_t
            );

        y =
            lerp(
                patrol_start_y,
                patrol_end_y,
                patrol_t
            );
    }
}


// ====================================================
// KEEP SOLID HELPER ATTACHED
// ====================================================

if (
    variable_instance_exists(
        id,
        "solid_inst"
    )
    &&
    instance_exists(
        solid_inst
    )
)
{
    solid_inst.x =
        x;

    solid_inst.y =
        y;

    solid_inst.enabled =
        true;

    solid_inst.active =
        true;

    solid_inst.debug_draw =
        debug_draw;
}


// ====================================================
// DEFAULT NON-LETHAL STATE
// ====================================================

active =
    false;


// ====================================================
// WAITING
// ====================================================

if (state == "waiting")
{
    image_speed =
        0;

    image_index =
        0;

    laser_fx_frame =
        0;

    laser_shot_sfx_played =
        false;

    timer--;


    if (timer <= 0)
    {
        state =
            "windup";

        image_index =
            0;
    }
}


// ====================================================
// WINDUP
// ====================================================

else if (state == "windup")
{
    image_speed =
        0;

    image_index +=
        anim_speed;

    laser_fx_frame =
        0;


    if (image_index >= fire_frame)
    {
        image_index =
            fire_frame;

        state =
            "firing";

        fire_timer =
            fire_hold_frames;


        if (!laser_shot_sfx_played)
        {
            play_laser_sfx();

            laser_shot_sfx_played =
                true;
        }
    }
}


// ====================================================
// FIRING
// ====================================================

else if (state == "firing")
{
    active =
        true;


    // ------------------------------------------------
    // Beam FX animation
    // ------------------------------------------------

    var ray_spr =
        asset_get_index(
            "spriteLaserGunRepeatingRay"
        );


    if (ray_spr != -1)
    {
        laser_fx_frame +=
            sprite_get_speed(
                ray_spr
            )
            /
            max(
                1,
                room_speed
            );
    }


    // ------------------------------------------------
    // Continue gun firing animation
    // ------------------------------------------------

    image_speed =
        0;

    image_index +=
        anim_speed;


    if (
        image_index >
        image_number - 1
    )
    {
        image_index =
            fire_frame;
    }


    // ------------------------------------------------
    // Duration
    // ------------------------------------------------

    fire_timer--;


    if (fire_timer <= 0)
    {
        active =
            false;

        state =
            "waiting";

        timer =
            wait_frames;

        image_index =
            0;

        image_speed =
            0;

        laser_shot_sfx_played =
            false;


        for (
            var reset_i = 0;
            reset_i < laser_count;
            reset_i++
        )
        {
            laser_len[reset_i] =
                0;
        }
    }
}


// ====================================================
// NO ACTIVE BEAMS
// ====================================================

if (!active)
{
    for (
        var clear_i = 0;
        clear_i < laser_count;
        clear_i++
    )
    {
        laser_len[clear_i] =
            0;
    }


    exit;
}


// ====================================================
// PLAYER
// ====================================================

var player =
    instance_find(
        oPlayer,
        0
    );


var player_valid =
    player != noone;


if (player_valid)
{
    if (
        variable_instance_exists(
            player,
            "state"
        )
        &&
        player.state == "dead"
    )
    {
        player_valid =
            false;
    }
}


// ====================================================
// CALCULATE ALL EIGHT BEAMS
//
// Every direction is calculated before player death is
// triggered. That keeps all eight beams visually valid
// on the death/freeze frame.
// ====================================================

var player_hit_any_beam =
    false;


for (
    var beam_i = 0;
    beam_i < laser_count;
    beam_i++
)
{
    var beam_dir =
        laser_dirs[beam_i];


    // ------------------------------------------------
    // MUZZLE START
    // ------------------------------------------------

    var sx =
        x +
        lengthdir_x(
            laser_start_dist,
            beam_dir
        );


    var sy =
        y +
        lengthdir_y(
            laser_start_dist,
            beam_dir
        );


    laser_start_x[beam_i] =
        sx;

    laser_start_y[beam_i] =
        sy;


    // ------------------------------------------------
    // DIRECTION VECTOR
    // ------------------------------------------------

    var dx =
        lengthdir_x(
            1,
            beam_dir
        );


    var dy =
        lengthdir_y(
            1,
            beam_dir
        );


    // ------------------------------------------------
    // DEFAULT END
    // ------------------------------------------------

    var dist_hit =
        max_laser_length;


    // =================================================
    // SOLID RAYCAST
    //
    // Stops independently for EACH of the 8 beams.
    // ====================================================

    for (
        var d = 0;
        d <= max_laser_length;
        d += ray_step
    )
    {
        var tx =
            sx +
            dx *
            d;


        var ty =
            sy +
            dy *
            d;


        if (
            laser_point_hits_solid(
                tx,
                ty
            )
        )
        {
            dist_hit =
                max(
                    0,
                    d
                );

            break;
        }
    }


    // ------------------------------------------------
    // Commit complete beam geometry
    // ------------------------------------------------

    laser_len[beam_i] =
        dist_hit;


    laser_end_x[beam_i] =
        sx +
        dx *
        dist_hit;


    laser_end_y[beam_i] =
        sy +
        dy *
        dist_hit;


    // =================================================
    // PLAYER HIT TEST
    //
    // IMPORTANT:
    // The player does NOT shorten the beam.
    //
    // The laser continues all the way to the wall while
    // still killing JumpBot if he intersects it.
    // ====================================================

    if (player_valid)
    {
        var start_pd =
            -laser_hit_start_back;


        for (
            var pd = start_pd;
            pd <= dist_hit;
            pd += ray_step
        )
        {
            var px =
                sx +
                dx *
                pd;


            var py =
                sy +
                dy *
                pd;


            var pad =
                laser_hit_pad;


            var hit_player =
                (
                    px + pad >
                    player.bbox_left
                )
                &&
                (
                    px - pad <
                    player.bbox_right
                )
                &&
                (
                    py + pad >
                    player.bbox_top
                )
                &&
                (
                    py - pad <
                    player.bbox_bottom
                );


            if (hit_player)
            {
                player_hit_any_beam =
                    true;

                break;
            }
        }
    }
}


// ====================================================
// KILL ONLY AFTER ALL 8 BEAMS ARE CALCULATED
// ====================================================

if (
    player_hit_any_beam
    &&
    player != noone
)
{
    with (player)
    {
        scr_player_died();
    }
}
