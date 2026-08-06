/// oChipCollectable — Step

// ----------------------------------------------------
// Global safety
// ----------------------------------------------------
if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}


// ----------------------------------------------------
// Already banked: remove permanently
// ----------------------------------------------------
if (ds_map_exists(global.chips_found, chip_id))
{
    instance_destroy();
    exit;
}


// ----------------------------------------------------
// Was carried, but player died before banking it
// ----------------------------------------------------
var currently_carried =
    ds_map_exists(global.chips_carried_ids, chip_id);

if (picked_up_carried && !currently_carried)
{
    picked_up_carried = false;

    chip_anim_state = "idle";

    visible = true;
    enabled = true;

    image_index = idle_frame_first;
    image_speed = idle_anim_speed;
}


// ----------------------------------------------------
// Carried state
// ----------------------------------------------------
if (currently_carried)
{
    picked_up_carried = true;
    enabled = false;

    // Do not hide it while the pickup animation is playing.
    if (chip_anim_state != "pickup")
    {
        chip_anim_state = "carried_hidden";

        visible = false;
        image_speed = 0;
        image_index = idle_frame_first;
    }
}


// ----------------------------------------------------
// Idle animation loop: frames 1–6
// ----------------------------------------------------
if (chip_anim_state == "idle")
{
    visible = true;
    enabled = true;
    image_speed = idle_anim_speed;

    if (
        image_index < idle_frame_first ||
        image_index >= idle_frame_last + 0.99
    )
    {
        image_index = idle_frame_first;
    }
}


// ----------------------------------------------------
// Pickup animation: frames 7–13
// ----------------------------------------------------
else if (chip_anim_state == "pickup")
{
    visible = true;
    enabled = false;
    image_speed = pickup_anim_speed;

    if (image_index >= pickup_frame_last + 0.99)
    {
        image_index = pickup_frame_last;
        image_speed = 0;

        chip_anim_state = "carried_hidden";
        visible = false;
    }
}


// ----------------------------------------------------
// Distance-based looping sound
// ----------------------------------------------------
var should_have_loop =
    chip_anim_state == "idle" &&
    enabled &&
    visible &&
    snd_chip_loop != -1;

if (should_have_loop)
{
    // Start the loop once
    if (
        chip_loop_voice == -1 ||
        !audio_is_playing(chip_loop_voice)
    )
    {
        chip_loop_voice = audio_play_sound(
            snd_chip_loop,
            0,
            true
        );

        if (chip_loop_voice != -1)
        {
            // Start silently to prevent a one-frame volume pop.
            audio_sound_gain(
                chip_loop_voice,
                0,
                0
            );
        }
    }

    var p = instance_find(oPlayer, 0);

    if (p != noone && chip_loop_voice != -1)
    {
        var dist = point_distance(
            x,
            y,
            p.x,
            p.y
        );

        var distance_gain =
            1
            - clamp(
                (dist - chip_loop_near_distance)
                /
                max(
                    1,
                    chip_loop_far_distance
                    - chip_loop_near_distance
                ),
                0,
                1
            );

        var final_gain =
            chip_loop_gain
            * distance_gain;

        audio_sound_gain(
            chip_loop_voice,
            final_gain,
            80
        );
    }
    else if (chip_loop_voice != -1)
    {
        audio_sound_gain(
            chip_loop_voice,
            0,
            80
        );
    }
}
else
{
    if (chip_loop_voice != -1)
    {
        audio_stop_sound(chip_loop_voice);
        chip_loop_voice = -1;
    }
}