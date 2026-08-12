/// oAdminLayerCannonProjectile — Create

event_inherited();

enabled = true;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spriteAdminLayerCannonProjectile;

image_speed = 0;


// ====================================================
// DEFAULT VALUES
//
// Cannon overwrites these after spawn.
// ====================================================

move_angle = 270;
move_speed = 5;

life_s = 8.0;

bounce_retention = 1.0;

projectile_frame = 0;

owner_cannon = noone;


// ====================================================
// COLLISION
// ====================================================

if (!variable_instance_exists(id, "collision_radius"))
{
    collision_radius = 3;
}

if (!variable_instance_exists(id, "player_hit_pad"))
{
    player_hit_pad = 1;
}


// ====================================================
// TRAIL SETTINGS
// ====================================================

// Distance travelled between trail dots.
if (!variable_instance_exists(id, "trail_spacing"))
{
    trail_spacing = 6;
}

// How long each dot lasts.
if (!variable_instance_exists(id, "trail_life_frames"))
{
    trail_life_frames = 22;
}

// Visual dot size.
if (!variable_instance_exists(id, "trail_radius"))
{
    trail_radius = 2.0;
}

// Allow trail to be disabled per projectile if needed.
if (!variable_instance_exists(id, "trail_enabled"))
{
    trail_enabled = true;
}

// Colour of the trail.
if (!variable_instance_exists(id, "trail_colour"))
{
    trail_colour =
        make_color_rgb(
            70,
            220,
            255
        );
}

// Internal travelled-distance accumulator.
trail_distance_accum = 0;

// Previous trail position.
trail_prev_x = x;
trail_prev_y = y;


// ====================================================
// DEBUG
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// INITIAL MOVEMENT STATE
// ====================================================

hsp = 0;
vsp = 0;

projectile_ready = false;


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

    image_speed = 0;


    // ------------------------------------------------
    // Reset trail origin
    // ------------------------------------------------
    trail_distance_accum = 0;

    trail_prev_x = x;
    trail_prev_y = y;


    projectile_ready = true;
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


    // ------------------------------------------------
    // Create just BEHIND the projectile.
    //
    // Higher depth = farther behind in GameMaker.
    // ------------------------------------------------
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


        // Make absolutely sure it draws.
        trail.visible = true;
    }
};

// ====================================================
// UPDATE TRAIL BY DISTANCE
//
// Called after each successful movement sub-step.
// ====================================================

update_trail = function(_old_x, _old_y, _new_x, _new_y)
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

    var seg_dx =
        _new_x - _old_x;

    var seg_dy =
        _new_y - _old_y;


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
    // =================================================

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
            return true;
        }
    }


    return false;
};