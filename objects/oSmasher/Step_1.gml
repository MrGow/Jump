/// oSmasher — Begin Step

if (scr_game_frozen())
{
    image_speed = 0;

    x = base_x;
    y = base_y;

    exit;
}

if (!enabled)
{
    exit;
}


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_smasher_down"))
{
    snd_smasher_down =
        asset_get_index("SmasherDown1");
}

if (!variable_instance_exists(id, "snd_smasher_lift"))
{
    snd_smasher_lift =
        asset_get_index("SmasherLift1");
}

if (!variable_instance_exists(id, "snd_smasher_floor_hit"))
{
    snd_smasher_floor_hit =
        asset_get_index("SmasherFloorHit1");
}

if (!variable_instance_exists(id, "smasher_down_gain"))
{
    smasher_down_gain = 0.55;
}

if (!variable_instance_exists(id, "smasher_lift_gain"))
{
    smasher_lift_gain = 0.35;
}

if (!variable_instance_exists(id, "smasher_floor_hit_gain"))
{
    smasher_floor_hit_gain = 0.80;
}

if (!variable_instance_exists(id, "smasher_sfx_inner_dist"))
{
    smasher_sfx_inner_dist = 250;
}

if (!variable_instance_exists(id, "smasher_sfx_outer_dist"))
{
    smasher_sfx_outer_dist = 400;
}

if (!variable_instance_exists(id, "smasher_impact_frame"))
{
    smasher_impact_frame = 6;
}

if (!variable_instance_exists(id, "smasher_lift_frame"))
{
    smasher_lift_frame = 12;
}

if (!variable_instance_exists(id, "smasher_cycle_started"))
{
    smasher_cycle_started = false;
}

if (!variable_instance_exists(id, "smasher_floor_sfx_played"))
{
    smasher_floor_sfx_played = false;
}

if (!variable_instance_exists(id, "smasher_lift_sfx_played"))
{
    smasher_lift_sfx_played = false;
}

if (!variable_instance_exists(id, "smasher_player_hit_sfx_lock"))
{
    smasher_player_hit_sfx_lock = false;
}

if (!variable_instance_exists(id, "crush_min_extension"))
{
    crush_min_extension = 3;
}

if (!variable_instance_exists(id, "crush_move_threshold"))
{
    crush_move_threshold = 0.01;
}

if (!variable_instance_exists(id, "plate_direction"))
{
    plate_direction = 0;
}

if (!variable_instance_exists(id, "smasher_death_type"))
{
    smasher_death_type = "crush";
}

if (!variable_instance_exists(id, "smasher_death_shake_strength"))
{
    smasher_death_shake_strength = -1;
}

if (!variable_instance_exists(id, "smasher_death_shake_frames"))
{
    smasher_death_shake_frames = -1;
}


// ====================================================
// DISTANCE-BASED SMASHER SFX HELPER
// ====================================================

function __smasher_play_dist_sfx(_snd, _gain)
{
    if (_snd == -1)
    {
        return;
    }

    var player =
        instance_find(
            oPlayer,
            0
        );

    if (player == noone)
    {
        return;
    }

    var sound_x =
        (
            bbox_left +
            bbox_right
        )
        *
        0.5;

    var sound_y =
        plate_y_current;

    var player_x =
        player.x;

    var player_y =
        (
            player.bbox_top +
            player.bbox_bottom
        )
        *
        0.5;

    var distance =
        point_distance(
            sound_x,
            sound_y,
            player_x,
            player_y
        );

    if (distance >= smasher_sfx_outer_dist)
    {
        return;
    }

    var distance_gain = 1;

    if (distance > smasher_sfx_inner_dist)
    {
        var amount =
            (
                distance -
                smasher_sfx_inner_dist
            )
            /
            max(
                1,
                smasher_sfx_outer_dist -
                smasher_sfx_inner_dist
            );

        distance_gain =
            1 -
            clamp(
                amount,
                0,
                1
            );
    }

    scr_play_sfx(
        _snd,
        _gain * distance_gain,
        random_range(0.97, 1.03)
    );
}


// ====================================================
// KEEP OBJECT FIXED IN ROOM
// ====================================================

x = base_x;
y = base_y;

image_speed = 0;

// Store the last measured plate position.
plate_y_previous =
    plate_y_current;


// ====================================================
// RAISED PAUSE
// ====================================================

if (smasher_pause_timer > 0)
{
    smasher_pause_timer--;

    image_index = 0;
    mask_index = mask_body;

    plate_y_previous =
        plate_retracted_y;

    plate_y_current =
        plate_retracted_y;

    plate_move_y = 0;
    plate_extension = 0;
    plate_direction = 0;

    active = false;

    smasher_cycle_started = false;
    smasher_floor_sfx_played = false;
    smasher_lift_sfx_played = false;
    smasher_player_hit_sfx_lock = false;

    exit;
}


// ====================================================
// START MOVEMENT CYCLE
// ====================================================

if (!smasher_cycle_started)
{
    __smasher_play_dist_sfx(
        snd_smasher_down,
        smasher_down_gain
    );

    smasher_cycle_started = true;
    smasher_floor_sfx_played = false;
    smasher_lift_sfx_played = false;
    smasher_player_hit_sfx_lock = false;

    plate_direction = 1;
}


var previous_anim_index =
    image_index;

image_index +=
    smasher_anim_speed;

if (image_index > image_number - 1)
{
    image_index =
        image_number - 1;
}


// Use the frame-accurate animated collision mask.
mask_index =
    mask_full;


// ====================================================
// MEASURE ACTUAL PLATE POSITION
// ====================================================

plate_y_current =
    find_plate_bottom();

plate_move_y =
    plate_y_current -
    plate_y_previous;

plate_extension =
    plate_y_current -
    plate_retracted_y;


// Keep the most recently observed non-zero direction.
// Repeated animation frames can produce zero movement.
if (plate_move_y > crush_move_threshold)
{
    plate_direction = 1;
}
else if (plate_move_y < -crush_move_threshold)
{
    plate_direction = -1;
}


// Dangerous only when physically extended.
active =
    plate_extension >=
    crush_min_extension;


// ====================================================
// SOUND TIMING
// ====================================================

if (
    !smasher_floor_sfx_played &&
    previous_anim_index < smasher_impact_frame &&
    image_index >= smasher_impact_frame
)
{
    __smasher_play_dist_sfx(
        snd_smasher_floor_hit,
        smasher_floor_hit_gain
    );

    smasher_floor_sfx_played = true;
}


if (
    !smasher_lift_sfx_played &&
    previous_anim_index < smasher_lift_frame &&
    image_index >= smasher_lift_frame
)
{
    __smasher_play_dist_sfx(
        snd_smasher_lift,
        smasher_lift_gain
    );

    smasher_lift_sfx_played = true;
}


// ====================================================
// END ANIMATION CYCLE
// ====================================================

if (image_index >= image_number - 1)
{
    image_index = 0;
    mask_index = mask_body;

    plate_y_previous =
        plate_retracted_y;

    plate_y_current =
        plate_retracted_y;

    plate_move_y = 0;
    plate_extension = 0;
    plate_direction = 0;

    active = false;

    smasher_cycle_started = false;
    smasher_floor_sfx_played = false;
    smasher_lift_sfx_played = false;
    smasher_player_hit_sfx_lock = false;

    if (smasher_pause_frames > 0)
    {
        smasher_pause_timer =
            smasher_pause_frames;
    }
}