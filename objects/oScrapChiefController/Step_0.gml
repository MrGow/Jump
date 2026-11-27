/// oScrapChiefController — Step
if (scr_game_frozen()) { platform_move_x = 0; exit; }
if (!instance_exists(platform)) platform = instance_find(oScrapChiefElevator, 0);
if (!instance_exists(platform)) { platform_move_x = 0; exit; }
if (elevator_state == 0)
{
    platform_move_x = 0;
    reset_phase1_attacks();
    reset_phase1_spitting();
    reset_phase2();
    exit;
}
if (elevator_state == 11) { platform_move_x = 0; exit; }
total_timer++;
state_timer = max(0, state_timer - 1);
var should_move = elevator_state == 2 || elevator_state == 3 || elevator_state == 5 || elevator_state == 7 || elevator_state == 10;
if (should_move)
{
    target_speed = base_speed;
    current_speed = base_speed;
    var remaining = end_platform_x - platform.x;
    platform_move_x = min(current_speed, max(0, remaining));
}
else { target_speed = 0; current_speed = 0; platform_move_x = 0; }
if (elevator_state == 1 && state_timer <= 0)
{
    platform.jolt_strength = engage_jolt_strength;
    platform.jolt_timer = engage_jolt_frames;
}
var chief = instance_find(oScrapChief, 0);
if (elevator_state == 3 && boss_active)
{
    update_phase1_attacks();
    update_phase1_spitting();
    var phase_elapsed = (get_state_frames(3) - state_timer) / room_speed;
    if (phase_elapsed >= phase1_overheat_prep_seconds && phase1_demolition_complete && phase1_spitting_complete && !phase1_overheat_started && instance_exists(chief))
    {
        if (chief.begin_overheat())
        {
            phase1_overheat_started = true;
            show_debug_message("SCRAP CHIEF: Phase 1 overheat preparation.");
        }
    }
}
if (elevator_state == 5 && boss_active)
{
    update_phase2((get_state_frames(5) - state_timer) / room_speed, chief);
}
if (elevator_state == 6 && phase2_retry)
{
    phase2_retry_frame++;
    update_phase2(18 + phase2_retry_frame / room_speed, chief);
    if (phase2_retry_frame >= 22 * room_speed) phase2_retry = false;
}
if (formation_active) update_formation();
if (elevator_state == 4)
{
    if (!boss_active || !instance_exists(chief)) exit;
    if (phase1_overheat_started)
    {
        if (chief.overheat_complete && !chief.overheat_active)
        {
            if (chief.overheat_hit_success)
            {
                show_debug_message("SCRAP CHIEF: Eye hit confirmed. Starting Phase 2.");
                set_state(5);
            }
            else
            {
                phase1_overheat_started = false;
                phase1_overheat_retry_timer = max(1, round(phase1_overheat_retry_seconds * room_speed));
                show_debug_message("SCRAP CHIEF: Eye missed. Retrying overheat.");
            }
        }
        exit;
    }
    if (instance_exists(phase1_attacking_ball))
    {
        if (!phase1_attacking_ball.slam_complete) exit;
    }
    if (abs(formation_offset_x) > 0.1 || abs(formation_speed) > 0.1) exit;
    if (chief.spit_active) exit;
    if (phase1_overheat_retry_timer > 0) { phase1_overheat_retry_timer--; exit; }
    if (chief.begin_overheat()) phase1_overheat_started = true;
    exit;
}
if (elevator_state == 6)
{
    if (!boss_active || !instance_exists(chief) || phase2_retry) exit;
    if (phase2_overheat_started)
    {
        if (chief.overheat_complete && !chief.overheat_active)
        {
            if (chief.overheat_hit_success)
            {
                reset_phase2();
                set_state(7);
                show_debug_message("SCRAP CHIEF: Phase 2 eye hit. Starting Phase 3.");
            }
            else
            {
                phase2_overheat_started = false;
                phase2_retry = true;
                phase2_retry_frame = 0;
                phase2_cycle = 0;
                phase2_barrage_index = 0;
            }
        }
        exit;
    }
    phase2_retract();
    phase2_set_spread(0);
    formation_target_x = 0;
    if (phase2_balls_ready() && abs(formation_offset_x) <= 0.1 && abs(formation_speed) <= 0.1 && phase2_spread <= 0.1 && !chief.spit_active)
    {
        if (chief.begin_overheat()) phase2_overheat_started = true;
    }
    exit;
}
if (state_timer <= 0)
{
    if (elevator_state < 10)
    {
        if (elevator_state == 3)
        {
            formation_target_x = 0;
            if (!phase1_demolition_complete) show_debug_message("SCRAP CHIEF: WARNING - Phase 1 ended before demolition routine completed.");
            if (instance_exists(phase1_attacking_ball))
            {
                if (phase1_attacking_ball.slam_state != 0 && phase1_attacking_ball.slam_state != 4) phase1_attacking_ball.begin_slam_retraction();
            }
            if (!phase1_spitting_complete) show_debug_message("SCRAP CHIEF: WARNING - Phase 1 ended before spitting routine completed.");
        }
        if (elevator_state == 5)
        {
            phase2_retract();
            formation_target_x = 0;
        }
        set_state(elevator_state + 1);
    }
    else if (elevator_state == 10)
    {
        var remaining = end_platform_x - platform.x;
        if (remaining > 0.001) platform_move_x = remaining;
        else { platform_move_x = 0; sequence_complete = true; set_state(11); }
    }
}
