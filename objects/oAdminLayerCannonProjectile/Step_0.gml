/// oAdminLayerCannonProjectile — Step


// ====================================================
// WAIT UNTIL CANNON INITIALISES US
// ====================================================

if (
    !variable_instance_exists(
        id,
        "projectile_ready"
    )
    ||
    !projectile_ready
)
{
    exit;
}


// ====================================================
// PAUSE / DEATH FREEZE
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
    instance_destroy();
    exit;
}


// ====================================================
// LIFETIME
// ====================================================

life_timer--;

if (life_timer <= 0)
{
    instance_destroy();
    exit;
}


// ====================================================
// SUB-STEP MOVEMENT
// ====================================================

var max_component =
    max(
        abs(hsp),
        abs(vsp)
    );

var move_steps =
    max(
        1,
        ceil(
            max_component
        )
    );


var step_x =
    hsp /
    move_steps;

var step_y =
    vsp /
    move_steps;


// ====================================================
// MOVE / BOUNCE
// ====================================================

for (
    var move_i = 0;
    move_i < move_steps;
    move_i++
)
{
    // =================================================
    // X AXIS
    // =================================================

    if (abs(step_x) > 0.0001)
    {
        if (
            hits_solid(
                x + step_x,
                y
            )
        )
        {
            hsp =
                -hsp *
                bounce_retention;

            step_x =
                hsp /
                move_steps;
        }
        else
        {
            var old_x =
                x;

            var old_y =
                y;

            x +=
                step_x;

            update_trail(
                old_x,
                old_y,
                x,
                y
            );
        }
    }


    // =================================================
    // Y AXIS
    // =================================================

    if (abs(step_y) > 0.0001)
    {
        if (
            hits_solid(
                x,
                y + step_y
            )
        )
        {
            vsp =
                -vsp *
                bounce_retention;

            step_y =
                vsp /
                move_steps;
        }
        else
        {
            var old_x_y =
                x;

            var old_y_y =
                y;

            y +=
                step_y;

            update_trail(
                old_x_y,
                old_y_y,
                x,
                y
            );
        }
    }


    // =================================================
    // PLAYER COLLISION
    // =================================================

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
            )
            &&
            p.state == "dead";


        if (!player_dead)
        {
            var r =
                max(
                    0,
                    collision_radius -
                    player_hit_pad
                );


            var player_hit =
                p.bbox_right >
                    x - r
                &&
                p.bbox_left <
                    x + r
                &&
                p.bbox_bottom >
                    y - r
                &&
                p.bbox_top <
                    y + r;


            if (player_hit)
            {
                with (p)
                {
                    scr_player_died();
                }

                exit;
            }
        }
    }
}


// ====================================================
// KEEP PROJECTILE SPRITE ON SELECTED COLOUR FRAME
// ====================================================

image_speed = 0;

image_index =
    projectile_frame;