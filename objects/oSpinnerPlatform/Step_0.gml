/// oSpinnerPlatform — Step


if (!enabled)
{
    active =
        false;


    dx =
        0;


    dy =
        0;


    exit;
}


active =
    true;


// Always horizontal.
image_angle =
    0;


// Refresh floor-surface height after being moved.
surface_y =
    bbox_top
    +
    surface_y_offset;