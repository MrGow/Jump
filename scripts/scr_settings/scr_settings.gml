/// scr_settings

function scr_settings_init()
{
    if (!variable_global_exists("GAME_W")) global.GAME_W = 640;
    if (!variable_global_exists("GAME_H")) global.GAME_H = 360;

    if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 0.8;
    if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;

    // ----------------------------------------------------
    // Audio groups
    // ----------------------------------------------------
    // SFX group: player sounds, hazard sounds, UI sounds.
    if (!audio_group_is_loaded(audiogroupsfx)) {
        audio_group_load(audiogroupsfx);
    }

    // Atmosphere group: ambience loops and future music.
    if (!audio_group_is_loaded(audiogroupatmosphere)) {
        audio_group_load(audiogroupatmosphere);
    }

    scr_settings_apply_audio_gains();

    if (!variable_global_exists("brightness")) global.brightness = 1.0;
    if (!variable_global_exists("contrast"))   global.contrast   = 1.0;

    global.display_mode_labels = [
        "windowed",
        "fullscreen",
        "borderless"
    ];

    if (!variable_global_exists("display_mode_index")) {
        global.display_mode_index = 0;
    }

    global.display_mode_index = clamp(
        global.display_mode_index,
        0,
        array_length(global.display_mode_labels) - 1
    );

    global.resolution_labels = [
        "640x360",
        "1280x720",
        "1920x1080"
    ];

    global.resolution_scales = [
        1,
        2,
        3
    ];

    if (!variable_global_exists("resolution_index")) {
        global.resolution_index = 1;
    }

    global.resolution_index = clamp(
        global.resolution_index,
        0,
        array_length(global.resolution_labels) - 1
    );

    if (!variable_global_exists("fullscreen")) {
        global.fullscreen = false;
    }

    if (!variable_global_exists("borderless_reapply_frames")) {
        global.borderless_reapply_frames = 0;
    }
}

function scr_settings_apply_audio_gains()
{
    if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 0.8;
    if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;

    if (audio_group_is_loaded(audiogroupsfx)) {
        audio_group_set_gain(
            audiogroupsfx,
            global.vol_master * global.vol_sfx,
            0
        );
    }

    if (audio_group_is_loaded(audiogroupatmosphere)) {
        audio_group_set_gain(
            audiogroupatmosphere,
            global.vol_master * global.vol_music,
            0
        );
    }
}

function scr_settings_apply_window_resolution()
{
    scr_settings_init();

    var sc = global.resolution_scales[global.resolution_index];

    window_set_fullscreen(false);
    window_set_showborder(true);

    window_set_size(
        global.GAME_W * sc,
        global.GAME_H * sc
    );

    window_center();

    global.fullscreen = false;
    global.borderless_reapply_frames = 0;

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

    switch (mode)
    {
        case "windowed":
            scr_settings_apply_window_resolution();
        break;

        case "fullscreen":
            window_set_showborder(true);
            window_set_fullscreen(true);

            global.fullscreen = true;
            global.borderless_reapply_frames = 0;
        break;

        case "borderless":
            var dx = 0;
            var dy = 0;
            var dw = display_get_width();
            var dh = display_get_height();

            window_set_fullscreen(false);

            window_set_showborder(true);
            window_set_position(dx, dy);
            window_set_size(dw, dh);

            window_set_showborder(false);
            window_set_position(dx, dy);
            window_set_size(dw, dh);

            global.fullscreen = false;
            global.borderless_reapply_frames = 3;
        break;
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
            global.vol_master = clamp(global.vol_master + (_change * 0.1), 0, 1);
            scr_settings_apply_audio_gains();
        break;

        case "music_volume":
            global.vol_music = clamp(global.vol_music + (_change * 0.1), 0, 1);
            scr_settings_apply_audio_gains();
        break;

        case "sfx_volume":
            global.vol_sfx = clamp(global.vol_sfx + (_change * 0.1), 0, 1);
            scr_settings_apply_audio_gains();
        break;

        case "brightness":
            global.brightness = clamp(global.brightness + (_change * 0.1), 0.5, 1.5);
        break;

        case "contrast":
            global.contrast = clamp(global.contrast + (_change * 0.1), 0.5, 1.5);
        break;

        case "display_mode":
        {
            var old_index = global.display_mode_index;

            global.display_mode_index = clamp(
                global.display_mode_index + _change,
                0,
                array_length(global.display_mode_labels) - 1
            );

            if (global.display_mode_index != old_index) {
                scr_settings_apply_display_mode();
            }
        }
        break;

        case "resolution":
            if (global.display_mode_labels[global.display_mode_index] == "windowed")
            {
                global.resolution_index = clamp(
                    global.resolution_index + _change,
                    0,
                    array_length(global.resolution_labels) - 1
                );

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
        case "contrast":      return clamp((global.contrast - 0.5) / 1.0, 0, 1);
    }

    return 1;
}

function scr_settings_resolution_enabled()
{
    scr_settings_init();

    return global.display_mode_labels[global.display_mode_index] == "windowed";
}

function scr_settings_label(_item)
{
    switch (_item)
    {
        case "master_volume": return "master volume";
        case "music_volume":  return "atmosphere volume";
        case "sfx_volume":    return "sfx volume";
        case "resolution":    return "window size";
    }

    return string_replace_all(_item, "_", " ");
}