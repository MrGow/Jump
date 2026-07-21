/// scr_settings

function scr_settings_init()
{
    // ====================================================
    // INTERNAL RESOLUTION
    // ====================================================

    if (!variable_global_exists("GAME_W"))
    {
        global.GAME_W = 640;
    }

    if (!variable_global_exists("GAME_H"))
    {
        global.GAME_H = 360;
    }


    // ====================================================
    // AUDIO DEFAULTS
    // ====================================================

    if (!variable_global_exists("vol_master"))
    {
        global.vol_master = 0.5;
    }

    if (!variable_global_exists("vol_music"))
    {
        global.vol_music = 0.35;
    }

    if (!variable_global_exists("vol_sfx"))
    {
        global.vol_sfx = 0.65;
    }

    // How quiet gameplay SFX and atmosphere become while
    // the game is paused.
    if (!variable_global_exists("audio_pause_duck"))
    {
        global.audio_pause_duck = 0.15;
    }


    // ====================================================
    // VIDEO DEFAULTS
    // ====================================================

    if (!variable_global_exists("brightness"))
    {
        global.brightness = 1.0;
    }

    if (!variable_global_exists("contrast"))
    {
        global.contrast = 1.0;
    }


    // ====================================================
    // DISPLAY OPTIONS
    // ====================================================

    global.display_mode_labels = [
        "windowed",
        "fullscreen",
        "borderless"
    ];

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

    if (!variable_global_exists("display_mode_index"))
    {
        global.display_mode_index = 0;
    }

    if (!variable_global_exists("resolution_index"))
    {
        global.resolution_index = 1;
    }


    // ====================================================
    // LOAD SAVED SETTINGS ONCE
    // ====================================================

    if (!variable_global_exists("settings_loaded"))
    {
        global.settings_loaded = true;
        scr_settings_load();
    }


    // ====================================================
    // VALUE SAFETY
    // ====================================================

    global.vol_master =
        clamp(
            global.vol_master,
            0,
            1
        );

    global.vol_music =
        clamp(
            global.vol_music,
            0,
            1
        );

    global.vol_sfx =
        clamp(
            global.vol_sfx,
            0,
            1
        );

    global.brightness =
        clamp(
            global.brightness,
            0.5,
            1.5
        );

    global.contrast =
        clamp(
            global.contrast,
            0.5,
            1.5
        );

    global.display_mode_index =
        clamp(
            global.display_mode_index,
            0,
            array_length(global.display_mode_labels) - 1
        );

    global.resolution_index =
        clamp(
            global.resolution_index,
            0,
            array_length(global.resolution_labels) - 1
        );


    // ====================================================
    // DISPLAY STATE
    // ====================================================

    if (!variable_global_exists("fullscreen"))
    {
        global.fullscreen = false;
    }

    if (!variable_global_exists("borderless_reapply_frames"))
    {
        global.borderless_reapply_frames = 0;
    }


    // ====================================================
    // LOAD AUDIO GROUPS
    // ====================================================

    if (!audio_group_is_loaded(audiogroupsfx))
    {
        audio_group_load(audiogroupsfx);
    }

    if (!audio_group_is_loaded(audiogroupatmosphere))
    {
        audio_group_load(audiogroupatmosphere);
    }

    if (!audio_group_is_loaded(audiogroupui))
    {
        audio_group_load(audiogroupui);
    }


    // ====================================================
    // APPLY CURRENT AUDIO SETTINGS
    // ====================================================

    scr_settings_apply_audio_gains();
}


