/// oChipCollectable — Collision with oPlayer

if (!enabled) exit;
if (chip_anim_state != "idle") exit;


// ----------------------------------------------------
// Global safety
// ----------------------------------------------------
if (!variable_global_exists("chips_carried")) {
    global.chips_carried = 0;
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}

if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}


// Already permanently banked
if (ds_map_exists(global.chips_found, chip_id))
{
    instance_destroy();
    exit;
}


// ----------------------------------------------------
// Pick up chip
// ----------------------------------------------------
if (!ds_map_exists(global.chips_carried_ids, chip_id))
{
    ds_map_add(
        global.chips_carried_ids,
        chip_id,
        true
    );

    global.chips_carried += 1;

    picked_up_carried = true;
    enabled = false;

    // Keep visible while playing the destruction animation.
    visible = true;

    chip_anim_state = "pickup";
    image_index = pickup_frame_first;
    image_speed = pickup_anim_speed;


    // ----------------------------------------------------
    // Stop looping sound immediately
    // ----------------------------------------------------
    if (chip_loop_voice != -1)
    {
        audio_stop_sound(chip_loop_voice);
        chip_loop_voice = -1;
    }


    // ----------------------------------------------------
    // Pickup sound
    // ----------------------------------------------------
    if (snd_chip_pickup != -1)
    {
        scr_play_sfx(
            snd_chip_pickup,
            chip_pickup_gain,
            random_range(0.98, 1.02)
        );
    }


    // ----------------------------------------------------
    // Carry counter
    // ----------------------------------------------------
    if (instance_exists(oChipCounterPopup))
    {
        with (oChipCounterPopup)
        {
            timer = timer_max;
            alpha = 1;
        }
    }
    else
    {
        instance_create_depth(
            0,
            0,
            -1000000,
            oChipCounterPopup
        );
    }
}