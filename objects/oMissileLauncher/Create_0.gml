/// oMissileLauncher — Create

// ====================================================
// GENERAL
// ====================================================

depth = -900;
visible = true;

sprite_index = spriteMissileLauncher;
image_speed = 0;

// Briefly display 100% while the silo opens.
launch_ui_hold_timer = 0;

// Set true by the arena trigger after this arena is cleared.
arena_disabled = false;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "direction"))
{
    direction = -1;
}

if (!variable_instance_exists(id, "cable_repeats"))
{
    cable_repeats = 5;
}

if (!variable_instance_exists(id, "base_charge_time_s"))
{
    base_charge_time_s = 1.5;
}

if (!variable_instance_exists(id, "cable_time_per_repeat_s"))
{
    cable_time_per_repeat_s = 0.15;
}

if (!variable_instance_exists(id, "charge_drain_multiplier"))
{
    charge_drain_multiplier = 3.0;
}

if (!variable_instance_exists(id, "launcher_anim_speed"))
{
    launcher_anim_speed = 0.18;
}

if (!variable_instance_exists(id, "launcher_open_hold_s"))
{
    launcher_open_hold_s = 0.20;
}

if (!variable_instance_exists(id, "reset_time_s"))
{
    reset_time_s = 0.75;
}

if (!variable_instance_exists(id, "missile_speed"))
{
    missile_speed = 7.0;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// NORMALIZE
// ====================================================

direction =
    (direction < 0)
    ? -1
    : 1;

cable_repeats =
    max(
        1,
        round(cable_repeats)
    );

base_charge_time_s =
    max(
        0.1,
        base_charge_time_s
    );

cable_time_per_repeat_s =
    max(
        0,
        cable_time_per_repeat_s
    );

charge_drain_multiplier =
    max(
        0.1,
        charge_drain_multiplier
    );

launcher_anim_speed =
    max(
        0.01,
        launcher_anim_speed
    );

launcher_open_hold_s =
    max(
        0,
        launcher_open_hold_s
    );

reset_time_s =
    max(
        0,
        reset_time_s
    );

missile_speed =
    max(
        0.1,
        missile_speed
    );


// ====================================================
// SPRITE INFORMATION
// ====================================================

cable_width =
    sprite_get_width(
        spriteMissileLauncherConnectingCable
    );

cable_height =
    sprite_get_height(
        spriteMissileLauncherConnectingCable
    );

plate_width =
    sprite_get_width(
        spritePressurePlate
    );

plate_height =
    sprite_get_height(
        spritePressurePlate
    );

launcher_width =
    sprite_get_width(
        spriteMissileLauncher
    );

launcher_height =
    sprite_get_height(
        spriteMissileLauncher
    );


// ====================================================
// LAYOUT
// ====================================================

cable_gap = 0;

cable_start_offset =
    launcher_width * 0.5;

cable_step =
    cable_width +
    cable_gap;

cable_total_width =
    cable_repeats *
    cable_step;


// ====================================================
// PRESSURE PLATE POSITION
// ====================================================

plate_offset_x =
    cable_start_offset
    +
    cable_total_width
    +
    plate_width * 0.5;

plate_x =
    x +
    direction *
    plate_offset_x;

plate_y = y;


// ====================================================
// PRESSURE PLATE ACTIVATION ZONE
// ====================================================

plate_trigger_height = 6;
plate_trigger_width_scale = 0.78;

// Visual depression.
plate_press_depth = 3;
plate_visual_offset = 0;
plate_visual_target = 0;
plate_visual_lerp = 0.40;


// ====================================================
// PRESSURE PLATE ANIMATION
// ====================================================

plate_anim_position = 0;
plate_anim_speed = 0.25;


// ====================================================
// CHARGE
// ====================================================

launch_progress = 0;

total_charge_time_s =
    base_charge_time_s
    +
    (
        cable_repeats *
        cable_time_per_repeat_s
    );

total_charge_frames =
    max(
        1,
        round(
            total_charge_time_s *
            room_speed
        )
    );

charge_per_frame =
    1 /
    total_charge_frames;

drain_per_frame =
    charge_per_frame *
    charge_drain_multiplier;


// ====================================================
// STATE
//
// 0 = READY
// 1 = CHARGING
// 2 = OPENING
// 3 = FIRING
// 4 = CLOSING
// 5 = RESET
// ====================================================

MISSILE_READY = 0;
MISSILE_CHARGING = 1;
MISSILE_OPENING = 2;
MISSILE_FIRING = 3;
MISSILE_CLOSING = 4;
MISSILE_RESET = 5;

missile_state =
    MISSILE_READY;


// ====================================================
// LAUNCHER FRAMES
// ====================================================

launcher_closed_frame = 0;
launcher_open_frame = 2;
launcher_final_closed_frame = 4;

launcher_anim_position =
    launcher_closed_frame;

image_index =
    launcher_closed_frame;


// ====================================================
// FIRING
// ====================================================

missile_fired = false;
open_hold_timer = 0;
reset_timer = 0;


// ====================================================
// REARM
// ====================================================

needs_plate_release = false;


// ====================================================
// CABLE VISUALS
// ====================================================

cable_power_pulse = 0;


// ====================================================
// GUI
// ====================================================

show_launch_bar = false;

launch_bar_width = 76;
launch_bar_height = 6;
launch_bar_y_offset = 32;


// ====================================================
// PLAYER STATUS
// ====================================================

player_on_plate = false;


// ====================================================
// PHYSICAL SOLIDS
// ====================================================

silo_solid = instance_create_depth(
    x,
    y,
    depth + 1,
    oMissileLauncherSolid
);

silo_solid.owner_launcher = id;

plate_solid = instance_create_depth(
    plate_x,
    plate_y,
    depth + 1,
    oPressurePlateSolid
);

plate_solid.owner_launcher = id;