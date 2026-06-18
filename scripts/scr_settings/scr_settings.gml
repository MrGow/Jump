/// scr_settings

function scr_settings_init()
{
    if (!variable_global_exists("GAME_W")) global.GAME_W = 640;
    if (!variable_global_exists("GAME_H")) global.GAME_H = 360;

    if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 0.8;
    if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;

    if (!variable_global_exists("brightness")) global.brightness = 1.0;
    if (!variable_global_exists("contrast"))   global.contrast   = 1.0;

    global.display_mode_labels = ["windowed", "fullscreen", "borderless"];
    if (!variable_global_exists("display_mode_index")) global.display_mode_index = 0;
    global.display_mode_index = clamp(global.display_mode_index, 0, array_length(global.display_mode_labels) - 1);

    global.resolution_labels = ["640x360", "1280x720", "1920x1080"];
    global.resolution_scales = [1, 2, 3];
    if (!variable_global_exists("resolution_index")) global.resolution_index = 1;
    global.resolution_index = clamp(global.resolution_index, 0, array_length(global.resolution_labels) - 1);

    if (!variable_global_exists("fullscreen")) global.fullscreen = false;
}

function scr_settings_apply_music_gain()
{
    if (variable_global_exists("music_instance") && global.music_instance != noone) {
        audio_sound_gain(global.music_instance, global.vol_master * global.vol_music, 0);
    }
}

function scr_settings_apply_window_resolution()
{
    scr_settings_init();

    var sc = global.resolution_scales[global.resolution_index];

    window_set_fullscreen(false);
    window_set_showborder(true);
    window_set_size(global.GAME_W * sc, global.GAME_H * sc);
    window_center();

    global.fullscreen = false;

    gpu_set_texfilter(false);
    display_set_gui_size(global.GAME_W, global.GAME_H);

    if (surface_exists(application_surface)) {
        surface_resize(application_surface, global.GAME_W, global.GAME_H);
    }
}

function scr_settings_apply_display_mode()
{
    scr_settings_init();

    var mode = global.display_mode_labels[global.display_mode_index];

    if (mode == "windowed")
    {
        scr_settings_apply_window_resolution();
    }
    else if (mode == "fullscreen")
    {
        window_set_showborder(true);
        window_set_fullscreen(true);
        global.fullscreen = true;
    }
    else if (mode == "borderless")
    {
        window_set_fullscreen(false);
        window_set_showborder(false);
        window_set_position(0, 0);
        window_set_size(display_get_width(), display_get_height());
        global.fullscreen = false;
    }

    gpu_set_texfilter(false);
    display_set_gui_size(global.GAME_W, global.GAME_H);

    if (surface_exists(application_surface)) {
        surface_resize(application_surface, global.GAME_W, global.GAME_H);
    }
}

function scr_settings_adjust(_item, _change)
{
    scr_settings_init();

    switch (_item)
    {
        case "master_volume":
            global.vol_master = clamp(global.vol_master + _change * 0.1, 0, 1);
            scr_settings_apply_music_gain();
        break;

        case "music_volume":
            global.vol_music = clamp(global.vol_music + _change * 0.1, 0, 1);
            scr_settings_apply_music_gain();
        break;

        case "sfx_volume":
            global.vol_sfx = clamp(global.vol_sfx + _change * 0.1, 0, 1);
        break;

        case "brightness":
            global.brightness = clamp(global.brightness + _change * 0.1, 0.5, 1.5);
        break;

        case "contrast":
            global.contrast = clamp(global.contrast + _change * 0.1, 0.5, 1.5);
        break;

        case "display_mode":
            global.display_mode_index = clamp(
                global.display_mode_index + _change,
                0,
                array_length(global.display_mode_labels) - 1
            );
            scr_settings_apply_display_mode();
        break;

        case "resolution":
            global.resolution_index = clamp(
                global.resolution_index + _change,
                0,
                array_length(global.resolution_labels) - 1
            );

            if (global.display_mode_labels[global.display_mode_index] == "windowed") {
                scr_settings_apply_window_resolution();
            }
        break;
    }
}

function scr_settings_value01(_item)
{
    scr_settings_init();

    switch (_item)
    {
        case "master_volume": return global.vol_master;
        case "music_volume":  return global.vol_music;
        case "sfx_volume":    return global.vol_sfx;
        case "brightness":    return clamp((global.brightness - 0.5) / 1.0, 0, 1);
        case "contrast":      return clamp((global.contrast   - 0.5) / 1.0, 0, 1);
    }

    return 1;
}