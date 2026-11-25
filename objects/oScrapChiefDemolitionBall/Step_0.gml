/// oScrapChiefDemolitionBall — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// FIND CONTROLLER
// ====================================================

if (!instance_exists(controller))
{
    controller = instance_find(
        oScrapChiefController,
        0
    );
}


// ====================================================
// BOSS ACTIVATION
// ====================================================

if (instance_exists(controller))
{
    active =
        controller.boss_active &&
        !controller.sequence_complete;
}
else
{
    active = false;
}


// ====================================================
// CHAIN SAFETY
// ====================================================

chain_attached =
    instance_exists(chain) &&
    instance_exists(carriage);

if (!chain_attached)
{
    visible = false;
}


// ====================================================
// IDLE ANIMATION
// ====================================================

var frame_count = sprite_get_number(
    sprite_index
);

var playback_speed = sprite_get_speed(
    sprite_index
);

if (
    sprite_get_speed_type(sprite_index) ==
    spritespeed_framespersecond
)
{
    playback_speed /= room_speed;
}

animation_frame += playback_speed;

animation_frame =
    animation_frame mod max(1, frame_count);

image_index = floor(animation_frame);