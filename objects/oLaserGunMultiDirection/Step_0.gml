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


// ====================================================
// FREEZE / PAUSE
//
// IMPORTANT:
// When death freezes the game, we leave all eight
// existing laser arrays untouched.
//
// This means the complete killing frame remains
// visually frozen instead of clearing/recalculating
// only part of the laser pattern.
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    // Keep physical helper exactly attached.
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
        solid_inst.x = x;
        solid_inst.y = y;

        solid_inst.enabled =
            enabled;

        solid_inst.active =
            enabled;
    }

    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active = false;
    image_speed = 0;

    for (
        var i = 0;
        i < laser_count;
        i++
    )
    {
        laser_len[i] = 0;
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
        solid_inst.enabled = false;
        solid_inst.active  = false;
    }

    exit;
}


// ====================================================
// PATROL MOVEMENT
// ====================================================

if (
    patrol_enabled &&
    patrol_point != noone &&
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
            patrol_t = 1;
            patrol_direction = -1;
        }
        else if (patrol_t <= 0)
        {
            patrol_t = 0;
            patrol_direction = 1;
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
    solid_inst.x = x;
    solid_inst.y = y;

    solid_inst.enabled = true;
    solid_inst.active  = true;

    solid_inst.debug_draw =
        debug_draw;
}


// ====================================================
// DEFAULT NON-LETHAL STATE
// ====================================================

active = false;


// ====================================================
// WAITING
// ====================================================

if (state == "waiting")
{
    image_speed = 0;
    image_index = 0;

    laser_fx_frame = 0;

    laser_shot_sfx_played = false;

    timer--;


    if (timer <= 0)
    {
        state = "windup";

        image_index = 0;
    }
}


// ====================================================
// WINDUP
// ====================================================

else if (state == "windup")
{
    image_speed = 0;

    image_index +=
        anim_speed;

    laser_fx_frame = 0;


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
    active = true;


    // ------------------------------------------------
    // Animate shared beam effects
    // ------------------------------------------------
    laser_fx_frame +=
        sprite_get_speed(
            spriteLaserGunRepeatingRay
        )
        /
        room_speed;


    // ------------------------------------------------
    // Continue firing sprite animation
    // ------------------------------------------------
    image_speed = 0;

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
    // Fire duration
    // ------------------------------------------------
    fire_timer--;


    if (fire_timer <= 0)
    {
        active = false;

        state =
            "waiting";

        timer =
            wait_frames;

        image_index = 0;
        image_speed = 0;

        laser_shot_sfx_played =
            false;

        for (
            var reset_i = 0;
            reset_i < laser_count;
            reset_i++
        )
        {
            laser_len[reset_i] = 0;
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
        laser_len[clear_i] = 0;
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
        player_valid = false;
    }
}


// ====================================================
// CALCULATE ALL EIGHT BEAMS
//
// IMPORTANT:
//
// Death is NOT triggered inside this loop.
//
// Every beam first receives a fresh:
// - start position
// - end position
// - length
//
// Only once ALL EIGHT calculations are complete do we
// call scr_player_died().
//
// This prevents partially stale beam arrays on the
// frame that kills the player.
// ====================================================

var player_hit_any_beam = false;


for (
    var beam_i = 0;
    beam_i < laser_count;
    beam_i++
)
{
    var beam_dir =
        laser_dirs[beam_i];


    // ------------------------------------------------
    // This beam's own hit state.
    //
    // Do NOT use player_hit_any_beam for cosmetic
    // calculations because another direction may have
    // hit the player earlier in this same loop.
    // ------------------------------------------------
    var beam_hit_player = false;


    // ------------------------------------------------
    // Beam start
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


    laser_start_x[beam_i] = sx;
    laser_start_y[beam_i] = sy;


    // ------------------------------------------------
    // Direction vector
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
    // Default full-length result
    // ------------------------------------------------
    var hit_x =
        sx +
        dx *
        max_laser_length;

    var hit_y =
        sy +
        dy *
        max_laser_length;

    var dist_hit =
        max_laser_length;

    var hit_solid = false;


    // =================================================
    // FIND SOLID OBSTRUCTION
    // =================================================

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
            hit_solid = true;

            dist_hit = d;

            hit_x =
                sx +
                dx *
                dist_hit;

            hit_y =
                sy +
                dy *
                dist_hit;

            break;
        }
    }


    // =================================================
    // PLAYER COLLISION
    // =================================================

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


            if (
                rectangle_in_rectangle(
                    px - pad,
                    py - pad,
                    px + pad,
                    py + pad,

                    player.bbox_left,
                    player.bbox_top,
                    player.bbox_right,
                    player.bbox_bottom
                )
            )
            {
                dist_hit =
                    max(
                        0,
                        pd
                    );

                hit_x =
                    sx +
                    dx *
                    dist_hit;

                hit_y =
                    sy +
                    dy *
                    dist_hit;


                // This particular beam hit the player.
                beam_hit_player = true;

                // Remember that at least one of the
                // eight beams hit the player.
                player_hit_any_beam = true;

                break;
            }
        }
    }


    // =================================================
    // FULL-DISTANCE COSMETIC CORRECTION
    //
    // This must depend on THIS beam only.
    //
    // Previously player_hit_any_beam was used here,
    // which meant one direction hitting the player
    // could change how later directions were handled.
    // =================================================

    if (
        !hit_solid &&
        !beam_hit_player
    )
    {
        dist_hit =
            max(
                0,
                dist_hit - 4
            );

        hit_x =
            sx +
            dx *
            dist_hit;

        hit_y =
            sy +
            dy *
            dist_hit;
    }


    // =================================================
    // COMMIT THIS BEAM'S COMPLETE RESULT
    // =================================================

    laser_end_x[beam_i] =
        hit_x;

    laser_end_y[beam_i] =
        hit_y;

    laser_len[beam_i] =
        dist_hit;


    // ------------------------------------------------
    // DO NOT BREAK HERE.
    //
    // Even if this beam hit the player, directions
    // beam_i + 1 through 7 must still be calculated.
    // ------------------------------------------------
}


// ====================================================
// ALL EIGHT BEAMS ARE NOW COMPLETE.
//
// Only NOW may the player's death change game_phase and
// freeze the world.
// ====================================================

if (
    player_hit_any_beam &&
    player != noone
)
{
    with (player)
    {
        scr_player_died();
    }
}