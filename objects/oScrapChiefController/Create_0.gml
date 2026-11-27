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

travel_distance = 11650;

startup_seconds = 1;
intro_seconds = 5;

phase1_seconds = 35;
overheat1_seconds = 8;
phase1_overheat_prep_seconds = 33;
phase1_overheat_retry_seconds = 1.0;
phase1_overheat_started = false;
phase1_overheat_retry_timer = 0;

phase2_seconds = 40;
overheat2_seconds = 8;

phase3_seconds = 40;
overheat3_seconds = 8;

gnash_seconds = 18;
dock_seconds = 12;


// ====================================================
// MOVEMENT SPEED
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
// ====================================================

elevator_state = 0;

sequence_active = false;
sequence_complete = false;

boss_active = false;

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
// SMOOTH CAMERA TRANSITIONS
//
// 0 = normal elevator camera
// 1 = entering elevator camera
// 2 = returning to player camera
// ====================================================

camera_enter_seconds = 0.5;
camera_exit_seconds = 0.8;

camera_transition_mode = 0;

camera_transition_frame = 0;
camera_transition_frames = 1;

camera_transition_start_x = 0;
camera_transition_start_y = 0;


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
// PHASE 1 — DEMOLITION CONFIGURATION
// ====================================================

phase1_slam_times = [
    0,
    5,
    10,
    16
];

phase1_slam_balls = [
    0,
    0,
    1,
    1
];

slam_targeting_seconds = 1;
slam_targeting_timeout = 3;


// ====================================================
// SHARED CARRIAGE FORMATION
// ====================================================

formation_offset_x = 0;
formation_target_x = 0;

formation_speed = 0;

formation_max_speed = 6;

formation_acceleration = 0.25;
formation_deceleration = 0.35;

formation_active = false;

formation_target_tolerance = 3;


// ====================================================
// PHASE 1 — DEMOLITION STATE
//
// 0 = Waiting
// 1 = Targeting
// 2 = Slamming
// 3 = Returning to formation
// 4 = Complete
// ====================================================

phase1_attack_state = 0;

phase1_attack_index = 0;
phase1_attack_timer = 0;

phase1_attacking_ball = noone;

phase1_demolition_complete = false;


// ====================================================
// PHASE 1 — SPITTING CONFIGURATION
// ====================================================

phase1_spit_count = 6;

phase1_spit_interval_seconds = 2.0;

phase1_spit_start_seconds = 21;

phase1_spit_cutoff_seconds = 33;


// ====================================================
// PHASE 1 — SPITTING STATE
// ====================================================

phase1_spit_index = 0;

phase1_spit_timer = 0;

phase1_spitting_complete = false;


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

    return max(
        1,
        round(seconds * room_speed)
    );
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
// RESET PHASE 1 DEMOLITION
// ====================================================

reset_phase1_attacks = function()
{
    phase1_overheat_started = false;
    phase1_overheat_retry_timer = 0;
    phase1_attack_state = 0;

    phase1_attack_index = 0;
    phase1_attack_timer = 0;

    phase1_attacking_ball = noone;

    phase1_demolition_complete = false;

    formation_offset_x = 0;
    formation_target_x = 0;

    formation_speed = 0;

    formation_active = false;
};


// ====================================================
// RESET PHASE 1 SPITTING
// ====================================================

reset_phase1_spitting = function()
{
    phase1_spit_index = 0;

    phase1_spit_timer = 0;

    phase1_spitting_complete = false;
};


// ====================================================
// FIND DEMOLITION BALL
// ====================================================

find_demolition_ball = function(_ball_id)
{
    var count = instance_number(
        oScrapChiefDemolitionBall
    );

    for (var i = 0; i < count; i++)
    {
        var b = instance_find(
            oScrapChiefDemolitionBall,
            i
        );

        if (b.ball_id == _ball_id)
        {
            return b;
        }
    }

    return noone;
};


// ====================================================
// CHECK CARRIAGE READINESS
// ====================================================

