
/// oPlayer — Animation End

var sprIdle =
    asset_get_index("spriteBotIdle");

var sprJumping =
    asset_get_index("spriteBotJumping");

var sprGlide =
    asset_get_index("spriteBotGliding");

var sprLanding =
    asset_get_index("spriteBotLanding");


if (!variable_instance_exists(id, "jump_pose_timer"))
{
    jump_pose_timer = 0;
}


// ====================================================
// DEAD
// ====================================================

if (state == "dead")
{
    if (
        variable_instance_exists(
            id,
            "death_uses_player_sprite"
        ) &&
        death_uses_player_sprite
    )
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
// LANDING
// ====================================================

if (
    state == "landing" ||
    (
        sprLanding != -1 &&
        sprite_index == sprLanding
    )
)
{
    if (!bounce_pending)
    {
        state = "idle";
        jump_pose_timer = 0;

        if (sprIdle != -1)
        {
            sprite_index = sprIdle;
            image_speed = 1;
            image_index = 0;
        }
    }

    exit;
}


// ====================================================
// JUMP LAUNCH
// ====================================================

if (
    state == "jumping" ||
    (
        sprJumping != -1 &&
        sprite_index == sprJumping
    )
)
{
    if (jump_pose_timer > 0)
    {
        exit;
    }

    state = "glide";

    if (sprGlide != -1)
    {
        sprite_index = sprGlide;
        image_speed = 1;
        image_index = 0;
    }

    exit;
}


// ====================================================
// IDLE
// ====================================================

if (
    state == "idle" &&
    sprIdle != -1
)
{
    jump_pose_timer = 0;
    sprite_index = sprIdle;
    image_speed = 1;
}