/// oFloatingLaserGun — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_laser_shoot"))
{
    snd_laser_shoot =
        asset_get_index(
            "LaserGunShoot1"
        );
}

if (!variable_instance_exists(id, "laser_shoot_gain"))
{
    laser_shoot_gain = 0.9;
}

if (!variable_instance_exists(id, "laser_sfx_inner_dist"))
{
    laser_sfx_inner_dist = 120;
}

if (!variable_instance_exists(id, "laser_sfx_outer_dist"))
{
    laser_sfx_outer_dist = 520;
}

if (!variable_instance_exists(id, "laser_shot_sfx_played"))
{
    laser_shot_sfx_played = false;
}

if (!variable_instance_exists(id, "anim_speed"))
{
    anim_speed = 0.35;
}

if (!variable_instance_exists(id, "patrol_speed"))
{
    patrol_speed = 1.5;
}


// ====================================================
// PAUSE / GAME FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    // Keep helper attached even while frozen.
    if (
        variable_instance_exists(id, "solid_inst") &&
        instance_exists(solid_inst)
    )
    {
        solid_inst.x = x;
        solid_inst.y = y;

        solid_inst.image_angle =
            image_angle;

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

    laser_len = 0;

    if (
        variable_instance_exists(id, "solid_inst") &&
        instance_exists(solid_inst)
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
    instance_exists(patrol_point)
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
    variable_instance_exists(id, "solid_inst") &&
    instance_exists(solid_inst)
)
{
    solid_inst.x = x;
    solid_inst.y = y;

    solid_inst.image_angle =
        image_angle;

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


    laser_fx_frame +=
        sprite_get_speed(
            spriteLaserGunRepeatingRay
        )
        /
        room_speed;


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

        laser_len = 0;
    }
}


// ====================================================
// NO ACTIVE LASER
// ====================================================

if (!active)
{
    laser_len = 0;

    exit;
}


// ====================================================
// LASER START POINT
// ====================================================

var sx =
    x +
    lengthdir_x(
        laser_start_dist,
        laser_dir
    );

var sy =
    y +
    lengthdir_y(
        laser_start_dist,
        laser_dir
    );

laser_start_x = sx;
laser_start_y = sy;


// ====================================================
// LASER VECTOR
// ====================================================

var dx =
    lengthdir_x(
        1,
        laser_dir
    );

var dy =
    lengthdir_y(
        1,
        laser_dir
    );


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

var hit_player =
    noone;

var hit_solid =
    false;


// ====================================================
// FIND FIRST SOLID
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


// ====================================================
// PLAYER COLLISION
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


if (p != noone)
{
    var player_dead =
        variable_instance_exists(
            p,
            "state"
        ) &&
        p.state == "dead";


    if (!player_dead)
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

                    p.bbox_left,
                    p.bbox_top,
                    p.bbox_right,
                    p.bbox_bottom
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

                hit_player =
                    p;

                break;
            }
        }
    }
}


// ====================================================
// FULL-LENGTH VISUAL END
// ====================================================

if (
    !hit_solid &&
    hit_player == noone
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


laser_end_x =
    hit_x;

laser_end_y =
    hit_y;

laser_len =
    dist_hit;


// ====================================================
// KILL PLAYER
// ====================================================

if (hit_player != noone)
{
    with (hit_player)
    {
        scr_player_died();
    }
}