carriages_ready = function()
{
    var count = instance_number(
        oScrapChiefRailCarriage
    );

    if (count < 3)
    {
        return false;
    }

    for (var i = 0; i < count; i++)
    {
        var c = instance_find(
            oScrapChiefRailCarriage,
            i
        );

        if (
            !c.entrance_complete ||
            !c.visible
        )
        {
            return false;
        }
    }

    return true;
};


// ====================================================
// UPDATE SHARED FORMATION
// ====================================================

update_formation = function()
{
    var distance_x =
        formation_target_x -
        formation_offset_x;

    var braking_speed = sqrt(
        2 *
        formation_deceleration *
        abs(distance_x)
    );

    var speed_limit = formation_max_speed;

    if ((elevator_state == 5 || (elevator_state == 6 && phase2_retry)) &&
        phase2_cycle > 0 && phase2_spread > 0)
    {
        speed_limit = phase2_cycle == 1 ? phase2_sweep_speed : phase2_combined_sweep_speed;
    }

    var desired_speed =
        sign(distance_x) *
        min(
            speed_limit,
            braking_speed
        );

    var speed_change =
        formation_acceleration;

    if (
        abs(desired_speed) <
        abs(formation_speed) ||

        desired_speed *
        formation_speed < 0
    )
    {
        speed_change =
            formation_deceleration;
    }

    formation_speed += clamp(
        desired_speed - formation_speed,
        -speed_change,
        speed_change
    );

    if (
        abs(distance_x) <= 0.1 ||

        (
            sign(formation_speed) ==
            sign(distance_x) &&

            abs(formation_speed) >=
            abs(distance_x)
        )
    )
    {
        formation_offset_x =
            formation_target_x;

        formation_speed = 0;
    }
    else
    {
        formation_offset_x +=
            formation_speed;
    }
};


// ====================================================
// GET DEMOLITION SLAM TARGET
// ====================================================

get_slam_target = function(_ball)
{
    if (!instance_exists(_ball))
    {
        return formation_offset_x;
    }

    if (!instance_exists(_ball.carriage))
    {
        return formation_offset_x;
    }

    if (!instance_exists(platform))
    {
        return formation_offset_x;
    }

    var p = instance_find(
        oPlayer,
        0
    );

    if (p == noone)
    {
        return formation_offset_x;
    }

    var player_centre_x =
        (p.bbox_left + p.bbox_right) * 0.5;

    var elevator_centre_x =
        (platform.bbox_left +
         platform.bbox_right) * 0.5;

    player_centre_x = clamp(
        player_centre_x,

        platform.bbox_left +
        platform.surface_inset_left,

        platform.bbox_right -
        platform.surface_inset_right
    );

    return
        player_centre_x -
        elevator_centre_x -
        _ball.carriage.elevator_offset_x;
};


// ====================================================
// UPDATE PHASE 1 DEMOLITION ATTACKS
// ====================================================

