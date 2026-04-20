/// oDeathMenu — Step

// Fade in
if (alpha < 1) {
    alpha = clamp(alpha + fade_speed, 0, 1);
}

// Use jump as confirm / "Climb again"
var confirm = false;
if (variable_global_exists("inp_jump_press")) {
    confirm = global.inp_jump_press;
} else {
    confirm = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up);
}

// Start climb again
if (confirm) {
    if (instance_exists(oRunController)) {
        with (oRunController) {
            if (instance_exists(oPlayer)) {
                with (oPlayer) {
                    x = other.spawn_x;
                    y = other.spawn_y;

                    if (!variable_instance_exists(id, "hsp")) hsp = 0;
                    if (!variable_instance_exists(id, "vsp")) vsp = 0;
                    hsp = 0;
                    vsp = 0;

                    state = "idle";

                    // Clear fall-death state
                    if (variable_instance_exists(id, "death_fall")) death_fall = false;
                    if (variable_instance_exists(id, "death_cam_lock_x")) death_cam_lock_x = x;
                    if (variable_instance_exists(id, "death_cam_lock_y")) death_cam_lock_y = y;

                    // HP safety
                    if (!variable_instance_exists(id, "max_hp")) max_hp = 1;
                    if (!variable_instance_exists(id, "hp"))     hp = max_hp;
                    hp = max_hp;

                    sprite_index = spriteBotIdle;
                    image_index  = 0;
                    image_speed  = 0.2;
                }
            }
        }
    }

    global.game_phase = "playing";
    instance_destroy();
}