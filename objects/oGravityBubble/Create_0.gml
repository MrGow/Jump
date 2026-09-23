/// oGravityBubble — Create


// ====================================================
// GENERAL
// ====================================================

// Player is depth -1000.
// Lower depth draws in front in GameMaker.
depth = -1100;

visible = true;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "spinner_speed"))
{
    spinner_speed = 2.5;
}

if (!variable_instance_exists(id, "spinner_start_angle"))
{
    spinner_start_angle = 270;
}

if (!variable_instance_exists(id, "spinner_direction"))
{
    spinner_direction = 1;
}

if (!variable_instance_exists(id, "launch_speed"))
{
    launch_speed = 10.0;
}

if (!variable_instance_exists(id, "capture_pull_speed"))
{
    capture_pull_speed = 5.0;
}

if (!variable_instance_exists(id, "capture_radius"))
{
    capture_radius = 24;
}

if (!variable_instance_exists(id, "captured_player_scale"))
{
    captured_player_scale = 0.75;
}

if (!variable_instance_exists(id, "capture_scale_lerp"))
{
    capture_scale_lerp = 0.12;
}

if (!variable_instance_exists(id, "captured_pressure_amount"))
{
    captured_pressure_amount = 0.012;
}

if (!variable_instance_exists(id, "captured_pressure_speed"))
{
    captured_pressure_speed = 0.16;
}

if (!variable_instance_exists(id, "respawn_time_s"))
{
    respawn_time_s = 2.5;
}

if (!variable_instance_exists(id, "idle_bob_amount"))
{
    idle_bob_amount = 1.5;
}

if (!variable_instance_exists(id, "idle_bob_speed"))
{
    idle_bob_speed = 0.035;
}

if (!variable_instance_exists(id, "idle_pulse_amount"))
{
    idle_pulse_amount = 0.025;
}

if (!variable_instance_exists(id, "idle_pulse_speed"))
{
    idle_pulse_speed = 0.045;
}

if (!variable_instance_exists(id, "active_pulse_amount"))
{
    active_pulse_amount = 0.01;
}

if (!variable_instance_exists(id, "active_pulse_speed"))
{
    active_pulse_speed = 0.06;
}

if (!variable_instance_exists(id, "respawn_grow_time_s"))
{
    respawn_grow_time_s = 0.30;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// NORMALIZE SETTINGS
// ====================================================

spinner_direction =
    (spinner_direction < 0)
    ? -1
    : 1;

spinner_speed =
    abs(spinner_speed);

launch_speed =
    max(
        0,
        launch_speed
    );

capture_pull_speed =
    max(
        0.1,
        capture_pull_speed
    );

capture_radius =
    max(
        1,
        capture_radius
    );

captured_player_scale =
    clamp(
        captured_player_scale,
        0.1,
        1.0
    );

capture_scale_lerp =
    clamp(
        capture_scale_lerp,
        0.01,
        1.0
    );

captured_pressure_amount =
    clamp(
        captured_pressure_amount,
        0,
        0.10
    );

captured_pressure_speed =
    max(
        0,
        captured_pressure_speed
    );

respawn_time_s =
    max(
        0,
        respawn_time_s
    );

idle_bob_amount =
    max(
        0,
        idle_bob_amount
    );

idle_bob_speed =
    max(
        0,
        idle_bob_speed
    );

idle_pulse_amount =
    max(
        0,
        idle_pulse_amount
    );

idle_pulse_speed =
    max(
        0,
        idle_pulse_speed
    );

active_pulse_amount =
    max(
        0,
        active_pulse_amount
    );

active_pulse_speed =
    max(
        0,
        active_pulse_speed
    );

respawn_grow_time_s =
    max(
        0.01,
        respawn_grow_time_s
    );


// ====================================================
// STATE
//
// 0 = idle
// 1 = pulling / compressing
// 2 = active / aiming
// 3 = use animation
// 4 = cooldown
// 5 = respawning
// ====================================================

bubble_state = 0;


// ====================================================
// PLAYER
// ====================================================

captured_player = noone;


// ====================================================
// SPINNER
// ====================================================

spinner_angle =
    spinner_start_angle;


// ====================================================
// INPUT GATE
// ====================================================

jump_released =
    false;


// ====================================================
// TIMERS
// ====================================================

cooldown_timer = 0;

respawn_timer = 0;

respawn_frames =
    max(
        1,
        round(
            respawn_grow_time_s *
            room_speed
        )
    );


// ====================================================
// VISUAL ANIMATION
// ====================================================

visual_time =
    random(1000);

visual_scale_x = 1;
visual_scale_y = 1;

visual_offset_y = 0;

visual_alpha = 1;


// ====================================================
// CAPTURE STATE
// ====================================================

capture_arrived =
    false;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spriteBubbleIdle;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_angle = 0;
image_alpha = 1;