update_phase1_attacks = function()
{
    var phase_elapsed =
        (
            get_state_frames(3) -
            state_timer
        ) / room_speed;

    switch (phase1_attack_state)
    {
        // ========================================
        // STATE 0 — WAITING FOR NEXT SLAM
        // ========================================

        case 0:
        {
            if (
                phase1_attack_index >=
                array_length(phase1_slam_times)
            )
            {
                phase1_attack_state = 3;

                formation_target_x = 0;

                break;
            }

            if (
                phase_elapsed <
                phase1_slam_times[
                    phase1_attack_index
                ]
            )
            {
                break;
            }


            // ------------------------------------
            // Wait for Chief's intro roar.
            // ------------------------------------

            var chief = instance_find(
                oScrapChief,
                0
            );

            if (chief == noone)
            {
                break;
            }

            if (!chief.intro_roar_complete)
            {
                break;
            }

            if (!carriages_ready())
            {
                break;
            }


            // ------------------------------------
            // Select demolition ball.
            // ------------------------------------

            phase1_attacking_ball =
                find_demolition_ball(
                    phase1_slam_balls[
                        phase1_attack_index
                    ]
                );

            if (
                !instance_exists(
                    phase1_attacking_ball
                )
            )
            {
                break;
            }

            if (
                !phase1_attacking_ball.active ||
                !phase1_attacking_ball.visible ||
                !phase1_attacking_ball.chain_attached
            )
            {
                break;
            }


            // ------------------------------------
            // Begin targeting.
            // ------------------------------------

            formation_active = true;

            phase1_attack_timer = 0;

            phase1_attack_state = 1;

            show_debug_message(
                "SCRAP CHIEF: Targeting with ball " +
                string(
                    phase1_attacking_ball.ball_id
                )
            );

            break;
        }


        // ========================================
        // STATE 1 — TARGETING PLAYER
        // ========================================

        case 1:
        {
            if (
                !instance_exists(
                    phase1_attacking_ball
                )
            )
            {
                phase1_attack_state = 0;

                break;
            }

            phase1_attack_timer++;

            formation_target_x =
                get_slam_target(
                    phase1_attacking_ball
                );

            var minimum_frames = round(
                slam_targeting_seconds *
                room_speed
            );

            var maximum_frames = round(
                slam_targeting_timeout *
                room_speed
            );

            var target_reached =
                abs(
                    formation_target_x -
                    formation_offset_x
                ) <= formation_target_tolerance;


            // ------------------------------------
            // Lock position and begin slam.
            // ------------------------------------

            if (
                (
                    phase1_attack_timer >=
                    minimum_frames &&

                    target_reached
                ) ||

                phase1_attack_timer >=
                maximum_frames
            )
            {
                formation_target_x =
                    formation_offset_x;

                formation_speed = 0;

                if (
                    phase1_attacking_ball.begin_slam()
                )
                {
                    phase1_attack_state = 2;

                    phase1_attack_timer = 0;

                    show_debug_message(
                        "SCRAP CHIEF: Slam " +
                        string(
                            phase1_attack_index + 1
                        ) +
                        " started."
                    );
                }
            }

            break;
        }


        // ========================================
        // STATE 2 — WAIT FOR SLAM COMPLETION
        // ========================================

        case 2:
        {
            if (
                !instance_exists(
                    phase1_attacking_ball
                )
            )
            {
                phase1_attack_state = 0;

                break;
            }

            if (
                phase1_attacking_ball.slam_complete
            )
            {
                show_debug_message(
                    "SCRAP CHIEF: Slam " +
                    string(
                        phase1_attack_index + 1
                    ) +
                    " complete."
                );

                phase1_attack_index++;

                phase1_attacking_ball = noone;

                phase1_attack_timer = 0;

                if (
                    phase1_attack_index >=
                    array_length(phase1_slam_times)
                )
                {
                    formation_target_x = 0;

                    phase1_attack_state = 3;
                }
                else
                {
                    phase1_attack_state = 0;
                }
            }

            break;
        }


        // ========================================
        // STATE 3 — RETURN TO NORMAL FORMATION
        // ========================================

        case 3:
        {
            formation_target_x = 0;

            if (
                abs(formation_offset_x) <= 0.1 &&
                abs(formation_speed) <= 0.1
            )
            {
                formation_offset_x = 0;

                formation_speed = 0;

                phase1_demolition_complete = true;

                phase1_attack_state = 4;

                show_debug_message(
                    "SCRAP CHIEF: Phase 1 demolition complete."
                );
            }

            break;
        }


        // ========================================
        // STATE 4 — DEMOLITION COMPLETE
        // ========================================

        case 4:
        {
            formation_target_x = 0;

            break;
        }
    }
};


// ====================================================
// UPDATE PHASE 1 SPITTING
// ====================================================

