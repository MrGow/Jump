/// oAdminLayerCannonProjectile — Create

event_inherited();

enabled = true;

depth = -2000;
// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spriteAdminLayerCannonProjectile;


image_speed =
    0;


// ====================================================
// DEFAULT VALUES
//
// The cannon overwrites these immediately after spawn.
// ====================================================

move_angle =
    270;


move_speed =
    5;


life_s =
    8.0;


bounce_retention =
    1.0;


projectile_frame =
    0;


owner_cannon =
    noone;


// ====================================================
// BOUNCE SOUNDS
// ====================================================

snd_bounce =
[
    asset_get_index(
        "BouncingBallGunBounce1"
    ),

    asset_get_index(
        "BouncingBallGunBounce2"
    ),

    asset_get_index(
        "BouncingBallGunBounce3"
    )
];


if (!variable_instance_exists(id, "bounce_sound_gain"))
{
    bounce_sound_gain =
        1.0;
}


// ----------------------------------------------------
// Prevent corner collisions from producing multiple
// simultaneous bounce sounds.
//
// At normal projectile speed this is short enough to
// have no audible effect on legitimate separate hits.
// ----------------------------------------------------

if (!variable_instance_exists(id, "bounce_sound_cooldown_frames"))
{
    bounce_sound_cooldown_frames =
        2;
}


bounce_sound_cooldown =
    0;


// ====================================================
// PLAY BOUNCE SOUND
// ====================================================

play_bounce_sound = function()
{
    if (bounce_sound_cooldown > 0)
    {
        return;
    }


    var valid_sounds = [];


    for (
        var i = 0;
        i < array_length(snd_bounce);
        i++
    )
    {
        if (snd_bounce[i] != -1)
        {
            array_push(
                valid_sounds,
                snd_bounce[i]
            );
        }
    }


    if (array_length(valid_sounds) <= 0)
    {
        return;
    }


    var snd =
        valid_sounds[
            irandom(
                array_length(valid_sounds) - 1
            )
        ];


    var voice =
        audio_play_sound(
            snd,
            100,
            false
        );


    if (voice != noone)
    {
        audio_sound_gain(
            voice,
            bounce_sound_gain,
            0
        );
    }


    bounce_sound_cooldown =
        bounce_sound_cooldown_frames;
};


// ====================================================
// COLLISION
// ====================================================

if (!variable_instance_exists(id, "collision_radius"))
{
    collision_radius =
        3;
}


if (!variable_instance_exists(id, "player_hit_pad"))
{
    player_hit_pad =
        1;
}


// ====================================================
// TRAIL SETTINGS
// ====================================================

if (!variable_instance_exists(id, "trail_spacing"))
{
    trail_spacing =
        5;
}


if (!variable_instance_exists(id, "trail_life_frames"))
{
    trail_life_frames =
        38;
}


if (!variable_instance_exists(id, "trail_radius"))
{
    trail_radius =
        1.25;
}


if (!variable_instance_exists(id, "trail_enabled"))
{
    trail_enabled =
        true;
}


if (!variable_instance_exists(id, "trail_colour"))
{
    trail_colour =
        make_color_rgb(
            70,
            220,
            255
        );
}


trail_distance_accum =
    0;


trail_prev_x =
    x;


trail_prev_y =
    y;


// ====================================================
// DEBUG
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw =
        false;
}


// ====================================================
// INITIAL MOVEMENT STATE
// ====================================================

hsp =
    0;


vsp =
    0;


projectile_ready =
    false;


// ====================================================
// LIFETIME DEFAULT
// ====================================================

life_frames =
    max(
        1,
        round(
            life_s *
            room_speed
        )
    );


life_timer =
    life_frames;


// ====================================================
// PROJECTILE SETUP
// ====================================================

