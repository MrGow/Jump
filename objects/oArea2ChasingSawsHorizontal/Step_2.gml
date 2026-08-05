/// oArea2ChasingSawsHorizontal — End Step


// ====================================================
// FREEZE ANIMATION AND AUDIO
// ====================================================

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
        audio_pause_sound(
            saw_loop_id
        );

        saw_audio_paused = true;
    }

    exit;
}


// ====================================================
// START LOOP AFTER AUDIO GROUP LOADS
// ====================================================

if (
    saw_loop_id == noone &&
    saw_loop_asset != -1 &&
    audio_group_is_loaded(
        audiogroupsfx
    )
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


// ====================================================
// RESUME AUDIO AFTER FREEZE
// ====================================================

if (
    saw_loop_id != noone &&
    saw_audio_paused
)
{
    audio_resume_sound(
        saw_loop_id
    );

    saw_audio_paused = false;
}


// ====================================================
// RESUME SPRITE ANIMATION
// ====================================================

if (image_speed == 0)
{
    image_speed = 1;
}


// ====================================================
// FIND VERTICAL CHASE CONTROLLER
// ====================================================

var ctrl =
    instance_find(
        oVerticalChaseController,
        0
    );


// ====================================================
// CALCULATE CAMERA-RELATIVE EDITOR POSITION
//
// This preserves any manual repositioning done in the
// room editor.
//
// Example:
// If you moved this saw assembly 10 pixels right and
// 6 pixels downward, those offsets remain when the
// chase activates.
// ====================================================

if (
    !screen_offsets_initialized &&
    ctrl != noone
)
{
    screen_offset_x =
        start_x -
        ctrl.start_cam_x;

    screen_offset_y =
        start_y -
        ctrl.start_cam_y;

    screen_offsets_initialized = true;
}


// ====================================================
// CHOOSE AUDIO STATE
// ====================================================

if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    if (burst_active)
    {
        saw_target_gain  = saw_burst_gain;
        saw_target_pitch = saw_burst_pitch;
    }
    else
    {
        saw_target_gain  = saw_chase_gain;
        saw_target_pitch = saw_chase_pitch;
    }
}
else
{
    saw_target_gain  = saw_idle_gain;
    saw_target_pitch = saw_idle_pitch;
}


// ====================================================
// SMOOTH AUDIO CHANGES
// ====================================================

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


// ====================================================
// APPLY AUDIO
// ====================================================

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


// ====================================================
// DETECT START OF BURST
// ====================================================

var burst_started =
    burst_active &&
    !burst_was_active;


// ====================================================
// STRONG CAMERA JOLT AT BURST START
// ====================================================

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


// ====================================================
// CONTINUOUS BURST RUMBLE
// ====================================================

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


// ====================================================
// BURST-ONLY VISUAL VIBRATION
// ====================================================

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


// ====================================================
// CHASE MOVEMENT
// ====================================================

if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    // ------------------------------------------------
    // Temporary burst movement downward
    // ------------------------------------------------

    if (burst_active)
    {
        burst_offset +=
            burst_speed;


        if (
            burst_offset >=
            burst_target
        )
        {
            burst_offset =
                burst_target;

            burst_active = false;
            burst_speed  = 0;
        }
    }


    // ------------------------------------------------
    // Follow top edge of camera while preserving the
    // original room-editor offset.
    // ------------------------------------------------

    x =
        ctrl.cam_x +
        screen_offset_x;

    y =
        ctrl.cam_y +
        screen_offset_y +
        burst_offset;
}

// ====================================================
// DISTANCE-BASED CONTROLLER RUMBLE
//
// This saw approaches from above, so distance is
// measured between its bottom edge and the player's
// top edge.
// ====================================================

if (chase_rumble_timer > 0)
{
    chase_rumble_timer--;
}

var rumble_player =
    instance_find(
        oPlayer,
        0
    );

var chase_is_running =
    enabled &&
    ctrl != noone &&
    ctrl.chase_active;

var rumble_player_alive =
    rumble_player != noone &&
    (
        !variable_instance_exists(
            rumble_player,
            "state"
        ) ||
        rumble_player.state != "dead"
    );

if (
    chase_is_running &&
    rumble_player_alive
)
{
    // The saw is above and moves downward toward the player.
    var saw_gap =
        max(
            0,
            rumble_player.bbox_top -
            bbox_bottom
        );

    if (
        saw_gap <= chase_rumble_max_distance &&
        chase_rumble_timer <= 0
    )
    {
        var pulse_low      = 0;
        var pulse_high     = 0;
        var pulse_frames   = 3;
        var pulse_interval = 30;

        if (saw_gap > 350)
        {
            pulse_low      = 0.045;
            pulse_high     = 0.010;
            pulse_frames   = 3;
            pulse_interval = 30;
        }
        else if (saw_gap > 220)
        {
            pulse_low      = 0.075;
            pulse_high     = 0.015;
            pulse_frames   = 3;
            pulse_interval = 21;
        }
        else if (saw_gap > 120)
        {
            pulse_low      = 0.115;
            pulse_high     = 0.025;
            pulse_frames   = 4;
            pulse_interval = 13;
        }
        else
        {
            pulse_low      = 0.175;
            pulse_high     = 0.040;
            pulse_frames   = 4;
            pulse_interval = 8;
        }

        if (burst_active)
        {
            pulse_low =
                min(
                    0.23,
                    pulse_low + 0.045
                );

            pulse_high =
                min(
                    0.07,
                    pulse_high + 0.015
                );

            pulse_interval =
                max(
                    6,
                    pulse_interval - 3
                );
        }

        scr_rumble_play(
            pulse_low,
            pulse_high,
            pulse_frames,
            false
        );

        chase_rumble_timer =
            pulse_interval;
    }
}
else
{
    chase_rumble_timer = 0;
}


// ====================================================
// BURST-START CONTROLLER JOLT
// ====================================================

if (burst_started)
{
    scr_rumble_play(
        chase_burst_rumble_low,
        chase_burst_rumble_high,
        chase_burst_rumble_frames,
        false
    );
}

// ====================================================
// STORE BURST STATE
// ====================================================

burst_was_active =
    burst_active;


// ====================================================
// KILL PLAYER ON CONTACT
// ====================================================

var p =
    instance_place(
        x,
        y,
        oPlayer
    );


if (p != noone)
{
    if (
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state != "dead"
    )
    {
        with (p)
        {
            scr_player_died();
        }
    }
}