update_phase1_spitting = function()
{
    if (phase1_spitting_complete)
    {
        return;
    }

    if (!phase1_demolition_complete)
    {
        return;
    }

    var chief = instance_find(
        oScrapChief,
        0
    );

    if (chief == noone)
    {
        return;
    }


    // --------------------------------------------
    // Phase timing
    // --------------------------------------------

    var phase_elapsed =
        (
            get_state_frames(3) -
            state_timer
        ) / room_speed;


    // --------------------------------------------
    // Stop scheduling new attacks before overheat.
    // --------------------------------------------

    if (
        phase_elapsed >=
        phase1_spit_cutoff_seconds
    )
    {
        if (!chief.spit_active)
        {
            phase1_spitting_complete = true;
        }

        return;
    }


    // --------------------------------------------
    // Wait for intended start time.
    // --------------------------------------------

    if (
        phase_elapsed <
        phase1_spit_start_seconds
    )
    {
        return;
    }


    // --------------------------------------------
    // Attack interval
    // --------------------------------------------

    if (phase1_spit_timer > 0)
    {
        phase1_spit_timer--;
    }


    // --------------------------------------------
    // All attacks completed
    // --------------------------------------------

    if (
        phase1_spit_index >=
        phase1_spit_count
    )
    {
        if (!chief.spit_active)
        {
            phase1_spitting_complete = true;

            show_debug_message(
                "SCRAP CHIEF: Phase 1 spitting complete."
            );
        }

        return;
    }


    // --------------------------------------------
    // Wait for previous animation and interval.
    // --------------------------------------------

    if (
        chief.spit_active ||
        phase1_spit_timer > 0
    )
    {
        return;
    }


    // --------------------------------------------
    // Begin targeted spit
    // --------------------------------------------

    if (chief.begin_spit_attack(0))
    {
        phase1_spit_index++;

        phase1_spit_timer = max(
            1,
            round(
                phase1_spit_interval_seconds *
                room_speed
            )
        );

        show_debug_message(
            "SCRAP CHIEF: Spit " +
            string(phase1_spit_index) +
            " / " +
            string(phase1_spit_count)
        );
    }
};


// ====================================================
// START ELEVATOR
// ====================================================

start_elevator = function()
{
    if (sequence_active)
    {
        return;
    }

    if (!instance_exists(platform))
    {
        platform = instance_find(
            oScrapChiefElevator,
            0
        );
    }

    if (!instance_exists(platform))
    {
        return;
    }


    // --------------------------------------------
    // Starting position
    // --------------------------------------------

    start_platform_x = platform.x;
    start_platform_y = platform.y;

    end_platform_x =
        start_platform_x + travel_distance;


    // --------------------------------------------
    // Capture actual current camera position
    // --------------------------------------------

    camera_x = camera_get_view_x(cam);
    camera_y = camera_get_view_y(cam);
    camera_base_y = camera_y;


    // --------------------------------------------
    // Centre elevator horizontally
    // --------------------------------------------

    var platform_centre_x =
        (platform.bbox_left +
         platform.bbox_right) * 0.5;

    camera_platform_offset_x =
        platform.x -
        platform_centre_x +
        view_w * 0.5;


    // --------------------------------------------
    // Begin smooth camera entry
    // --------------------------------------------

    camera_transition_mode = 1;

    camera_transition_frame = 0;

    camera_transition_frames = max(
        1,
        round(camera_enter_seconds * room_speed)
    );

    camera_transition_start_x = camera_x;
    camera_transition_start_y = camera_y;


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

    boss_active = false;

    elevator_state = 0;

    state_timer = 0;
    total_timer = 0;

    platform_move_x = 0;
	
	hp = max_hp;

    current_speed = 0;
    target_speed = 0;

    camera_override_active = false;

    reset_camera_zoom();


    // --------------------------------------------
    // Reset all Phase 1 attacks
    // --------------------------------------------

    reset_phase1_attacks();

    reset_phase1_spitting();
    reset_phase2();


    // --------------------------------------------
    // Remove remaining spit projectiles
    // --------------------------------------------

    with (oScrapChiefSpitProjectile)
    {
        instance_destroy();
    }


    // --------------------------------------------
    // Cancel camera transition
    // --------------------------------------------

    camera_transition_mode = 0;
    camera_transition_frame = 0;


    // --------------------------------------------
    // Reset platform
    // --------------------------------------------

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

        if (
            platform.elevator_loop_instance !=
            noone
        )
        {
            audio_stop_sound(
                platform.elevator_loop_instance
            );

            platform.elevator_loop_instance =
                noone;
        }
    }


    // --------------------------------------------
    // Reset death zone
    // --------------------------------------------

    if (instance_exists(elevator_death_zone))
    {
        elevator_death_zone.follow_active =
            false;

        elevator_death_zone.follow_target =
            noone;

        elevator_death_zone.x =
            death_zone_start_x;

        elevator_death_zone.y =
            death_zone_start_y;

        elevator_death_zone.update_rect();
    }


    // --------------------------------------------
    // Reset elevator activation trigger
    // --------------------------------------------

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


    // --------------------------------------------
    // Reset boss activation trigger
    // --------------------------------------------

    with (oScrapChiefBossStartTrigger)
    {
        activated = false;
    }


    // --------------------------------------------
    // Reset rail carriages
    // --------------------------------------------

    with (oScrapChiefRailCarriage)
    {
        reset_carriage();
    }


    // --------------------------------------------
    // Reset demolition balls
    // --------------------------------------------

    with (oScrapChiefDemolitionBall)
    {
        reset_ball();
    }


    // --------------------------------------------
    // Synchronise normal camera
    // --------------------------------------------

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

