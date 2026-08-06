/// oChipCollectable — Animation End

// Pickup animation has completed.
if (chip_anim_state == "pickup")
{
    image_index = pickup_frame_last;
    image_speed = 0;

    chip_anim_state = "carried_hidden";
    visible = false;

    exit;
}


// Idle animation loops through frames 1–6.
if (chip_anim_state == "idle")
{
    image_index = idle_frame_first;
    image_speed = idle_anim_speed;
}