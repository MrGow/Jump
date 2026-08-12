/// oAdminLayerCannon — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "state"))
{
    state = "waiting";
}

if (!variable_instance_exists(id, "projectile_released"))
{
    projectile_released = false;
}

if (!variable_instance_exists(id, "idle_sprite"))
{
    idle_sprite =
        spriteAdminLayerCannonPatrol;
}

if (!variable_instance_exists(id, "shoot_sprite"))
{
    shoot_sprite =
        spriteAdminLayerCannonShoot;
}

if (!variable_instance_exists(id, "cannon_direction"))
{
    cannon_direction = 2;
}

if (!variable_instance_exists(id, "release_local_frame"))
{
    release_local_frame = 1;
}

if (!variable_instance_exists(id, "shoot_anim_speed"))
{
    shoot_anim_speed = 0.30;
}

if (!variable_instance_exists(id, "shot_interval_s"))
{
    shot_interval_s = 2.0;
}

if (!variable_instance_exists(id, "shot_interval_frames"))
{
    shot_interval_frames =
        max(
            1,
            round(
                shot_interval_s *
                room_speed
            )
        );
}

if (!variable_instance_exists(id, "shot_timer"))
{
    shot_timer =
        shot_interval_frames;
}

if (!variable_instance_exists(id, "muzzle_dist"))
{
    muzzle_dist = 29;
}

if (!variable_instance_exists(id, "projectile_speed"))
{
    projectile_speed = 5;
}

if (!variable_instance_exists(id, "projectile_life_s"))
{
    projectile_life_s = 8;
}

if (!variable_instance_exists(id, "bounce_retention"))
{
    bounce_retention = 1;
}

if (!variable_instance_exists(id, "projectile_frame"))
{
    projectile_frame = 0;
}


// ====================================================
// HOT-RELOAD DIRECTION FUNCTION
// ====================================================

if (!variable_instance_exists(id, "refresh_direction"))
{
    refresh_direction = function()
    {
        cannon_direction =
            clamp(
                round(cannon_direction),
                0,
                4
            );

        switch (cannon_direction)
        {
            case 0:
                shot_angle = 180;
            break;

            case 1:
                shot_angle = 225;
            break;

            case 2:
                shot_angle = 270;
            break;

            case 3:
                shot_angle = 315;
            break;

            case 4:
                shot_angle = 0;
            break;
        }

        idle_frame =
            cannon_direction;

        shoot_start_frame =
            cannon_direction * 3;

        shoot_end_frame =
            shoot_start_frame + 2;

        shoot_release_frame =
            shoot_start_frame +
            clamp(
                round(release_local_frame),
                0,
                2
            );
    };
}


// ====================================================
// REFRESH EDITOR-SELECTED DIRECTION
// ====================================================

refresh_direction();


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

    solid_inst.enabled =
        enabled;

    solid_inst.active =
        enabled;

    solid_inst.debug_draw =
        debug_draw;
}


// ====================================================
// PAUSE / DEATH FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;

    if (
        variable_instance_exists(id, "solid_inst") &&
        instance_exists(solid_inst)
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
    state = "waiting";

    sprite_index =
        idle_sprite;

    image_index =
        idle_frame;

    image_speed = 0;

    projectile_released = false;

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
// WAITING
// ====================================================

if (state == "waiting")
{
    sprite_index =
        idle_sprite;

    image_speed = 0;

    image_index =
        idle_frame;


    shot_timer--;


    if (shot_timer <= 0)
    {
        state =
            "shooting";

        sprite_index =
            shoot_sprite;

        image_index =
            shoot_start_frame;

        image_speed = 0;

        projectile_released =
            false;
    }

    exit;
}


// ====================================================
// SHOOTING
// ====================================================

if (state == "shooting")
{
    sprite_index =
        shoot_sprite;

    image_speed = 0;


    var previous_frame =
        image_index;


    image_index +=
        shoot_anim_speed;


    // =================================================
    // RELEASE PROJECTILE
    // =================================================

    if (
        !projectile_released
        &&
        previous_frame <
            shoot_release_frame
        &&
        image_index >=
            shoot_release_frame
    )
    {
        projectile_released = true;


        // --------------------------------------------
        // Muzzle position
        // --------------------------------------------
        var spawn_x =
            x +
            lengthdir_x(
                muzzle_dist,
                shot_angle
            );

        var spawn_y =
            y +
            lengthdir_y(
                muzzle_dist,
                shot_angle
            );


        // --------------------------------------------
        // Create projectile
        // --------------------------------------------
        var ball =
            instance_create_layer(
                spawn_x,
                spawn_y,
                "Instances",
                oAdminLayerCannonProjectile
            );


        if (ball != noone)
        {
            ball.move_angle =
                shot_angle;

            ball.move_speed =
                projectile_speed;

            ball.life_s =
                projectile_life_s;

            ball.bounce_retention =
                bounce_retention;

            ball.projectile_frame =
                projectile_frame;

            ball.owner_cannon =
                id;


            // ----------------------------------------
            // Apply real velocity after Create.
            // ----------------------------------------
            if (
                variable_instance_exists(
                    ball,
                    "setup_projectile"
                )
                &&
                is_callable(
                    ball.setup_projectile
                )
            )
            {
                ball.setup_projectile();
            }
        }
    }


    // =================================================
    // END SHOOTING ANIMATION
    // =================================================

    if (
        image_index >=
        shoot_end_frame
    )
    {
        state =
            "waiting";

        shot_timer =
            shot_interval_frames;

        projectile_released =
            false;

        sprite_index =
            idle_sprite;

        image_index =
            idle_frame;

        image_speed = 0;
    }

    exit;
}


// ====================================================
// UNKNOWN STATE SAFETY
// ====================================================

state = "waiting";

sprite_index =
    idle_sprite;

image_index =
    idle_frame;

image_speed = 0;

shot_timer =
    shot_interval_frames;

projectile_released =
    false;