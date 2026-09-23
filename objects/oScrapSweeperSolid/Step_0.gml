/// oScrapSweeperSolid — Step


// ====================================================
// OWNER SAFETY
// ====================================================

if (!instance_exists(owner_sweeper))
{
    instance_destroy();
    exit;
}


// ====================================================
// FOLLOW OWNER STATE
// ====================================================

enabled =
    owner_sweeper.enabled;

active =
    owner_sweeper.enabled;


// ====================================================
// COLLISION WIDTH
// ====================================================

solid_width =
    max(
        1,
        owner_sweeper.body_solid_width
    );


// ====================================================
// POSITION
// ====================================================

x =
    owner_sweeper.body_solid_centre_x;

y =
    owner_sweeper.y;


// ====================================================
// SCALE COLLISION MASK
//
// Source mask is 16px wide.
// ====================================================

image_xscale =
    solid_width / 16;

image_yscale = 1;