/// oScrapChiefController — Create

// ====================================================
// CAMERA
// ====================================================

cam = view_camera[0];

view_w = 640;
view_h = 360;

camera_set_view_size(cam, view_w, view_h);


// ====================================================
// REFERENCES
// ====================================================

platform = instance_find(
    oScrapChiefElevator,
    0
);

activation_trigger = instance_find(
    oScrapChiefElevatorStartTrigger,
    0
);

elevator_death_zone = noone;


// ====================================================
// CONFIGURATION
// ====================================================

// Total horizontal travel.
travel_distance = 12200;

// Timings in seconds.
startup_seconds = 1;
intro_seconds = 5;

phase1_seconds = 35;
overheat1_seconds = 8;

phase2_seconds = 40;
overheat2_seconds = 8;

phase3_seconds = 40;
overheat3_seconds = 8;

gnash_seconds = 18;

dock_seconds = 12;


// ====================================================
// CALCULATE MOVEMENT SPEED
//
// Only moving stages count toward distance.
// Overheating and gnashing are stationary.
// ====================================================

moving_seconds =
    intro_seconds +
    phase1_seconds +
    phase2_seconds +
    phase3_seconds +
    dock_seconds;

base_speed =
    travel_distance /
    max(1, moving_seconds * room_speed);


// ====================================================
// STATE
//
// 0  = waiting
// 1  = startup
// 2  = intro / boss arrival placeholder
// 3  = phase 1
// 4  = overheat 1
// 5  = phase 2
// 6  = overheat 2
// 7  = phase 3
// 8  = overheat 3
// 9  = final gnashing
// 10 = victory docking
// 11 = complete
// ====================================================

elevator_state = 0;

sequence_active = false;
sequence_complete = false;

state_timer = 0;
total_timer = 0;

platform_move_x = 0;

current_speed = 0;
target_speed = 0;


// ====================================================
// POSITION
// ====================================================

start_platform_x = 0;
start_platform_y = 0;

end_platform_x = 0;


// ====================================================
// CAMERA OVERRIDE
// ====================================================

camera_override_active = false;

camera_x = 0;
camera_y = 0;

camera_platform_offset_x = 0;


// ====================================================
// DEATH ZONE
// ====================================================

death_zone_gap_y = 24;

death_zone_start_x = 0;
death_zone_start_y = 0;


// ====================================================
// STARTUP JOLTS
// ====================================================

startup_jolt_strength = 3;
startup_jolt_frames = 10;

engage_jolt_strength = 2;
engage_jolt_frames = 6;


// ====================================================
// DEBUG
// ====================================================

debug_elevator = true;


// ====================================================
// STATE NAMES
// ====================================================

state_names = [
    "WAITING",
    "STARTUP",
    "INTRO",
    "PHASE 1",
    "OVERHEAT 1",
    "PHASE 2",
    "OVERHEAT 2",
    "PHASE 3",
    "OVERHEAT 3",
    "FINAL GNASHING",
    "VICTORY / DOCKING",
    "COMPLETE"
];


// ====================================================
// STAGE DURATION HELPER
// ====================================================

get_state_frames = function(_state)
{
    var seconds = 0;

    switch (_state)
    {
        case 1: seconds = startup_seconds; break;
        case 2: seconds = intro_seconds; break;
        case 3: seconds = phase1_seconds; break;
        case 4: seconds = overheat1_seconds; break;
        case 5: seconds = phase2_seconds; break;
        case 6: seconds = overheat2_seconds; break;
        case 7: seconds = phase3_seconds; break;
        case 8: seconds = overheat3_seconds; break;
        case 9: seconds = gnash_seconds; break;
        case 10: seconds = dock_seconds; break;
    }

    return max(1, round(seconds * room_speed));
};


// ====================================================
// SET STATE
// ====================================================

set_state = function(_new_state)
{
    elevator_state = _new_state;

    state_timer = get_state_frames(_new_state);

    if (debug_elevator)
    {
        show_debug_message(
            "SCRAP CHIEF: " +
            state_names[_new_state]
        );
    }
};


// ====================================================
// START ELEVATOR
// ====================================================

