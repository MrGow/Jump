/// scr_settings_save_load

function scr_settings_save()
{
    scr_controls_ensure_defaults();

    var data = {
        version: 2,

        vol_master:
            global.vol_master,

        vol_music:
            global.vol_music,

        vol_sfx:
            global.vol_sfx,

        brightness:
            global.brightness,

        contrast:
            global.contrast,

        display_mode_index:
            global.display_mode_index,

        resolution_index:
            global.resolution_index,

        control_key_jump:
            global.control_key_jump,

        control_key_left:
            global.control_key_left,

        control_key_right:
            global.control_key_right,

        control_pad_jump:
            global.control_pad_jump,

        control_pad_left:
            global.control_pad_left,

        control_pad_right:
            global.control_pad_right
    };

    var json =
        json_stringify(data);

    var file =
        "settings.json";

    var f =
        file_text_open_write(file);

    file_text_write_string(
        f,
        json
    );

    file_text_close(f);


    // Display or restart the saving indicator whenever
    // settings or controls are written to disk.
    scr_save_show_popup();
}


function scr_settings_load()
{
    var file =
        "settings.json";

    if (!file_exists(file))
    {
        return false;
    }

    var f =
        file_text_open_read(file);

    var json =
        file_text_read_string(f);

    file_text_close(f);

    var data =
        json_parse(json);

    if (!is_struct(data))
    {
        return false;
    }


    // ====================================================
    // AUDIO
    // ====================================================

    if (
        variable_struct_exists(
            data,
            "vol_master"
        )
    )
    {
        global.vol_master =
            clamp(
                data.vol_master,
                0,
                1
            );
    }

    if (
        variable_struct_exists(
            data,
            "vol_music"
        )
    )
    {
        global.vol_music =
            clamp(
                data.vol_music,
                0,
                1
            );
    }

    if (
        variable_struct_exists(
            data,
            "vol_sfx"
        )
    )
    {
        global.vol_sfx =
            clamp(
                data.vol_sfx,
                0,
                1
            );
    }


    // ====================================================
    // VISUAL SETTINGS
    // ====================================================

    if (
        variable_struct_exists(
            data,
            "brightness"
        )
    )
    {
        global.brightness =
            clamp(
                data.brightness,
                0.5,
                1.5
            );
    }

    if (
        variable_struct_exists(
            data,
            "contrast"
        )
    )
    {
        global.contrast =
            clamp(
                data.contrast,
                0.5,
                1.5
            );
    }


    // ====================================================
    // DISPLAY SETTINGS
    // ====================================================

    if (
        variable_struct_exists(
            data,
            "display_mode_index"
        )
    )
    {
        global.display_mode_index =
            clamp(
                data.display_mode_index,
                0,
                2
            );
    }

    if (
        variable_struct_exists(
            data,
            "resolution_index"
        )
    )
    {
        global.resolution_index =
            clamp(
                data.resolution_index,
                0,
                2
            );
    }


    // ====================================================
    // KEYBOARD CONTROLS
    //
    // Older settings files may not contain these fields.
    // In that case, the defaults created by
    // scr_controls_ensure_defaults() remain active.
    // ====================================================

    if (
        variable_struct_exists(
            data,
            "control_key_jump"
        )
    )
    {
        global.control_key_jump =
            data.control_key_jump;
    }

    if (
        variable_struct_exists(
            data,
            "control_key_left"
        )
    )
    {
        global.control_key_left =
            data.control_key_left;
    }

    if (
        variable_struct_exists(
            data,
            "control_key_right"
        )
    )
    {
        global.control_key_right =
            data.control_key_right;
    }


    // ====================================================
    // CONTROLLER CONTROLS
    // ====================================================

    if (
        variable_struct_exists(
            data,
            "control_pad_jump"
        )
    )
    {
        global.control_pad_jump =
            data.control_pad_jump;
    }

    if (
        variable_struct_exists(
            data,
            "control_pad_left"
        )
    )
    {
        global.control_pad_left =
            data.control_pad_left;
    }

    if (
        variable_struct_exists(
            data,
            "control_pad_right"
        )
    )
    {
        global.control_pad_right =
            data.control_pad_right;
    }

    return true;
}