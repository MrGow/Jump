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
    // CONTROL DEFAULTS
    //
    // Arrow keys and the left analogue stick remain
    // permanently active in oInput. These variables are
    // the player's additional remappable controls.
    // ====================================================

    scr_controls_ensure_defaults();


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


/// ----------------------------------------------------
/// Ensure remappable control globals exist
/// ----------------------------------------------------
function scr_controls_ensure_defaults()
{
    if (!variable_global_exists("control_key_jump"))
    {
        global.control_key_jump = vk_space;
    }

    if (!variable_global_exists("control_key_left"))
    {
        global.control_key_left = ord("A");
    }

    if (!variable_global_exists("control_key_right"))
    {
        global.control_key_right = ord("D");
    }

    if (!variable_global_exists("control_pad_jump"))
    {
        global.control_pad_jump = gp_face1;
    }

    if (!variable_global_exists("control_pad_left"))
    {
        global.control_pad_left = gp_padl;
    }

    if (!variable_global_exists("control_pad_right"))
    {
        global.control_pad_right = gp_padr;
    }
}


/// ----------------------------------------------------
/// Restore JumpBot's default gameplay controls
/// ----------------------------------------------------
function scr_controls_restore_defaults()
{
    global.control_key_jump  = vk_space;
    global.control_key_left  = ord("A");
    global.control_key_right = ord("D");

    global.control_pad_jump  = gp_face1;
    global.control_pad_left  = gp_padl;
    global.control_pad_right = gp_padr;

    scr_settings_save();
}


/// ----------------------------------------------------
/// Assign a keyboard binding and swap duplicates
/// ----------------------------------------------------
function scr_controls_set_keyboard(_action, _key)
{
    scr_controls_ensure_defaults();

    var old_key = -1;

    switch (_action)
    {
        case "jump":  old_key = global.control_key_jump;  break;
        case "left":  old_key = global.control_key_left;  break;
        case "right": old_key = global.control_key_right; break;
        default: return false;
    }

    if (_key == old_key)
    {
        return false;
    }

    // Swap instead of allowing two remappable actions to
    // silently occupy the same physical key.
    if (
        _action != "jump" &&
        global.control_key_jump == _key
    )
    {
        global.control_key_jump = old_key;
    }

    if (
        _action != "left" &&
        global.control_key_left == _key
    )
    {
        global.control_key_left = old_key;
    }

    if (
        _action != "right" &&
        global.control_key_right == _key
    )
    {
        global.control_key_right = old_key;
    }

    switch (_action)
    {
        case "jump":  global.control_key_jump  = _key; break;
        case "left":  global.control_key_left  = _key; break;
        case "right": global.control_key_right = _key; break;
    }

    scr_settings_save();
    return true;
}


/// ----------------------------------------------------
/// Assign a controller binding and swap duplicates
/// ----------------------------------------------------
function scr_controls_set_gamepad(_action, _button)
{
    scr_controls_ensure_defaults();

    var old_button = -1;

    switch (_action)
    {
        case "jump":  old_button = global.control_pad_jump;  break;
        case "left":  old_button = global.control_pad_left;  break;
        case "right": old_button = global.control_pad_right; break;
        default: return false;
    }

    if (_button == old_button)
    {
        return false;
    }

    if (
        _action != "jump" &&
        global.control_pad_jump == _button
    )
    {
        global.control_pad_jump = old_button;
    }

    if (
        _action != "left" &&
        global.control_pad_left == _button
    )
    {
        global.control_pad_left = old_button;
    }

    if (
        _action != "right" &&
        global.control_pad_right == _button
    )
    {
        global.control_pad_right = old_button;
    }

    switch (_action)
    {
        case "jump":  global.control_pad_jump  = _button; break;
        case "left":  global.control_pad_left  = _button; break;
        case "right": global.control_pad_right = _button; break;
    }

    scr_settings_save();
    return true;
}


/// ----------------------------------------------------
/// Display name for a keyboard key
/// ----------------------------------------------------
function scr_controls_keyboard_name(_key)
{
    switch (_key)
    {
        case vk_space:     return "Space";
        case vk_enter:     return "Enter";
        case vk_shift:     return "Shift";
        case vk_control:   return "Ctrl";
        case vk_alt:       return "Alt";
        case vk_tab:       return "Tab";
        case vk_backspace: return "Backspace";
        case vk_delete:    return "Delete";
        case vk_home:      return "Home";
        case vk_end:       return "End";
        case vk_pageup:    return "Page Up";
        case vk_pagedown:  return "Page Down";
        case vk_up:        return "Up Arrow";
        case vk_down:      return "Down Arrow";
        case vk_left:      return "Left Arrow";
        case vk_right:     return "Right Arrow";
        case vk_numpad0:   return "Numpad 0";
        case vk_numpad1:   return "Numpad 1";
        case vk_numpad2:   return "Numpad 2";
        case vk_numpad3:   return "Numpad 3";
        case vk_numpad4:   return "Numpad 4";
        case vk_numpad5:   return "Numpad 5";
        case vk_numpad6:   return "Numpad 6";
        case vk_numpad7:   return "Numpad 7";
        case vk_numpad8:   return "Numpad 8";
        case vk_numpad9:   return "Numpad 9";
        case vk_f1:        return "F1";
        case vk_f2:        return "F2";
        case vk_f3:        return "F3";
        case vk_f4:        return "F4";
        case vk_f5:        return "F5";
        case vk_f6:        return "F6";
        case vk_f7:        return "F7";
        case vk_f8:        return "F8";
        case vk_f9:        return "F9";
        case vk_f10:       return "F10";
        case vk_f11:       return "F11";
        case vk_f12:       return "F12";
    }

    if (_key >= 32 && _key <= 126)
    {
        return string_upper(chr(_key));
    }

    return "Key " + string(_key);
}


/// ----------------------------------------------------
/// Display name for a controller button
/// ----------------------------------------------------
function scr_controls_gamepad_name(_button)
{
    switch (_button)
    {
        case gp_face1:      return "A";
        case gp_face2:      return "B";
        case gp_face3:      return "X";
        case gp_face4:      return "Y";
        case gp_shoulderl:  return "LB";
        case gp_shoulderr:  return "RB";
        case gp_shoulderlb: return "LT";
        case gp_shoulderrb: return "RT";
        case gp_padl:       return "D-Pad Left";
        case gp_padr:       return "D-Pad Right";
        case gp_padu:       return "D-Pad Up";
        case gp_padd:       return "D-Pad Down";
        case gp_stickl:     return "L3";
        case gp_stickr:     return "R3";
        case gp_select:     return "View";
    }

    return "Button";
}