/// ----------------------------------------------------
/// Apply Master, SFX, Atmosphere and UI volume
/// ----------------------------------------------------
function scr_settings_apply_audio_gains()
{
    // Safety in case this function is called before init.
    if (!variable_global_exists("vol_master"))
    {
        global.vol_master = 0.5;
    }

    if (!variable_global_exists("vol_music"))
    {
        global.vol_music = 0.35;
    }

    if (!variable_global_exists("vol_sfx"))
    {
        global.vol_sfx = 0.65;
    }

    if (!variable_global_exists("audio_pause_duck"))
    {
        global.audio_pause_duck = 0.15;
    }


    // ====================================================
    // PHASE MULTIPLIERS
    // ====================================================

    var sfx_mult  = 1.0;
    var atmo_mult = 1.0;
    var ui_mult   = 1.0;

    if (variable_global_exists("game_phase"))
    {
        // ------------------------------------------------
        // Pause menu
        // ------------------------------------------------
        if (global.game_phase == "paused")
        {
            // Quiet gameplay sounds behind the menu.
            sfx_mult =
                global.audio_pause_duck;

            atmo_mult =
                global.audio_pause_duck;

            // UI remains clear.
            ui_mult = 1.0;
        }

        // ------------------------------------------------
        // Main menu
        // ------------------------------------------------
        else if (
            global.game_phase == "main_menu" ||
            global.game_phase == "menu"
        )
        {
            // Gameplay objects may still be running in the
            // background demo, but their SFX should be muted.
            sfx_mult = 0;

            // Atmosphere and menu sounds remain audible.
            atmo_mult = 1.0;
            ui_mult   = 1.0;
        }
    }


    // ====================================================
    // APPLY GROUP GAINS
    // ====================================================

    if (audio_group_is_loaded(audiogroupsfx))
    {
        audio_group_set_gain(
            audiogroupsfx,
            global.vol_master *
            global.vol_sfx *
            sfx_mult,
            0
        );
    }

    if (audio_group_is_loaded(audiogroupatmosphere))
    {
        audio_group_set_gain(
            audiogroupatmosphere,
            global.vol_master *
            global.vol_music *
            atmo_mult,
            0
        );
    }

    if (audio_group_is_loaded(audiogroupui))
    {
        audio_group_set_gain(
            audiogroupui,
            global.vol_master *
            global.vol_sfx *
            ui_mult,
            0
        );
    }
}


/// ----------------------------------------------------
/// Apply selected windowed resolution
/// ----------------------------------------------------
function scr_settings_apply_window_resolution()
{
    scr_settings_init();

    var sc =
        global.resolution_scales[
            global.resolution_index
        ];

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

    display_set_gui_size(
        global.GAME_W,
        global.GAME_H
    );

    if (surface_exists(application_surface))
    {
        surface_resize(
            application_surface,
            global.GAME_W,
            global.GAME_H
        );
    }
}


/// ----------------------------------------------------
/// Apply Windowed, Fullscreen or Borderless
/// ----------------------------------------------------
function scr_settings_apply_display_mode()
{
    scr_settings_init();

    var mode =
        global.display_mode_labels[
            global.display_mode_index
        ];

    switch (mode)
    {
        // ------------------------------------------------
        // Windowed
        // ------------------------------------------------
        case "windowed":
        {
            scr_settings_apply_window_resolution();
        }
        break;


        // ------------------------------------------------
        // Fullscreen
        // ------------------------------------------------
        case "fullscreen":
        {
            window_set_showborder(true);
            window_set_fullscreen(true);

            global.fullscreen = true;
            global.borderless_reapply_frames = 0;
        }
        break;


        // ------------------------------------------------
        // Borderless
        // ------------------------------------------------
        case "borderless":
        {
            var dx = 0;
            var dy = 0;

            var dw =
                display_get_width();

            var dh =
                display_get_height();

            window_set_fullscreen(false);

            // Briefly restore the border first so the window
            // can be positioned and resized reliably.
            window_set_showborder(true);
            window_set_position(dx, dy);
            window_set_size(dw, dh);

            // Then remove the border and reapply size.
            window_set_showborder(false);
            window_set_position(dx, dy);
            window_set_size(dw, dh);

            global.fullscreen = false;
            global.borderless_reapply_frames = 3;
        }
        break;
    }

    gpu_set_texfilter(false);

    display_set_gui_size(
        global.GAME_W,
        global.GAME_H
    );

    if (surface_exists(application_surface))
    {
        surface_resize(
            application_surface,
            global.GAME_W,
            global.GAME_H
        );
    }
}


