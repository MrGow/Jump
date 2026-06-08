/// oMainMenuRoomController — Step

global.game_phase = "main_menu";
global.menu_demo_active = true;

// Keep camera fixed
var cam = view_camera[0];
camera_set_view_size(cam, 640, 360);
camera_set_view_pos(cam, 0, 0);

// Remove death menu if hazards kill the demo player
if (instance_exists(oDeathMenu)) {
    with (oDeathMenu) instance_destroy();
}

// Demo input defaults
global.menu_demo_left = false;
global.menu_demo_right = false;
global.menu_demo_jump_held = false;

demo_timer++;

// Simple repeatable demo pattern.
// Adjust these timings depending on your background layout.
var t = demo_timer mod demo_reset_time;

// Face / move right most of the time
if (t >= 1 && t < 260) {
    global.menu_demo_right = true;
}

// First charged jump
if (t >= 20 && t < 55) {
    global.menu_demo_jump_held = true;
}

// Second charged jump
if (t >= 115 && t < 150) {
    global.menu_demo_jump_held = true;
}

// Third charged jump
if (t >= 210 && t < 245) {
    global.menu_demo_jump_held = true;
}

// Reset demo player after loop or death
if (instance_exists(oPlayer)) {
    var p = instance_find(oPlayer, 0);

    p.debug_draw = false;

    if (t == 0 || p.state == "dead") {
        p.x = demo_spawn_x;
        p.y = demo_spawn_y;
        p.hsp = 0;
        p.vsp = 0;
        p.state = "idle";
        p.death_fall = false;
        p.jump_charging = false;
        p.jump_charge = 0;
        p.jump_charge_level = 0;
        p.prev_jump_h = false;

        if (asset_get_index("spriteBotIdle") != -1) {
            p.sprite_index = spriteBotIdle;
            p.image_index = 0;
            p.image_speed = 1;
        }

        if (instance_exists(oDeathMenu)) {
            with (oDeathMenu) instance_destroy();
        }
    }
}