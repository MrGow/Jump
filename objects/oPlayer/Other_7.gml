/// oPlayer - Animation End

var sprIdle    = asset_get_index("spriteBotIdle");
var sprJumping = asset_get_index("spriteBotJumping");
var sprGlide   = asset_get_index("spriteBotGliding");
var sprLanding = asset_get_index("spriteBotLanding");
var sprDeath   = asset_get_index("spriteBotDeath");

if (!variable_instance_exists(id, "jump_pose_timer")) jump_pose_timer = 0;

if (state == "dead") {
    if (sprDeath != -1 && sprite_index == sprDeath) {
        image_index = image_number - 1;
        image_speed = 0;
    }
    exit;
}

if (state == "landing" || (sprLanding != -1 && sprite_index == sprLanding)) {
    if (!bounce_pending) {
        state = "idle";
        jump_pose_timer = 0;

        if (sprIdle != -1) {
            sprite_index = sprIdle;
            image_speed = 1;
            image_index = 0;
        }
    }
    exit;
}

// Do not instantly skip spriteBotJumping if it is only 1 frame.
if (state == "jumping" || (sprJumping != -1 && sprite_index == sprJumping)) {
    if (jump_pose_timer > 0) {
        exit;
    }

    state = "glide";

    if (sprGlide != -1) {
        sprite_index = sprGlide;
        image_speed = 1;
        image_index = 0;
    }

    exit;
}

if (state == "idle" && sprIdle != -1) {
    jump_pose_timer = 0;
    sprite_index = sprIdle;
    image_speed = 1;
}