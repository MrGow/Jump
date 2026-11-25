/// oScrapChief — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ATTACHMENT SAFETY
// ====================================================

if (
    !instance_exists(carriage) ||
    !instance_exists(chain)
)
{
    active = false;
    visible = false;

    chain_attached = false;

    exit;
}


// ====================================================
// VISIBILITY
// ====================================================

visible = carriage.visible;

active = visible;

if (!visible)
{
    exit;
}


// ====================================================
// IDLE ANIMATION
//
// Respect the sprite's configured animation speed.
// ====================================================

var sprite_speed = sprite_get_speed(
    sprite_index
);

var speed_type = sprite_get_speed_type(
    sprite_index
);

var frame_advance = sprite_speed;

if (speed_type == spritespeed_framespersecond)
{
    frame_advance =
        sprite_speed / max(1, room_speed);
}

animation_frame +=
    frame_advance * idle_animation_speed;

var frame_count = max(
    1,
    sprite_get_number(sprite_index)
);

animation_frame =
    animation_frame mod frame_count;

image_index = floor(animation_frame);