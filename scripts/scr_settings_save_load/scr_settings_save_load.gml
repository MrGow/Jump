/// scr_settings_save_load

function scr_settings_save()
{
    var data = {
        version: 1,

        vol_master: global.vol_master,
        vol_music:  global.vol_music,
        vol_sfx:    global.vol_sfx,

        brightness: global.brightness,
        contrast:   global.contrast,

        display_mode_index: global.display_mode_index,
        resolution_index:   global.resolution_index
    };

    var json = json_stringify(data);
    var file = "settings.json";

    var f = file_text_open_write(file);
    file_text_write_string(f, json);
    file_text_close(f);
}

function scr_settings_load()
{
    var file = "settings.json";

    if (!file_exists(file)) {
        return false;
    }

    var f = file_text_open_read(file);
    var json = file_text_read_string(f);
    file_text_close(f);
	
    var data = json_parse(json);

    if (is_struct(data))
    {
        if (variable_struct_exists(data, "vol_master")) global.vol_master = clamp(data.vol_master, 0, 1);
        if (variable_struct_exists(data, "vol_music"))  global.vol_music  = clamp(data.vol_music,  0, 1);
        if (variable_struct_exists(data, "vol_sfx"))    global.vol_sfx    = clamp(data.vol_sfx,    0, 1);

        if (variable_struct_exists(data, "brightness")) global.brightness = clamp(data.brightness, 0.5, 1.5);
        if (variable_struct_exists(data, "contrast"))   global.contrast   = clamp(data.contrast,   0.5, 1.5);

        if (variable_struct_exists(data, "display_mode_index")) {
            global.display_mode_index = clamp(data.display_mode_index, 0, 2);
        }

        if (variable_struct_exists(data, "resolution_index")) {
            global.resolution_index = clamp(data.resolution_index, 0, 2);
        }

        return true;
    }

    return false;
}