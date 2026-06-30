/// oChipCollectable — Collision with oPlayer

if (!enabled) exit;

if (!variable_global_exists("chips_carried")) global.chips_carried = 0;

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}

if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

if (ds_map_exists(global.chips_found, chip_id)) {
    instance_destroy();
    exit;
}

if (!ds_map_exists(global.chips_carried_ids, chip_id)) {
    ds_map_add(global.chips_carried_ids, chip_id, true);
    global.chips_carried += 1;

    picked_up_carried = true;
    visible = false;
    enabled = false;

    if (instance_exists(oChipCounterPopup)) {
        with (oChipCounterPopup) timer = timer_max;
    } else {
        instance_create_depth(0, 0, -1000000, oChipCounterPopup);
    }
}