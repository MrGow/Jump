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

if (confirm)
{
    var target_room = room;
    var target_x = 0;
    var target_y = 0;

    // Prefer active checkpoint
    if (variable_global_exists("checkpoint_set") && global.checkpoint_set) {
        target_room = global.checkpoint_room;
        target_x    = global.checkpoint_x;
        target_y    = global.checkpoint_y;
    }
    // Fallback to current room spawn
    else if (instance_exists(oRunController)) {
        target_x = oRunController.spawn_x;
        target_y = oRunController.spawn_y;
    }

    global.game_phase = "playing";

    // Cross-room respawn
    if (target_room != room)
    {
        global.pending_respawn      = true;
        global.pending_respawn_room = target_room;
        global.pending_respawn_x    = target_x;
        global.pending_respawn_y    = target_y;

        instance_destroy();
        room_goto(target_room);
        exit;
    }

    // Same-room respawn
    if (instance_exists(oRunController)) {
        with (oRunController) {
            spawn_x = target_x;
            spawn_y = target_y;

            if (instance_exists(oPlayer)) {
                with (oPlayer) {
                    x = other.spawn_x;
                    y = other.spawn_y;

                    if (!variable_instance_exists(id, "hsp")) hsp = 0;
                    if (!variable_instance_exists(id, "vsp")) vsp = 0;
                    hsp = 0;
                    vsp = 0;

                    state = "idle";

                    if (variable_instance_exists(id, "death_fall")) death_fall = false;
                    if (variable_instance_exists(id, "death_cam_lock_x")) death_cam_lock_x = x;
                    if (variable_instance_exists(id, "death_cam_lock_y")) death_cam_lock_y = y;

                    if (!variable_instance_exists(id, "max_hp")) max_hp = 1;
                    if (!variable_instance_exists(id, "hp"))     hp = max_hp;
                    hp = max_hp;

                    sprite_index = spriteBotIdle;
                    image_index  = 0;
                    image_speed  = 0.2;
                    image_xscale = facing;

                    if (variable_instance_exists(id, "jump_charging"))     jump_charging = false;
                    if (variable_instance_exists(id, "jump_charge"))       jump_charge = 0;
                    if (variable_instance_exists(id, "jump_charge_level")) jump_charge_level = 0;
                    if (variable_instance_exists(id, "bounce_pending"))    bounce_pending = false;
                    if (variable_instance_exists(id, "bounce_timer"))      bounce_timer = 0;
                    if (variable_instance_exists(id, "standing_platform")) standing_platform = noone;
                    if (variable_instance_exists(id, "coyote_timer"))      coyote_timer = 0;
                }
            }
        }
    }

    instance_destroy();
}