// ====================================================
// BOSS HEALTH
// ====================================================

max_hp = 4;
hp = max_hp;


// ====================================================
// BOSS HEALTH BAR SETTINGS
// ====================================================

boss_bar_width = 240;
boss_bar_height = 12;
boss_bar_margin = 16;

boss_bar_on_right = true;

boss_bar_show_name = true;

// ====================================================
// BOSS CAMERA ZOOM — CONFIGURATION
// ====================================================

camera_normal_width = 640;
camera_normal_height = 360;
camera_boss_zoom = 1.15;
camera_zoom_out_seconds = 2.0;
camera_zoom_in_seconds = 2.0;
camera_zoom_vertical_bias = 0.5;

// ====================================================
// BOSS CAMERA ZOOM — STATE
// ====================================================

camera_zoom_progress = 0;
camera_zoom_current = 1.0;
camera_base_y = 0;

// ====================================================
// RESET CAMERA ZOOM
// ====================================================

reset_camera_zoom = function()
{
    camera_zoom_progress = 0;
    camera_zoom_current = 1.0;

    view_w = camera_normal_width;
    view_h = camera_normal_height;

    camera_set_view_size(cam, view_w, view_h);
};

// ====================================================
// PHASE 2 — DEMOLITION SWEEPS
// ====================================================
phase2_extra_spacing = 12;
phase2_sweep_speed = 1.1;
// First sweep choreography (seconds from Phase 2 start).
phase2_first_left_time = 7;
phase2_first_right_time = 12;
phase2_first_centre_time = 14.7;
phase2_first_sway_pixels = 10;
// Space between the ledge and the trailing ball at each extreme.
phase2_first_left_edge_gap = 112;
phase2_first_right_edge_gap = 56;
phase2_first_sway_seconds = 0.9;
phase2_first_start_x = 0;
phase2_first_started = false;
    phase2_second_started = false;
    phase2_second_start_x = 0;
phase2_combined_sweep_speed = 1.2;
phase2_edge_barrier_inset = 24;
phase2_edge_position_speed = 3.0;
phase2_spacing_speed = 1.5;
phase2_sweep_margin = -24;
phase2_drag_lag = 12;
phase2_drop_speed = 14;
phase2_drop_gravity = 2.5;
phase2_drag_extra_chain = 24;
phase2_spread = 0;
phase2_sweep_direction = 1;
phase2_cycle = 0;
phase2_barrage_index = 0;
phase2_overheat_started = false;
phase2_retry = false;
phase2_retry_frame = 0;
phase2_original_offsets = [];
phase2_carriages = [];
phase2_barrage_times = [24, 28, 32];

