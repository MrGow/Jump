/// scr_save_system

function scr_save_file(_slot)
{
    return "save_slot_" + string(_slot) + ".json";
}

function scr_save_show_popup()
{
    if (!instance_exists(oSavePopup)) {
        instance_create_depth(0, 0, -1000000, oSavePopup);
    }
}

function scr_save_chip_array()
{
    var arr = [];

    if (!variable_global_exists("chips_found")) {
        global.chips_found = ds_map_create();
    }

    var key = ds_map_find_first(global.chips_found);

    while (!is_undefined(key))
    {
        array_push(arr, key);
        key = ds_map_find_next(global.chips_found, key);
    }

    return arr;
}

function scr_save_apply_chip_array(_arr)
{
    if (!variable_global_exists("chips_found")) {
        global.chips_found = ds_map_create();
    } else {
        ds_map_clear(global.chips_found);
    }

    global.chips_collected = 0;

    if (is_array(_arr))
    {
        for (var i = 0; i < array_length(_arr); i++)
        {
            var chip_id = string(_arr[i]);

            if (!ds_map_exists(global.chips_found, chip_id)) {
                ds_map_add(global.chips_found, chip_id, true);
                global.chips_collected++;
            }
        }
    }

    global.chips_carried = 0;

    if (!variable_global_exists("chips_carried_ids")) {
        global.chips_carried_ids = ds_map_create();
    } else {
        ds_map_clear(global.chips_carried_ids);
    }
}

function scr_save_exists(_slot)
{
    return file_exists(scr_save_file(_slot));
}

function scr_save_game(_slot)
{
    if (_slot < 1 || _slot > 3) return false;

    if (!variable_global_exists("checkpoint_set") || !global.checkpoint_set) {
        return false;
    }

    var room_name = room_get_name(global.checkpoint_room);

    var data = {
        version: 1,
        slot: _slot,
        timestamp: current_time,

        room_name: room_name,

        checkpoint_id: global.checkpoint_id,
        checkpoint_x: global.checkpoint_x,
        checkpoint_y: global.checkpoint_y,

        chips_collected: global.chips_collected,
        chips_found: scr_save_chip_array()
    };

    var json = json_stringify(data);
    var file = scr_save_file(_slot);

    var f = file_text_open_write(file);
    file_text_write_string(f, json);
    file_text_close(f);

    scr_save_show_popup();

    return true;
}

function scr_load_game(_slot)
{
    if (_slot < 1 || _slot > 3) return false;

    var file = scr_save_file(_slot);

    if (!file_exists(file)) {
        return false;
    }

    var f = file_text_open_read(file);
    var json = file_text_read_string(f);
    file_text_close(f);

    var data = json_parse(json);

    if (!is_struct(data)) {
        return false;
    }

    var room_asset = -1;

    if (variable_struct_exists(data, "room_name")) {
        room_asset = asset_get_index(data.room_name);
    }

    if (room_asset == -1) {
        return false;
    }

    global.save_slot = _slot;

    global.checkpoint_set  = true;
    global.checkpoint_room = room_asset;
    global.checkpoint_x    = data.checkpoint_x;
    global.checkpoint_y    = data.checkpoint_y;
    global.checkpoint_id   = string(data.checkpoint_id);

    if (variable_struct_exists(data, "chips_found")) {
        scr_save_apply_chip_array(data.chips_found);
    } else {
        scr_save_apply_chip_array([]);
    }

    global.pending_respawn      = true;
    global.pending_respawn_room = room_asset;
    global.pending_respawn_x    = global.checkpoint_x;
    global.pending_respawn_y    = global.checkpoint_y;

    global.inp_jump_press = false;
    global.inp_jump_held  = false;
    global.game_phase     = "playing";

    room_goto(room_asset);

    return true;
}

function scr_save_find_latest_slot()
{
    var best_slot = 0;
    var best_time = -1;

    for (var slot = 1; slot <= 3; slot++)
    {
        var file = scr_save_file(slot);

        if (!file_exists(file)) continue;

        var f = file_text_open_read(file);
        var json = file_text_read_string(f);
        file_text_close(f);

        var data = json_parse(json);

        if (is_struct(data) && variable_struct_exists(data, "timestamp"))
        {
            if (data.timestamp > best_time) {
                best_time = data.timestamp;
                best_slot = slot;
            }
        }
    }

    return best_slot;
}

function scr_save_begin_new(_slot)
{
    global.save_slot = _slot;

    global.checkpoint_set  = false;
    global.checkpoint_room = -1;
    global.checkpoint_x    = 0;
    global.checkpoint_y    = 0;
    global.checkpoint_id   = "";

    global.pending_respawn      = false;
    global.pending_respawn_room = -1;
    global.pending_respawn_x    = 0;
    global.pending_respawn_y    = 0;

    global.chips_collected = 0;
    global.chips_carried   = 0;

    if (!variable_global_exists("chips_found")) {
        global.chips_found = ds_map_create();
    } else {
        ds_map_clear(global.chips_found);
    }

    if (!variable_global_exists("chips_carried_ids")) {
        global.chips_carried_ids = ds_map_create();
    } else {
        ds_map_clear(global.chips_carried_ids);
    }

    // Temporary for now: overwrite this slot immediately.
    // Later this will only happen after the player confirms overwrite.
    var file = scr_save_file(_slot);
    if (file_exists(file)) {
        file_delete(file);
    }
}

function scr_save_get_chip_count(_slot)
{
    if (_slot < 1 || _slot > 3) return 0;

    var file = scr_save_file(_slot);

    if (!file_exists(file)) {
        return 0;
    }

    var f = file_text_open_read(file);
    var json = file_text_read_string(f);
    file_text_close(f);

    var data = json_parse(json);

    if (!is_struct(data)) {
        return 0;
    }

    if (variable_struct_exists(data, "chips_collected")) {
        return data.chips_collected;
    }

    if (variable_struct_exists(data, "chips_found") && is_array(data.chips_found)) {
        return array_length(data.chips_found);
    }

    return 0;
}