/// ----------------------------------------------------
/// Adjust one settings-menu item
/// ----------------------------------------------------
function scr_settings_adjust(_item, _change)
{
    scr_settings_init();

    var changed = false;

    switch (_item)
    {
        // ------------------------------------------------
        // Master volume
        // ------------------------------------------------
        case "master_volume":
        {
            var old_master =
                global.vol_master;

            global.vol_master =
                clamp(
                    global.vol_master +
                    (_change * 0.1),
                    0,
                    1
                );

            changed =
                global.vol_master !=
                old_master;

            scr_settings_apply_audio_gains();
        }
        break;


        // ------------------------------------------------
        // Atmosphere / music volume
        // ------------------------------------------------
        case "music_volume":
        {
            var old_music =
                global.vol_music;

            global.vol_music =
                clamp(
                    global.vol_music +
                    (_change * 0.1),
                    0,
                    1
                );

            changed =
                global.vol_music !=
                old_music;

            scr_settings_apply_audio_gains();
        }
        break;


        // ------------------------------------------------
        // Gameplay and UI SFX volume
        // ------------------------------------------------
        case "sfx_volume":
        {
            var old_sfx =
                global.vol_sfx;

            global.vol_sfx =
                clamp(
                    global.vol_sfx +
                    (_change * 0.1),
                    0,
                    1
                );

            changed =
                global.vol_sfx !=
                old_sfx;

            scr_settings_apply_audio_gains();
        }
        break;


        // ------------------------------------------------
        // Brightness
        // ------------------------------------------------
        case "brightness":
        {
            var old_brightness =
                global.brightness;

            global.brightness =
                clamp(
                    global.brightness +
                    (_change * 0.1),
                    0.5,
                    1.5
                );

            changed =
                global.brightness !=
                old_brightness;
        }
        break;


        // ------------------------------------------------
        // Contrast
        // ------------------------------------------------
        case "contrast":
        {
            var old_contrast =
                global.contrast;

            global.contrast =
                clamp(
                    global.contrast +
                    (_change * 0.1),
                    0.5,
                    1.5
                );

            changed =
                global.contrast !=
                old_contrast;
        }
        break;


        // ------------------------------------------------
        // Display mode
        // ------------------------------------------------
        case "display_mode":
        {
            var old_index =
                global.display_mode_index;

            global.display_mode_index =
                clamp(
                    global.display_mode_index +
                    _change,
                    0,
                    array_length(
                        global.display_mode_labels
                    ) - 1
                );

            if (
                global.display_mode_index !=
                old_index
            )
            {
                changed = true;
                scr_settings_apply_display_mode();
            }
        }
        break;


        // ------------------------------------------------
        // Window resolution
        // ------------------------------------------------
        case "resolution":
        {
            if (
                global.display_mode_labels[
                    global.display_mode_index
                ] == "windowed"
            )
            {
                var old_res =
                    global.resolution_index;

                global.resolution_index =
                    clamp(
                        global.resolution_index +
                        _change,
                        0,
                        array_length(
                            global.resolution_labels
                        ) - 1
                    );

                if (
                    global.resolution_index !=
                    old_res
                )
                {
                    changed = true;
                    scr_settings_apply_window_resolution();
                }
            }
        }
        break;
    }


    // ====================================================
    // SAVE ONLY WHEN SOMETHING ACTUALLY CHANGED
    // ====================================================

    if (changed)
    {
        scr_settings_save();
    }
}


/// ----------------------------------------------------
/// Return a setting as a normalized 0–1 value
/// ----------------------------------------------------
function scr_settings_value01(_item)
{
    scr_settings_init();

    switch (_item)
    {
        case "master_volume":
        {
            return global.vol_master;
        }

        case "music_volume":
        {
            return global.vol_music;
        }

        case "sfx_volume":
        {
            return global.vol_sfx;
        }

        case "brightness":
        {
            return clamp(
                (global.brightness - 0.5) / 1.0,
                0,
                1
            );
        }

        case "contrast":
        {
            return clamp(
                (global.contrast - 0.5) / 1.0,
                0,
                1
            );
        }
    }

    return 1;
}


/// ----------------------------------------------------
/// Window size can only change in Windowed mode
/// ----------------------------------------------------
function scr_settings_resolution_enabled()
{
    scr_settings_init();

    return
        global.display_mode_labels[
            global.display_mode_index
        ] == "windowed";
}


/// ----------------------------------------------------
/// Convert internal setting name into UI label
/// ----------------------------------------------------
function scr_settings_label(_item)
{
    switch (_item)
    {
        case "master_volume":
        {
            return "master volume";
        }

        case "music_volume":
        {
            return "atmosphere volume";
        }

        case "sfx_volume":
        {
            return "sfx volume";
        }

        case "resolution":
        {
            return "window size";
        }
    }

    return string_replace_all(
        _item,
        "_",
        " "
    );
}