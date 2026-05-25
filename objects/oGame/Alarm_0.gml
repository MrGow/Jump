/// oGame — Alarm 0

if (!window_get_fullscreen()) {
    window_set_size(global.GAME_W * global.window_scale, global.GAME_H * global.window_scale);
    window_center();
}

if (surface_exists(application_surface)) {
    surface_resize(application_surface, global.GAME_W, global.GAME_H);
}

display_set_gui_size(global.GAME_W, global.GAME_H);
application_surface_draw_enable(true);
gpu_set_texfilter(false);