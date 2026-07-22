/// oArea2ChasingSawsHorizontal — End Step

// ----------------------------------------------------
// Freeze animation and audio during:
// - pause
// - death sequence
// - death menu
// - other frozen game states
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;

    visual_shake_x     = 0;
    visual_shake_y     = 0;
    visual_shake_angle = 0;

    if (
        saw_loop_id != noone &&
        !saw_audio_paused
    )
    {
        audio_pause_sound(saw_loop_id);
        saw_audio_paused = true;
    }

    exit;
}


// ----------------------------------------------------
// Start the loop once audiogroupsfx has finished loading
// ----------------------------------------------------
if (
    saw_loop_id == noone &&
    saw_loop_asset != -1 &&
    audio_group_is_loaded(audiogroupsfx)
)
{
    saw_loop_id =
        audio_play_sound(
            saw_loop_asset,
            0,
            true
        );

    if (saw_loop_id != noone)
    {
        audio_sound_gain(
            saw_loop_id,
            saw_current_gain,
            0
        );

        audio_sound_pitch(
            saw_loop_id,
            saw_current_pitch
        );

        saw_audio_paused = false;
    }
}


// ----------------------------------------------------
// Resume audio after a frozen state
// ----------------------------------------------------
if (
    saw_loop_id != noone &&
    saw_audio_paused
)
{
    audio_resume_sound(saw_loop_id);
    saw_audio_paused = false;
}


// ----------------------------------------------------
// Resume sprite animation
// ----------------------------------------------------
if (image_speed == 0)
{
    image_speed = 1;
}


// ----------------------------------------------------
// Find vertical chase controller
// ----------------------------------------------------
var ctrl =
    instance_find(
        oVerticalChaseController,
        0
    );


// ----------------------------------------------------
// Find player for distance-based audio
// ----------------------------------------------------
var audio_player =
    instance_find(
        oPlayer,
        0
    );


// ----------------------------------------------------
// Distance-audio settings
//
// At or beyond far_distance, the saw uses its quiet
// minimum gain.
//
// At or below near_distance, the saw reaches its full
// chase or burst gain.
// ----------------------------------------------------
var near_distance = 64;
var far_distance  = 520;

var distance_amount = 0;


// ----------------------------------------------------
// Vertical distance from saw to player
// ----------------------------------------------------
if (audio_player != noone)
{
    var saw_distance =
        abs(
            audio_player.y - y
        );

    distance_amount =
        1 -
        clamp(
            (saw_distance - near_distance) /
            (far_distance - near_distance),
            0,
            1
        );


    // Make the volume rise more aggressively during the
    // final part of the approach.
    distance_amount *= distance_amount;
}


// ----------------------------------------------------
// Choose audio state
// ----------------------------------------------------
if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    // The saw remains audible at long range, but reaches
    // its full state gain as it approaches the player.
    var maximum_gain =
        burst_active
        ? saw_burst_gain
        : saw_chase_gain;

    saw_target_gain =
        lerp(
            saw_idle_gain,
            maximum_gain,
            distance_amount
        );

    saw_target_pitch =
        burst_active
        ? saw_burst_pitch
        : saw_chase_pitch;
}
else
{
    saw_target_gain  = saw_idle_gain;
    saw_target_pitch = saw_idle_pitch;
}


// ----------------------------------------------------
// Smoothly change gain and pitch
// ----------------------------------------------------
saw_current_gain =
    lerp(
        saw_current_gain,
        saw_target_gain,
        saw_gain_lerp
    );

saw_current_pitch =
    lerp(
        saw_current_pitch,
        saw_target_pitch,
        saw_pitch_lerp
    );


// ----------------------------------------------------
// Apply current audio values
// ----------------------------------------------------
if (saw_loop_id != noone)
{
    audio_sound_gain(
        saw_loop_id,
        saw_current_gain,
        80
    );

    audio_sound_pitch(
        saw_loop_id,
        saw_current_pitch
    );
}


// ----------------------------------------------------
// Detect the beginning of a burst
// ----------------------------------------------------
var burst_started =
    burst_active &&
    !burst_was_active;


// ----------------------------------------------------
// Strong camera jolt at burst start
// ----------------------------------------------------
if (burst_started)
{
    if (!variable_global_exists("shake_mag"))
    {
        global.shake_mag = 0;
    }

    if (!variable_global_exists("shake_time"))
    {
        global.shake_time = 0;
    }

    global.shake_mag =
        max(
            global.shake_mag,
            burst_start_shake_strength
        );

    global.shake_time =
        max(
            global.shake_time,
            burst_start_shake_frames
        );
}


// ----------------------------------------------------
// Continuous subtle rumble during the burst
// ----------------------------------------------------
if (burst_active)
{
    if (!variable_global_exists("shake_mag"))
    {
        global.shake_mag = 0;
    }

    if (!variable_global_exists("shake_time"))
    {
        global.shake_time = 0;
    }

    global.shake_mag =
        max(
            global.shake_mag,
            burst_rumble_strength
        );

    global.shake_time =
        max(
            global.shake_time,
            burst_rumble_frames
        );
}


// ----------------------------------------------------
// Burst-only sprite vibration
// ----------------------------------------------------
if (burst_active)
{
    visual_shake_x =
        irandom_range(
            -burst_visual_shake_pixels,
            burst_visual_shake_pixels
        );

    visual_shake_y =
        irandom_range(
            -burst_visual_shake_pixels,
            burst_visual_shake_pixels
        );

    visual_shake_angle =
        random_range(
            -burst_visual_angle,
            burst_visual_angle
        );
}
else
{
    visual_shake_x     = 0;
    visual_shake_y     = 0;
    visual_shake_angle = 0;
}


// ----------------------------------------------------
// Chase movement
// ----------------------------------------------------
if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    // ------------------------------------------------
    // Temporary movement downward into the screen
    // ------------------------------------------------
    if (burst_active)
    {
        burst_offset += burst_speed;

        if (burst_offset >= burst_target)
        {
            burst_offset = burst_target;
            burst_active = false;
            burst_speed  = 0;
        }
    }


    // ------------------------------------------------
    // Follow the top side of the camera
    // ------------------------------------------------
    x =
        ctrl.cam_x +
        screen_offset_x;

    y =
        ctrl.cam_y +
        screen_offset_y +
        burst_offset;
}


// ----------------------------------------------------
// Store burst state for next frame
// ----------------------------------------------------
burst_was_active = burst_active;


// ----------------------------------------------------
// Kill player on contact
//
// Collision remains active while the saw is resting,
// provided the game is not frozen.
// ----------------------------------------------------
var p =
    instance_place(
        x,
        y,
        oPlayer
    );

if (p != noone)
{
    if (
        variable_instance_exists(p, "state") &&
        p.state != "dead"
    )
    {
        with (p)
        {
            scr_player_died();
        }
    }
}