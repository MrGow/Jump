/// oBirdCompanion — Animation End


// ====================================================
// DEATH ANIMATION
//
// Keep the final feather-pile frame visible until the
// player respawns.
// ====================================================

if (
    variable_instance_exists(id, "bird_state") &&
    bird_state == "dead"
)
{
    if (sprite_index != -1)
    {
        image_index =
            max(
                0,
                image_number - 1
            );
    }

    image_speed = 0;

    exit;
}