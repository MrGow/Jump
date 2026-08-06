/// oChipCollectable — Create

// ----------------------------------------------------
// Identity
// ----------------------------------------------------
if (!variable_instance_exists(id, "chip_id"))
{
    chip_id =
        room_get_name(room)
        + "*"
        + string(round(x))
        + "*"
        + string(round(y));
}


// ----------------------------------------------------
// Chip globals
// ----------------------------------------------------
if (!variable_global_exists("chips_collected")) {
    global.chips_collected = 0;
}

if (!variable_global_exists("chips_carried")) {
    global.chips_carried = 0;
}

if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}


// ----------------------------------------------------
// Animation
//
// Editor frames 1–6  = GM frames 0–5
// Editor frames 7–13 = GM frames 6–12
// ----------------------------------------------------
idle_frame_first = 0;
idle_frame_last  = 5;

pickup_frame_first = 6;
pickup_frame_last  = 12;

idle_anim_speed   = 1;
pickup_anim_speed = 1.50;

chip_anim_state = "idle";
// idle, pickup, carried_hidden


// ----------------------------------------------------
// Audio
// ----------------------------------------------------
snd_chip_loop   = asset_get_index("CollectableChipLoop1");
snd_chip_pickup = asset_get_index("CollectableChipPickup");

chip_loop_voice = -1;

chip_loop_gain   = 0.70;
chip_pickup_gain = 1.00;

// Full volume inside this distance
chip_loop_near_distance = 80;

// Completely silent beyond this distance
chip_loop_far_distance = 520;


// ----------------------------------------------------
// State
// ----------------------------------------------------
picked_up_carried = false;
enabled = true;


// Already permanently banked
if (ds_map_exists(global.chips_found, chip_id))
{
    instance_destroy();
    exit;
}


// Currently being carried when this instance initializes
if (ds_map_exists(global.chips_carried_ids, chip_id))
{
    picked_up_carried = true;

    chip_anim_state = "carried_hidden";

    visible = false;
    enabled = false;

    image_speed = 0;
    image_index = idle_frame_first;
}
else
{
    picked_up_carried = false;

    chip_anim_state = "idle";

    visible = true;
    enabled = true;

    image_index = idle_frame_first;
    image_speed = idle_anim_speed;
}