setup_projectile = function()
{
    move_angle =
        ((move_angle mod 360) + 360)
        mod 360;


    move_speed =
        max(
            0,
            move_speed
        );


    // ------------------------------------------------
    // Actual launch velocity
    // ------------------------------------------------

    hsp =
        lengthdir_x(
            move_speed,
            move_angle
        );


    vsp =
        lengthdir_y(
            move_speed,
            move_angle
        );


    // ------------------------------------------------
    // Lifetime
    // ------------------------------------------------

    life_frames =
        max(
            1,
            round(
                life_s *
                room_speed
            )
        );


    life_timer =
        life_frames;


    // ------------------------------------------------
    // Bounce retention
    // ------------------------------------------------

    bounce_retention =
        clamp(
            bounce_retention,
            0,
            1
        );


    // ------------------------------------------------
    // Projectile appearance
    // ------------------------------------------------

    projectile_frame =
        clamp(
            round(projectile_frame),
            0,
            image_number - 1
        );


    image_index =
        projectile_frame;


    image_speed =
        0;


    // ------------------------------------------------
    // Reset trail
    // ------------------------------------------------

    trail_distance_accum =
        0;


    trail_prev_x =
        x;


    trail_prev_y =
        y;


    // ------------------------------------------------
    // Reset bounce audio
    // ------------------------------------------------

    bounce_sound_cooldown =
        0;


    projectile_ready =
        true;
};


// ====================================================
// SPAWN TRAIL DOT
// ====================================================

spawn_trail_dot = function(_x, _y)
{
    if (!trail_enabled)
    {
        return;
    }


    var trail =
        instance_create_depth(
            _x,
            _y,
            depth + 1,
            oAdminLayerCannonProjectileTrail
        );


    if (trail != noone)
    {
        trail.trail_life_frames =
            trail_life_frames;


        trail.life_total =
            max(
                1,
                round(
                    trail_life_frames
                )
            );


        trail.life_timer =
            trail.life_total;


        trail.trail_radius =
            trail_radius;


        trail.trail_colour =
            trail_colour;


        trail.visible =
            true;
    }
};


// ====================================================
// UPDATE TRAIL BY DISTANCE
// ====================================================

update_trail = function(
    _old_x,
    _old_y,
    _new_x,
    _new_y
)
{
    if (!trail_enabled)
    {
        return;
    }


    var seg_len =
        point_distance(
            _old_x,
            _old_y,
            _new_x,
            _new_y
        );


    if (seg_len <= 0)
    {
        return;
    }


    var remaining =
        seg_len;


    var travelled =
        0;


    while (
        trail_distance_accum +
        remaining
        >=
        trail_spacing
    )
    {
        var needed =
            trail_spacing -
            trail_distance_accum;


        travelled +=
            needed;


        var t =
            travelled /
            seg_len;


        var trail_x =
            lerp(
                _old_x,
                _new_x,
                t
            );


        var trail_y =
            lerp(
                _old_y,
                _new_y,
                t
            );


        spawn_trail_dot(
            trail_x,
            trail_y
        );


        remaining -=
            needed;


        trail_distance_accum =
            0;
    }


    trail_distance_accum +=
        remaining;
};


// ====================================================
// SOLID TEST
// ====================================================

hits_solid =
function(_test_x, _test_y)
{
    var r =
        collision_radius;


    // =================================================
    // TILE SOLIDS
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
                        _test_x,
                        _test_y
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x - r,
                        _test_y
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x + r,
                        _test_y
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x,
                        _test_y - r
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x,
                        _test_y + r
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x - r,
                        _test_y - r
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x + r,
                        _test_y - r
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x - r,
                        _test_y + r
                    ) != 0
                )
                {
                    return true;
                }


                if (
                    tilemap_get_at_pixel(
                        tm,
                        _test_x + r,
                        _test_y + r
                    ) != 0
                )
                {
                    return true;
                }
            }
        }
    }


    // =================================================
    // DYNAMIC SOLIDS
    // ====================================================

    var dyn_obj =
        asset_get_index(
            "oSolidDyn"
        );


    if (dyn_obj != -1)
    {
        var dyn_hit =
            collision_rectangle(
                _test_x - r,
                _test_y - r,
                _test_x + r,
                _test_y + r,
                dyn_obj,
                false,
                true
            );


        if (dyn_hit != noone)
        {
            var own_cannon_solid =
                false;


            if (
                variable_instance_exists(
                    dyn_hit,
                    "owner_cannon"
                )
                &&
                owner_cannon != noone
                &&
                dyn_hit.owner_cannon ==
                    owner_cannon
            )
            {
                own_cannon_solid =
                    true;
            }


            if (!own_cannon_solid)
            {
                return true;
            }
        }
    }


    return false;
};