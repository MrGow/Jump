/// oChipCollectable — Step

if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}

// ----------------------------------------------------
// If banked, stay gone forever
// ----------------------------------------------------
if (ds_map_exists(global.chips_found, chip_id))
{
    instance_destroy();
    exit;
}

// ----------------------------------------------------
// Respawn after death if it was carried but not banked
// ----------------------------------------------------
if (
    picked_up_carried &&
    !ds_map_exists(global.chips_carried_ids, chip_id)
)
{
    picked_up_carried = false;
    visible = true;
    enabled = true;
}

// ----------------------------------------------------
// Stay hidden while currently carried
// ----------------------------------------------------
if (ds_map_exists(global.chips_carried_ids, chip_id))
{
    picked_up_carried = true;
    visible = false;
    enabled = false;
}

// ----------------------------------------------------
// Distance-based looping audio
// ----------------------------------------------------
var should_have_loop =
    enabled &&
    visible &&
    snd_chip_loop != -1;

if (should_have_loop)
{
    // Start the loop once
    if (chip_loop_voice == -1 || !audio_is_playing(chip_loop_voice))
    {
        chip_loop_voice = audio_play_sound(
            snd_chip_loop,
            0,
            true
        );

        if (chip_loop_voice != -1)
        {
            // Start silently to avoid a one-frame loud pop
            audio_sound_gain(chip_loop_voice, 0, 0);
        }
    }

    var p = instance_find(oPlayer, 0);

    if (p != noone && chip_loop_voice != -1)
    {
        var dist = point_distance(x, y, p.x, p.y);

        // 1 near the chip, 0 at or beyond the far distance
        var distance_gain = 1 - clamp(
            (dist - chip_loop_near_distance) /
            max(1, chip_loop_far_distance - chip_loop_near_distance),
            0,
            1
        );

        var final_gain = chip_loop_gain * distance_gain;

        audio_sound_gain(
            chip_loop_voice,
            final_gain,
            80
        );
    }
    else if (chip_loop_voice != -1)
    {
        audio_sound_gain(chip_loop_voice, 0, 80);
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