/// oMainMenuRoomController — Create

persistent = false;
visible = false;

global.game_phase = "main_menu";
global.menu_demo_active = true;

global.menu_demo_left = false;
global.menu_demo_right = false;
global.menu_demo_jump_held = false;

scr_settings_init();
scr_settings_apply_audio_gains();

display_set_gui_size(640, 360);

view_enabled = true;
view_visible[0] = true;

if (view_camera[0] == -1) {
    view_camera[0] = camera_create_view(0, 0, 640, 360, 0, noone, -1, -1, -1, -1);
}

camera_set_view_size(view_camera[0], 640, 360);
camera_set_view_pos(view_camera[0], 0, 0);

demo_timer = 0;
demo_reset_time = room_speed * 12;

if (instance_exists(oPlayer)) {
    var p = instance_find(oPlayer, 0);
    demo_spawn_x = p.x;
    demo_spawn_y = p.y;
    p.debug_draw = false;
} else {
    demo_spawn_x = 64;
    demo_spawn_y = 64;
}