/// oChipCollectable — Create

if (!variable_instance_exists(id, "chip_id")) {
    chip_id = room_get_name(room) + "_" + string(round(x)) + "_" + string(round(y));
}

if (!variable_global_exists("chips_collected")) global.chips_collected = 0;
if (!variable_global_exists("chips_carried"))   global.chips_carried   = 0;

if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}

picked_up_carried = false;
enabled = true;

// Already banked forever
if (ds_map_exists(global.chips_found, chip_id)) {
    instance_destroy();
    exit;
}

// Currently carried
if (ds_map_exists(global.chips_carried_ids, chip_id)) {
    picked_up_carried = true;
    visible = false;
    enabled = false;
} else {
    visible = true;
    enabled = true;
}

image_speed = 0.2;