reset_phase2 = function()
{
    for (var i = 0; i < array_length(phase2_carriages); i++)
    {
        var c = phase2_carriages[i];
        if (instance_exists(c)) c.elevator_offset_x = phase2_original_offsets[i];
    }
    phase2_carriages = [];
    phase2_original_offsets = [];
    phase2_spread = 0;
    phase2_cycle = 0;
    phase2_barrage_index = 0;
    phase2_overheat_started = false;
    phase2_retry = false;
    phase2_retry_frame = 0;
    phase2_sweep_direction = 1;
    phase2_first_started = false;
    phase2_second_started = false;
    phase2_second_start_x = 0;
    phase2_first_start_x = 0;
};

phase2_capture = function()
{
    if (array_length(phase2_carriages) > 0) return true;
    if (!carriages_ready()) return false;
    for (var i = 0; i < instance_number(oScrapChiefRailCarriage); i++)
    {
        var c = instance_find(oScrapChiefRailCarriage, i);
        array_push(phase2_carriages, c);
        array_push(phase2_original_offsets, c.elevator_offset_x);
    }
    return true;
};

phase2_set_spread = function(_target)
{
    phase2_spread += clamp(_target - phase2_spread, -phase2_spacing_speed, phase2_spacing_speed);
    var centre = 0;
    for (var i = 0; i < array_length(phase2_carriages); i++)
    {
        if (phase2_carriages[i].payload_type == 1) centre = phase2_original_offsets[i];
    }
    for (var i = 0; i < array_length(phase2_carriages); i++)
    {
        var c = phase2_carriages[i];
        c.elevator_offset_x = phase2_original_offsets[i] + sign(phase2_original_offsets[i] - centre) * phase2_spread;
    }
};

phase2_bounds = function()
{
    var centre = (platform.bbox_left + platform.bbox_right) * 0.5;
    var lo = -100000;
    var hi = 100000;
    for (var i = 0; i < 2; i++)
    {
        var b = find_demolition_ball(i);
        if (!instance_exists(b) || !instance_exists(b.carriage)) continue;
        var off = b.carriage.elevator_offset_x;
        lo = max(lo, platform.bbox_left + platform.surface_inset_left - centre - off + b.ball_attach_offset_x + phase2_sweep_margin);
        hi = min(hi, platform.bbox_right - platform.surface_inset_right - centre - off - (b.ball_width - b.ball_attach_offset_x) - phase2_sweep_margin);
    }
    if (lo > hi) return [(lo + hi) * 0.5, (lo + hi) * 0.5];
    return [lo, hi];
};

// First sweep only: allow the leading ball beyond the ledge.
phase2_first_bounds = function(_normal_bounds)
{
    var centre = (platform.bbox_left + platform.bbox_right) * 0.5;
    var left_ball = noone;
    var right_ball = noone;
    for (var i = 0; i < 2; i++)
    {
        var b = find_demolition_ball(i);
        if (!instance_exists(b) || !instance_exists(b.carriage)) return _normal_bounds;
        if (left_ball == noone || b.carriage.elevator_offset_x < left_ball.carriage.elevator_offset_x) left_ball = b;
        if (right_ball == noone || b.carriage.elevator_offset_x > right_ball.carriage.elevator_offset_x) right_ball = b;
    }
    var left_edge = platform.bbox_left + platform.surface_inset_left;
    var right_edge = platform.bbox_right - platform.surface_inset_right;
    // Leftward sweep: inner edge of the RIGHT ball approaches left ledge.
    var lo = left_edge + phase2_first_left_edge_gap - centre
        - right_ball.carriage.elevator_offset_x + right_ball.ball_attach_offset_x;
    // Rightward sweep: inner edge of the LEFT ball approaches right ledge.
    var hi = right_edge - phase2_first_right_edge_gap - centre
        - left_ball.carriage.elevator_offset_x
        - (left_ball.ball_width - left_ball.ball_attach_offset_x);
    return [min(lo, _normal_bounds[0]), max(hi, _normal_bounds[1])];
};

