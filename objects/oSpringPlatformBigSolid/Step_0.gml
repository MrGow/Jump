/// oSpringPlatformBigSolid — Step


// ====================================================
// STATE
// ====================================================

enabled = true;
active  = true;


// ====================================================
// KEEP SIDE COLLISION BELOW LANDING SURFACE
// ====================================================

if (!variable_instance_exists(id, "side_collision_top_inset"))
{
    side_collision_top_inset = 6;
}

if (!variable_instance_exists(id, "solid_base_y"))
{
    solid_base_y =
        y -
        side_collision_top_inset;
}

y =
    solid_base_y +
    side_collision_top_inset;