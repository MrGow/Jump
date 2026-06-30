/// oChipCollectable — Step

if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}

// If banked, stay gone forever
if (ds_map_exists(global.chips_found, chip_id)) {
    instance_destroy();
    exit;
}

// If player died and carried chips were cleared, respawn this chip
if (picked_up_carried && !ds_map_exists(global.chips_carried_ids, chip_id)) {
    picked_up_carried = false;
    visible = true;
    enabled = true;
}

// If currently carried, stay hidden
if (ds_map_exists(global.chips_carried_ids, chip_id)) {
    picked_up_carried = true;
    visible = false;
    enabled = false;
}