phase2_drop = function()
{
    for (var i = 0; i < 2; i++)
    {
        var b = find_demolition_ball(i);
        if (!instance_exists(b)) return false;
        if (!b.active || !b.visible || !b.chain_attached || b.slam_state != 0 || !instance_exists(b.chain)) return false;
    }
    for (var i = 0; i < 2; i++)
    {
        var b = find_demolition_ball(i);
        b.begin_slam();
        b.phase2_drag = true;
        b.begin_slam_descent();
        b.chain.extend_speed = phase2_drop_speed;
        b.chain.payload_gravity = phase2_drop_gravity;
        b.chain.set_chain_length(b.chain.target_length + phase2_drag_extra_chain);
    }
    return true;
};

phase2_retract = function()
{
    for (var i = 0; i < 2; i++)
    {
        var b = find_demolition_ball(i);
        if (!instance_exists(b)) continue;
        b.phase2_drag = false;
        if (b.slam_state != 0 && b.slam_state != 4) b.begin_slam_retraction();
    }
};

phase2_balls_ready = function()
{
    for (var i = 0; i < 2; i++)
    {
        var b = find_demolition_ball(i);
        if (!instance_exists(b) || !b.slam_complete) return false;
    }
    return true;
};

update_phase2 = function(_t, _chief)
{
    if (!phase2_capture()) return;
    formation_active = true;
    // Retry uses the second sweep only, on a stationary elevator.
    // Second half: fixed edge barriers and spaced scrap barrages.
    if (_t >= 18)
    {
        formation_target_x = 0;
        var edge_hold = _t < 35;
        var centre = (platform.bbox_left + platform.bbox_right) * 0.5;
        var left_ball = find_demolition_ball(0);
        var right_ball = find_demolition_ball(1);
        if (instance_exists(left_ball) && instance_exists(right_ball) &&
            instance_exists(left_ball.carriage) && instance_exists(right_ball.carriage))
        {
            if (left_ball.carriage.elevator_offset_x > right_ball.carriage.elevator_offset_x)
            {
                var swap_ball = left_ball;
                left_ball = right_ball;
                right_ball = swap_ball;
            }
            var ready = true;
            for (var i = 0; i < array_length(phase2_carriages); i++)
            {
                var car = phase2_carriages[i];
                var target = phase2_original_offsets[i];
                if (edge_hold)
                {
                    if (car == left_ball.carriage)
                        target = platform.bbox_left + platform.surface_inset_left - centre + left_ball.ball_attach_offset_x - left_ball.ball_width + phase2_edge_barrier_inset;
                    else if (car == right_ball.carriage)
                        target = platform.bbox_right - platform.surface_inset_right - centre + right_ball.ball_attach_offset_x - phase2_edge_barrier_inset;
                }
                car.elevator_offset_x += clamp(target - car.elevator_offset_x, -phase2_edge_position_speed, phase2_edge_position_speed);
                if (abs(target - car.elevator_offset_x) > 0.1) ready = false;
            }
            phase2_spread = edge_hold || !ready ? phase2_extra_spacing : 0;
            if (_t >= 21 && edge_hold && ready && phase2_cycle != 2)
            {
                if (phase2_drop()) phase2_cycle = 2;
            }
            if (_t >= 22 && edge_hold && phase2_cycle == 2 &&
                left_ball.slam_state == 3 && right_ball.slam_state == 3 && instance_exists(_chief))
            {
                if (phase2_barrage_index < array_length(phase2_barrage_times))
                {
                    if (_t >= phase2_barrage_times[phase2_barrage_index])
                    {
                        if (!_chief.spit_active)
                        {
                            _chief.barrage_count = phase2_barrage_index == 0 ? 4 : 5;
                            _chief.barrage_pattern = phase2_barrage_index;
                            if (_chief.begin_spit_attack(1)) phase2_barrage_index++;
                        }
                    }
                }
            }
        }
        if (!edge_hold) phase2_retract();
        if (_t >= 38 && !phase2_overheat_started && instance_exists(_chief))
        {
            if (phase2_balls_ready() && abs(formation_offset_x) <= 0.1 && phase2_spread <= 0.1 && !_chief.spit_active)
                if (_chief.begin_overheat()) phase2_overheat_started = true;
        }
        return;
    }
    var t = _t;
    var targeting = (t < 3 || (t >= 18 && t < 21));
    var dragging = (t >= 3 && t < 15) || (t >= 21 && t < 35);
    var spread = targeting || dragging;
    phase2_set_spread(spread ? phase2_extra_spacing : 0);
    var bounds = phase2_bounds();
    if (targeting)
    {
        // Both sweeps prepare at the elevator centre, not the player.
        formation_target_x = 0;
    }
    else if (dragging)
    {
        var cycle = t < 15 ? 1 : 2;
        if (phase2_cycle != cycle)
        {
            if (phase2_drop())
            {
                phase2_cycle = cycle;
                if (cycle == 2) phase2_second_started = false;
                phase2_sweep_direction = formation_offset_x > (bounds[0] + bounds[1]) * 0.5 ? -1 : 1;
            }
        }
        if (phase2_cycle == cycle && t >= (cycle == 1 ? 4 : 22))
        {
                bounds = phase2_first_bounds(bounds);
                // Capture the formation after the simultaneous drop.
                if (cycle == 1 && !phase2_first_started)
                {
                    phase2_first_started = true;
                    phase2_first_start_x = formation_offset_x;
                }

                if (cycle == 2 && !phase2_second_started)
                {
                    phase2_second_started = true;
                    phase2_second_start_x = formation_offset_x;
                }
                var sweep_t = t - (cycle == 2 ? 18 : 0);
                // One deliberate left -> right -> centre traversal.
                // A small oscillation is superimposed on each leg.
                var leg_start;
                var leg_end;
                var leg_from;
                var leg_to;
                var middle = clamp(0, bounds[0], bounds[1]);

                if (sweep_t < phase2_first_left_time)
                {
                    leg_start = 4;
                    leg_end = phase2_first_left_time;
                    leg_from = cycle == 1 ? phase2_first_start_x : phase2_second_start_x;
                    leg_to = bounds[0];
                }
                else if (sweep_t < phase2_first_right_time)
                {
                    leg_start = phase2_first_left_time;
                    leg_end = phase2_first_right_time;
                    leg_from = bounds[0];
                    leg_to = bounds[1];
                }
                else
                {
                    leg_start = phase2_first_right_time;
                    leg_end = phase2_first_centre_time;
                    leg_from = bounds[1];
                    leg_to = middle;
                }

                // Slight look-ahead compensates for carriage acceleration.
                var u = clamp((sweep_t - leg_start + 0.20) / max(0.01, leg_end - leg_start), 0, 1);
                var sway = sin((sweep_t - leg_start) * 2 * pi / max(0.01, phase2_first_sway_seconds))
                    * phase2_first_sway_pixels * sin(pi * u);
                formation_target_x = clamp(lerp(leg_from, leg_to, u) + sway, bounds[0], bounds[1]);
        }
    }
    else
    {
        phase2_retract();
        formation_target_x = 0;
    }
    if (t >= 22 && t < 35 && instance_exists(_chief))
    {
        if (phase2_barrage_index < array_length(phase2_barrage_times))
        {
            if (t >= phase2_barrage_times[phase2_barrage_index] && _chief.begin_spit_attack(1)) phase2_barrage_index++;
        }
    }
    if (t >= 38 && !phase2_overheat_started && instance_exists(_chief))
    {
        if (phase2_balls_ready() && abs(formation_offset_x) <= 0.1 && phase2_spread <= 0.1 && !_chief.spit_active)
        {
            if (_chief.begin_overheat()) phase2_overheat_started = true;
        }
    }
};