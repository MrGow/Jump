/// oBirdCompanion — Animation End


// ====================================================
// DEATH ANIMATION
//
// Keep the final feather-pile frame visible until the
// player respawns.
// ====================================================

if (
    variable_instance_exists(
        id,
        "bird_state"
    ) &&
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


// ====================================================
// SPECIAL IDLE FINISHED
// ====================================================

var sprIdle =
    asset_get_index(
        "spriteBirdIdle"
    );

var sprIdle2 =
    asset_get_index(
        "spriteBirdIdle2"
    );


if (
    variable_instance_exists(
        id,
        "special_idle_active"
    ) &&
    special_idle_active &&
    sprIdle2 != -1 &&
    sprite_index == sprIdle2
)
{
    special_idle_active =
        false;

    special_idle_request =
        false;

    special_idle_cancel =
        false;

    last_owner_state =
        "";


    if (sprIdle != -1)
    {
        sprite_index =
            sprIdle;

        image_index = 0;

        image_speed =
            bird_idle_anim_speed;
    }


    // Begin the cooldown only after all three taps and
    // the complete special animation have finished.

    if (instance_exists(owner))
    {
        owner.bird_idle_cooldown =
            irandom_range(
                round(room_speed * 25),
                round(room_speed * 35)
            );

        owner.bird_idle_wait_timer =
            0;

        owner.bird_idle_wait_target =
            irandom_range(
                round(room_speed * 16),
                round(room_speed * 17)
            );
    }


    exit;
}