start_elevator = function()
{
    if (sequence_active)
        return;

    if (!instance_exists(platform))
    {
        platform = instance_find(
            oScrapChiefElevator,
            0
        );
    }

    if (!instance_exists(platform))
        return;


    // --------------------------------------------
    // Starting position
    // --------------------------------------------

    start_platform_x = platform.x;
    start_platform_y = platform.y;

    end_platform_x =
        start_platform_x + travel_distance;


    // --------------------------------------------
// Camera offset
//
// Centre the elevator horizontally using
// its actual sprite/collision bounds.
// --------------------------------------------

camera_x = camera_get_view_x(cam);
camera_y = camera_get_view_y(cam);

var platform_centre_x =
    (platform.bbox_left + platform.bbox_right) * 0.5;

camera_platform_offset_x =
    platform.x -
    platform_centre_x +
    view_w * 0.5;


    // --------------------------------------------
    // Activate sequence
    // --------------------------------------------

    sequence_active = true;
    sequence_complete = false;

    total_timer = 0;

    current_speed = 0;
    target_speed = 0;

    platform_move_x = 0;

    camera_override_active = true;

    set_state(1);


    // --------------------------------------------
    // Initial machinery jolt
    // --------------------------------------------

    platform.jolt_strength =
        startup_jolt_strength;

    platform.jolt_timer =
        startup_jolt_frames;


    // --------------------------------------------
    // Death zone
    //
    // This prototype assumes one dedicated
    // oDeathZone in the boss room.
    // --------------------------------------------

    elevator_death_zone = instance_find(
        oDeathZone,
        0
    );

    if (instance_exists(elevator_death_zone))
    {
        death_zone_start_x =
            elevator_death_zone.x;

        death_zone_start_y =
            elevator_death_zone.y;

        elevator_death_zone.follow_target =
            platform;

        elevator_death_zone.follow_active =
            true;

        elevator_death_zone.follow_x =
            true;

        elevator_death_zone.follow_offset_x =
            elevator_death_zone.x - platform.x;

        elevator_death_zone.follow_gap_y =
            death_zone_gap_y;
    }


    // --------------------------------------------
    // Mark activation trigger used
    // --------------------------------------------

    if (instance_exists(activation_trigger))
    {
        activation_trigger.activated = true;
    }
};


// ====================================================
// RESET ELEVATOR
// ====================================================

reset_elevator = function()
{
    sequence_active = false;
    sequence_complete = false;

    elevator_state = 0;

    state_timer = 0;
    total_timer = 0;

    platform_move_x = 0;

    current_speed = 0;
    target_speed = 0;

    camera_override_active = false;


    if (instance_exists(platform))
    {
        platform.x = platform.start_x;
        platform.y = platform.start_y;

        platform.prev_x = platform.x;
        platform.prev_y = platform.y;

        platform.dx = 0;
        platform.dy = 0;

        platform.surface_y = platform.bbox_top;

        platform.visual_shake_x = 0;
        platform.visual_shake_y = 0;

        platform.engine_shake_timer = 0;

        platform.jolt_timer = 0;
        platform.jolt_strength = 0;

        if (platform.elevator_loop_instance != noone)
        {
            audio_stop_sound(
                platform.elevator_loop_instance
            );

            platform.elevator_loop_instance = noone;
        }
    }


    if (instance_exists(elevator_death_zone))
    {
        elevator_death_zone.follow_active = false;
        elevator_death_zone.follow_target = noone;

        elevator_death_zone.x =
            death_zone_start_x;

        elevator_death_zone.y =
            death_zone_start_y;

        elevator_death_zone.update_rect();
    }


    if (!instance_exists(activation_trigger))
    {
        activation_trigger = instance_find(
            oScrapChiefElevatorStartTrigger,
            0
        );
    }

    if (instance_exists(activation_trigger))
    {
        activation_trigger.activated = false;
    }


    var normal_camera = instance_find(
        oCamera,
        0
    );

    if (normal_camera != noone)
    {
        normal_camera.arena_lock_active = false;
        normal_camera.arena_was_locked = false;
        normal_camera.arena_release_frames = 0;

        normal_camera.cam_logic_x =
            camera_get_view_x(cam);

        normal_camera.cam_logic_y =
            camera_get_view_y(cam);
    }
};