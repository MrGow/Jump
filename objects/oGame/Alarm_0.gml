/// oGame — Alarm 0

scr_settings_init();
scr_settings_apply_display_mode();

if (surface_exists(application_surface)) {
    surface_resize(application_surface, global.GAME_W, global.GAME_H);
}

display_set_gui_size(global.GAME_W, global.GAME_H);
application_surface_draw_enable(false);
gpu_set_texfilter(false);