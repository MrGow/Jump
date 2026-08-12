/// oAdminLayerCannonProjectileTrail — Create

// Purely visual.
visible = true;


// ====================================================
// EDITOR / ASSIGNED VARIABLES
//
// These are usually assigned immediately after spawn
// by oAdminLayerCannonProjectile.
// ====================================================

if (!variable_instance_exists(id, "trail_life_frames"))
{
    trail_life_frames = 160;
}

if (!variable_instance_exists(id, "trail_start_scale"))
{
    trail_start_scale = 1.0;
}

if (!variable_instance_exists(id, "trail_end_scale"))
{
    trail_end_scale = 0.35;
}

if (!variable_instance_exists(id, "trail_radius"))
{
    trail_radius = 2.0;
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


// ====================================================
// STATE
// ====================================================

life_total =
    max(
        1,
        round(
            trail_life_frames
        )
    );

life_timer =
    life_total;